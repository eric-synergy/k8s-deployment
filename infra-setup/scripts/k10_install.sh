kubectl create namespace kasten-io
helm repo add kasten https://charts.kasten.io/
helm install k10 kasten/k10 --namespace kasten-io