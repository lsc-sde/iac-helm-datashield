# DataSHIELD-SDE

## Background

This is an attempt to get DataSHIELD running in k8s. It is being developed across both minikube and the LSC Azure based k8s instance, so there are a few (!) incompatibilities that need to be worked through.

## Installation

The `install_opal_stack.sh` in `/charts/opal` should be enough to deploy everything in the `/charts/opal/templates` directory. Once it is spun up it will be available at the nodeport specified in the `opal-service.yaml` file, which ought to be made available via a reverse proxy. If all goes to plan then the R script in the `/client` folder should be useable.

Running the `install_opal_stack.sh` again when a file has been updated will upgrade the deployment.

Run `uninstall_opal_stack.sh` to uninstall it. Note PVs stay and will be reconnected (with their existing content) when new deployment done (this includes the DBs).

### Local environments

Using the `context` flag in the `values.yaml` file to switch between local and azure environments. Currently rolling out the `minikube` context. There are placeholders for `AKS` in the storage and opal service files. May add `microk8s` if we want to go down that route later.

#### Minikube

Storage - I have three Physical Volumes (one each for opal, mysql, mongodb) which sit on my minikube instance at `/k8s/pvs/`. The definitions and claims on these sit the respective `[opal, mongo, mysqldata]-storage.yaml` files. As long as the PV names remain the same it should be easy to swap this out for other environments.

The storage seems to be scoped to the cluster, not to the namespace, so I have to explicitly name the PVs in the storage files and flow that through to the PVCs.

Services - opal is the only service which needs to be accessible outside of the k8s cluster. I've specified nodeports here which are then picked up by a nginx reverse proxy sitting on the VM that minikube is running on. This is obviously clunky and I am not sure how to scale out. The internal services are using the internal NAMESPACEd DNS names e.g. `opal-service.opal1`. Namespaces seem a bit overkill for this.

#### Azure k8s

Most of these settings are in files which have been moved into `/charts/VC`

Storage - azure backed storage.

Services - built in k8s loadbalancer?

## Dev work

- spin up two instances side by side - this almost works, but the opal instances seem to crash when the second one comes up.
- finish templating the settings
- auto set up DS profile (needs a manual click now)
- should standard stuff like the DBs be in their own charts?
- Not 100% sure about the scope of the networking - is e.g. mysqldata-service only available in the deployemnt? Or the namespace? Other? Do I need to add these networking definitions (internal hostnames and ports) to the values file?

### Auto R server scaling

Opal can auto add new rock instances. I am just starting to work through this, but as an initial exploration I am adding all potential rock server URLs to the `ROCK_HOSTS` env_var in opal, this means when a new rock server is added it will be picked up by opal. I am not sure how to do this in a scalable way, but it is a start.

## Notes

Info about the k8s cluster:

    kubectl cluster-info

Info about the pods:

    kubectl get pods -A
    kubectl describe pods opal-8459f9fff8-xfk7n

Info about the services:

    kubectl get services -A
    kubectl describe services ds-opal

Info about the Perisisent Volumes and Claims:

    kubectl get pv -A
    kubectl get pvc -A

To get a shell in a pod:
    kubectl exec -it opal-8459f9fff8-v9cs5 -- bash

To find and remove a deployment called `bob` in `NAMESPACE`:

    helm list -A
    helm -n NAMESPACE uninstall bob

If you delete a pod it will be recreated if it is in a deployment. So you need to delete the deployment.

    kubectl get deployments -A
    kubectl delete -n default deployment opal

Full purge! THIS ALSO DELETES APP THE PVs (will requre a restart of minikube)

    minikube delete --all --purge
