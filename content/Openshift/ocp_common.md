+++
title = "Openshift Common"
+++

- Untaint master in order to let the OCP installer continue with pod deployment
```
oc adm taint nodes -l node-role.kubernetes.io/master node-role.kubernetes.io/master:NoSchedule-
```

- BMO logs
```
kubectl logs -n metal3 pod/cluster-api-provider-baremetal-controller-manager-0 -c manager -f
```

- List ironic nodes
```
export OS_TOKEN=fake-token
export OS_URL=http://localhost:6385/
openstack baremetal node list

```

- Create a new node on KVM for Minikube
```
go run $GOPATH/src/github.com/metal3-io/baremetal-operator/cmd/make-bm-worker/main.go -address ipmi://192.168.111.1:6232 -password password -user admin -boot-mac 00:6c:f2:66:00:fc worker-1 | kubectl create -n metal3 -f -
```

- Patch SC to be the default one
```
kubectl patch storageclass mycluster-ceph-rbd -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

- Clean pods in state X
```
kubectl get po --all-namespaces --field-selector 'status.phase!=Running' -o json | kubectl delete -f -
```

- Get JSONPATH label
```
oc --config ocp/auth/kubeconfig get machines -n openshift-machine-api --no-headers -o jsonpath="{['items'][0]['metadata']['labels']['machine\.openshift\.io/cluster-api-cluster']}"
```

- Install a concrete version of OCP4 update
```
OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE=registry.svc.ci.openshift.org/ocp/release:4.2.0-0.nightly-2019-08-19-113631
```

- Change SDN on installation time:
    - https://docs.openshift.com/container-platform/4.1/installing/installing_aws/installing-aws-network-customizations.html#network-customization-config-yaml_installing-aws-network-customizations
