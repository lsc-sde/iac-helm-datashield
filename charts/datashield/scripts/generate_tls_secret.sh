KEY_FILE=ingress.local.key
CERT_FILE=ingress.local.crt
HOST=ingress.local
CERT_NAME=tls-secret-ingress-local
NS=datashield

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}" -addext "subjectAltName = DNS:${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} --namespace ${NS}