# DataSHIELD-SDE

## Background

This is an attempt to get DataSHIELD running in k8s. It is being developed across both minikube and the LSC Azure based k8s instance, so there are a few (!) incompatibilities that need to be worked through.

## Installation

The ``install_opal_stack.sh`` in ``/charts/opal`` should be enough to deploy everything in the ``/charts/opal/templates`` directory. Once it is spun up it will be available at the nodeport specified in the ``opal-service.yaml`` file, which ought to be made available via a reverse proxy. If all goes to plan then the R script in the ``/client`` folder should be useable.

Running the ``install_opal_stack.sh`` again when a file has been updated will upgrade the deployment.

Run ``uninstall_opal_stack.sh`` to uninstall it. Note PVs stay and will be reconnected (with their existing content) when new deployment done.

### Local environments

Using the `context` flag in the `values.yaml` file to switch between local and azure environments. Currently rolling out the `minikube` context. `AKS` will come later, and maybe `microk8s` if we want to go down that route.

#### Minikube

Storage - I've defined three Physical Volumes (one each for opal, mysql, mongodb) in ``/charts/opal/templates/olly_storage.yaml``. The claims on these sit in ``opal-storage.yaml`` etc. As long as the PV names remain the same it should be easy to swap this out for other environments.

Services - opal is the only service which needs to be accessible outside of the k8s cluster. I've specified nodeports here which are then picked up by a nginx reverse proxy sitting on the VM that minikube is running on. This is obviously clunky and I am not sure how to scale out.

#### Azure k8s

Most of these settings are in files which have been moved into ``/charts/VC``

Storage - azure backed storage.

Services - built in k8s loadbalancer?

## Dev work

- tidy up code base
- spin up two instances side by side
- finish templating the settings
- auto set up DS profile (needs a manual click now)
- should standard stuff like the DBs be in their own charts?
- Not 100% sure about the scope of the networking - is e.g. mysqldata-service only available in the deployemnt? Or the namespace? Other? Do I need to add these networking definitions (internal hostnames and ports) to the values file?
