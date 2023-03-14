#!/bin/bash

echo "[TASK 8] Initizalize K8S cluster"
kubeadm init --apiserver-advertise-address=10.140.10.51  --pod-network-cidr=10.244.0.0/16

# echo "[TASK 9] Print join cluster token"
# kubeadm token create --print-join-command > /tmp/token.txt

## Setup kubectl ENV

echo "[TASK 9] Setup kubectl ENV"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
source <(kubectl completion bash)
echo 'source <(kubectl completion bash)' >>~/.bashrc

echo "[TASK 10] Apply SDN"
kubectl apply -f /tmp/kube-flannel.yml

echo "[TASK 11] Create Snapshot CRD"
export SNAPSHOTTER_VERSION=v4.1.0
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml	

echo "[TASK 12] Create metallb"
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 10.140.10.70-10.140.10.80
EOF