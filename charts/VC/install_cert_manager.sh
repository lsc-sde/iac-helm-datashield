NSINGRESS=ingress-nginx

# https://cert-manager.io/docs/installation/kubectl/
kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
# Label the ingress-basic namespace to disable resource validation
kubectl label namespace $NSINGRESS cert-manager.io/disable-validation=true

kubectl apply -f cluster-issuer.yaml
