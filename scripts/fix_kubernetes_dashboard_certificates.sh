# https://github.com/canonical/microk8s/issues/1046

openssl req -nodes -newkey rsa:2048 -keyout dashboard.key -out dashboard.csr -subj "/C=/ST=/L=/O=/OU=/CN=*"
openssl x509 -req -sha256 -days 3650 -in dashboard.csr -signkey dashboard.key -out dashboard.crt

kubectl -n kube-system delete secret kubernetes-dashboard-certs
kubectl -n kube-system create secret generic kubernetes-dashboard-certs --from-file=dashboard.crt --from-file=dashboard.key
kubectl -n kube-system edit deploy kubernetes-dashboard -o yaml

# modify section args as follows
          args:
            - --tls-cert-file=dashboard.crt
            - --tls-key-file=dashboard.key
            #- --auto-generate-certificates