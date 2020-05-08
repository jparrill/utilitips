+++
title = "OCP - Kernel, Kubelet and cmdline"
weight = 34
+++

- Passing Kernel args to RHCOS with a MC patch
```
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
    labels:
        machineconfiguration.openshift.io/role: worker-rt
    name: 10-kargs-worker-rt
spec:
    kernelArguments:
        - default_hugepagesz=1G
        - hugepagesz=1G
        - hugepages=32
        - isolcpus=2-15
        - nohz=on
        - nohz_full=2-15
        - rcu_nocbs=2-15
        - nosoftlockup
        - nmi_watchdog=0
        - audit=0
        - mce=off
        - kthread_cpus=0
        - irqaffinity=0
        - skew_tick=1
        - processor.max_cstate=1
        - idle=poll
        - intel_pstate=disable
        - intel_idle.max_cstate=0
        - intel_iommu=on
        - iommu=pt
```

- Modify Kubelet args on OCP with a MC patch
```
apiVersion: machineconfiguration.openshift.io/v1
kind: KubeletConfig
metadata:
  name: cpumanager-enabled
spec:
  machineConfigPoolSelector:
    matchLabels:
      custom-kubelet: cpumanager-enabled
  kubeletConfig:
    cpuManagerPolicy: static
    cpuManagerReconcilePeriod: 5s
```
