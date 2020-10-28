+++
title = "OCP - Storage Platform"
weight = 35
+++

- Disks mapping on OCS configuration
```shell
oc get localvolume  -n openshift-storage osd-disks -o yaml

NAME        AGE
osd-disks   15m
```

- Change disk Mapping on OCS Config
```
oc edit localvolume -n openshift-storage osd-disks
```

- Recover NooBaa credentials deployed by OCS
```
oc get secret noobaa-admin -n openshift-storage -o jsonpath='{.data.email}' | base64 -d
oc get secret noobaa-admin -n openshift-storage -o jsonpath='{.data.password}' | base64 -d
```

- Get NooBaa QuickStart from Openshift
```
oc describe noobaa -n openshift-storage
```
