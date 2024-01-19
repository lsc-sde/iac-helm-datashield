# DataSHIELD-SDE

## Background

This is an attempt to get DataSHIELD running in K8s. It is being developed across both minikube and the LSC Azure based k8s instance, so there are a few (!) incompatibilities that need to be worked through.

## Installation

The ``install_opal_stack.sh`` in ``/charts/opal`` should be enough to deploy everything in the ``/charts/opal/templates`` directory. Once it is spun up it will be available at the nodeport specified in the ``opal-service.yaml`` file, which ought to be made available via a reverse proxy. If all goes to plan then the R script in the ``/client`` folder should be useable.

Running the ``install_opal_stack.sh`` again when a file has been updated will upgrade the deployment.

Run ``uninstall_opal_stack.sh`` to uninstall it. Note PVs stay and will be reconnected (with their existing content) when new deployment done.

### Local environments

It would be nice to capture the differences automatically via environment variables or config files, but I am not there yet, so some of the differences are highlighted here.

If we want to add microk8s later then this might be useful.

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
- variables & settings in values file and reference via   MYSQL_PASSWORD: {{ .Values.mysql_password }}
- auto set up DS profile (needs a manual click now)
- auto set up a DS user which is not admin
- auto load some data/project into opal/DS
