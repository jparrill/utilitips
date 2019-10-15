# K8s cheatsheet

- Get Env vars from a deployment via jsonpath
```
kubectl get deployment.apps virt-operator -n kubevirt -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="KUBEVIRT_VERSION")].value}
```

- Get Env vars from a deployment via template
```
kubectl get  deployment.apps virt-operator -n kubevirt -o template  --template='{{range .spec.template.spec.containers}}{{.image}}{{end}} '|  awk -F: '{print $NF}'
```

- Useful for ^^ https://gist.github.com/so0k/42313dbb3b547a0f51a547bb968696ba

