STORAGE_ACCOUNT_NAME=stobiba
STORAGE_ACCOUNT_KEY=$(az storage account keys list --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
kubectl create secret generic stobiba-secret \
  --from-literal=azurestorageaccountname=$STORAGE_ACCOUNT_NAME \
  --from-literal=azurestorageaccountkey=$STORAGE_ACCOUNT_KEY \
  --namespace default
