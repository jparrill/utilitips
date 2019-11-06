+++
title = "OCP - Kubevirt"
weight = 33
+++

- Boot a custom kernel VM on Kubevirt
```
1) Create a containerDisk which contains the kernel and disk. 
2) Push it to a registry
3) Mount both, the kernel and the disk as individual containerDisks [1]. The resulting VMI shoould look somewhat like this:

metadata:
  name: testvmi-containerdisk
apiVersion: kubevirt.io/v1alpha3
kind: VirtualMachineInstance
spec:
  domain:
    resources:
      requests:
        memory: 64M
    devices:
      disks:
      - name: rootdisk
        disk: {}
      - name: kernel
        disk: {}
  volumes:
    - name: rootdisk
      containerDisk:
        image: vmidisks/diskandkernel:latest
        path: /custom-disk-path/disk.qcow2
    - name: kernel
      containerDisk:
        image: vmidisks/diskandkernel:latest
        path: /custom-disk-path/kernel.img

3) In the webhook you will now find both, the disk and the kernel added as disk
4) Take the path from the disk with the alias `ua-kernel` (basically `ua-` prefix + disk-name)
5) Use the path for the kernel path and remove the disk, since you don't want it as disk
```
