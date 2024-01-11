# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo update
#====================================================================
cp -r /mnt/c/Users/vishnu.chandrabalan/.kube/config ~/.kube/config


CURRENTAKSCONTEXT=$(kubectl config current-context)
AKSNAME=aks-datashield-dev-01
kubectl config use-context $AKSNAME
#====================================================================
# need a mechanism to change this between prd and dev
NS=ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NS \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz

#====================================================================
kubectl config use-context $CURRENTAKSCONTEXT
#====================================================================
