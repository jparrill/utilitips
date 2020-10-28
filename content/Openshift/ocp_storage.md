+++
title = "OCP - Storage"
weight = 36
+++

## Deploy Hostpath Storage

- We need to create these files first on the console

```yaml
# local_sc.yml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: local-vol
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

```yaml
# pv-template.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-PVNUM
  labels:
    type: local
spec:
  storageClassName: local
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/local/pv-PVNUM"
```

```yaml
# pvc-template.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: "pvc-\$NODENAME-\$PVNUM"
spec:
  volumeMode: Block
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```

- After that just run this script

```shell
# local-vol.sh
for node in $(oc get nodes --no-headers -o wide | cut -f16 -d\ );do
  ssh core@$node 'for i in $(seq -f "%03g" 1 20); do sudo mkdir -p /mnt/local/pv${i}; sudo chmod -R 777 /mnt/local/; done'
done

for i in $(seq -f "%03g" 1 20);do
  cat pv-template.yaml | sed "s/PVNUM/$i/" | oc create -f -
done
```

## Deploy NFS Storage

- We need to create these files first on the console
```yaml
# nfs_pvc.yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc001 
spec:
  accessModes:
    - ReadWriteMany 
  resources:
    requests:
      storage: 100Gi
```

```yaml
# nfs_pv.yml 
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv001
spec:
  storageClassName: nfs
  capacity:
    storage: 100Gi
  accessModes:
  - ReadWriteMany
  nfs:
    path: /mnt/nfs/pv001
    server: 192.168.200.1 ####### CHANGE THE SERVER FROM YOU ARE SERVING THE NFS FOLDERS
  persistentVolumeReclaimPolicy: Recycle
```

```yaml
# nfs_sc.yml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: nfs
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

- And after placing those files into the system, we need to run this script
```shell
yum -y install nfs-utils
for i in `seq -f "%03g" 1 20` ; do
    mkdir -p /mnt/nfs/pv${i}
    echo "/mnt/nfs/pv$i *(rw,no_root_squash)"  >>  /etc/exports
    chcon -t svirt_sandbox_file_t /mnt/nfs/pv${i}
    chmod 777 /mnt/nfs/pv${i}
done
exportfs -r
systemctl enable --now nfs-server
kubectl create -f nfs_sc.yml
for i in `seq 1 20` ; do j=`printf "%03d" ${i}` ; sed "s/001/$j/" ./nfs_pv.yml | kubectl create -f - ; done
```
