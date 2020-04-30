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

- Deleting "Bad" BareMetal Nodes

    1. Create bmh resource and wait until it's Ready
    2. Scale up machineset to start deployment
    3. **Do not** Delete bmh
    4. Annotate "bad" or failed nodes with machine.openshift.io/cluster-api-delete-machine=yes 
    5. Scale down replicas to match the number of existing worker nodes
    6. This will automatically delete "bad" nodes
