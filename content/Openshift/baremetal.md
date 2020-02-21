+++
title = "OCP - Baremetal"
weight = 32
+++

- Get IPMI status using iDrac/IPMI interface
```
for i in {2..10}; do ipmitool -I lanplus -H 10.5.35.$i -U root -P p4ssW0rD power status; done
```

- Get/Debug Ironic status os Master nodes using dev-scripts
```
cd ${HOME}/repos/dev-scripts
export OS_CLOUD=metal3-bootstrap
openstack baremetal node list
openstack baremetal node show openshift-master-0
```

- Use Racadm to get info form Baremetal Chasis using iDrac/IPMI interface
```
podman pull justinclayton/racadm
alias racadm='podman run --rm -it -v "/root":/shared justinclayton/racadm'
racadm -r "10.5.35.2" -u root -p "p4ssW0rD" getsysinfo
```

- Or you could use ssh against chassis to do that
```
alias racadm="sshpass -e ssh -oStrictHostKeyChecking=no root@$10.5.35.2 racadm"
racadm getsysinfo
```

- Follow an OCP installation with watch
```
watch "tail -n 4 clusterconfigs/.openshift_install.log; oc get po -A -o wide | grep -v -E 'Running|Complete';oc get bmh -A; oc get machines -A; oc get nodes"
```
