+++
title = "OCP - Storage"
weight = 33
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
