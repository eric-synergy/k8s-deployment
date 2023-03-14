## helm add repo and install kasten K10
kubectl create namespace kasten-io
helm repo add kasten https://charts.kasten.io/

helm install k10 kasten/k10 --namespace kasten-io \
  --set global.persistence.metering.size=20Gi \
  --set prometheus.server.persistentVolume.size=20Gi \
  --set global.persistence.catalog.size=20Gi \
  --set injectKanisterSidecar.enabled=true \
  --set injectKanisterSidecar.enabled=true \
  --set-string injectKanisterSidecar.namespaceSelector.matchLabels.k10/injectKanisterSidecar=true \
  --set auth.tokenAuth.enabled=true

sudo kubectl create namespace kasten-io
sudo helm repo add kasten https://charts.kasten.io/
sudo helm install k10 kasten/k10 --namespace=kasten-io 
 

kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage
  annotations:
    k10.kasten.io/is-snapshot-class: "true"
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer

apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 3Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/data"

sudo helm install k10 kasten/k10 --namespace kasten-io \
  --set global.persistence.metering.size=20Gi \
  --set prometheus.server.persistentVolume.size=20Gi \
  --set global.persistence.catalog.size=20Gi \
  --set injectKanisterSidecar.enabled=true \
  --set injectKanisterSidecar.enabled=true \
  --set global.persistence.storageClass=local-storage
  --set-string injectKanisterSidecar.namespaceSelector.matchLabels.k10/injectKanisterSidecar=true 