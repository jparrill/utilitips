+++
title = "K8s - ArgoCD"
sort_by = "weight"
weight = 60
+++

- We will set the base using [Kcli](https://kcli.readthedocs.io/)
```
kcli create kube -P masters=1 -P workers=2 k8s-dev
kcli create kube -P masters=1 -P workers=2 k8s-pre
kcli create kube -P masters=1 -P workers=2 k8s-pro
```

- If you did this with kcli you need to label the workers using this, for every cluster
```
export KUBECONFIG=clusters/k8s-pre/auth/kubeconfig
for node in `kubectl get nodes --no-headers | grep worker | awk '{print $1}'`; do kubectl label node $node node-role.kubernetes.io/worker=""; done
export KUBECONFIG=clusters/k8s-dev/auth/kubeconfig
for node in `kubectl get nodes --no-headers | grep worker | awk '{print $1}'`; do kubectl label node $node node-role.kubernetes.io/worker=""; done
export KUBECONFIG=clusters/k8s-pro/auth/kubeconfig
for node in `kubectl get nodes --no-headers | grep worker | awk '{print $1}'`; do kubectl label node $node node-role.kubernetes.io/worker=""; done
```

- Flatten & merge Kubeconfigs
```
sed -i 's/kubernetes-admin@kubernetes/k8s-dev/g' clusters/k8s-dev/auth/kubeconfig
sed -i 's/kubernetes$/k8s-dev/g' clusters/k8s-dev/auth/kubeconfig
sed -i 's/kubernetes-admin/k8s-dev-admin/g' clusters/k8s-dev/auth/kubeconfig
sed -i 's/kubernetes-admin@kubernetes/k8s-pre/g' clusters/k8s-pre/auth/kubeconfig
sed -i 's/kubernetes$/k8s-pre/g' clusters/k8s-pre/auth/kubeconfig
sed -i 's/kubernetes-admin/k8s-pre-admin/g' clusters/k8s-pre/auth/kubeconfig
sed -i 's/kubernetes-admin@kubernetes/k8s-pro/g' clusters/k8s-pro/auth/kubeconfig
sed -i 's/kubernetes$/k8s-pro/g' clusters/k8s-pro/auth/kubeconfig
sed -i 's/kubernetes-admin/k8s-pro-admin/g' clusters/k8s-pro/auth/kubeconfig
export KUBECONFIG=clusters/k8s-dev/auth/kubeconfig:clusters/k8s-pre/auth/kubeconfig:clusters/k8s-pro/auth/kubeconfig
oc config get-contexts
kubectl config view --flatten > multicluster-kubeconfig
oc config get-contexts
```

- Download ArgoCD Binary (1.4.2)
```
wget https://github.com/argoproj/argo-cd/releases/download/v1.4.2/argocd-linux-amd64 -O ~/bin/argocd && chmod 755 ~/bin/argocd
```

- Deploying Argo (Following https://github.com/openshift/openshift-gitops-examples/tree/master/argocd)
```
kubectl config use-context k8s-dev
kubectl create ns argocd
kubectl config set-context --current --namespace=argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
ssh root@k8s-dev-master-0 "kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 8080:443"
# Use this other one if the deployment is done on local
#   kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 8080:443
```

Now you could access the UI just pointing to https://$HOST:8080/

- Login and cluster addition
```
# You need to ensure that you already changed the cluster's context and then
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

# Ensure you had 8080 exposed on the controller K8s cluster (where argo is installed), then
argocd login k8s-dev-master-0:8080
argocd cluster add k8s-dev --kubeconfig multicluster-kubeconfig                                                               
argocd cluster add k8s-pre --kubeconfig multicluster-kubeconfig                                                               
argocd cluster add k8s-pro --kubeconfig multicluster-kubeconfig
```

