+++
title = "Iptables"
+++

- Check rules that are bothering/blocking connections that you need
```
sudo iptables -vL | egrep 'REJECT|DROP'
```

```
[jparrill@nostromo ~]$ sudo iptables -vL | egrep 'REJECT|DROP'
    4   160 DROP       all  --  any    any     anywhere             anywhere             ctstate INVALID
 271K   50M REJECT     all  --  any    any     anywhere             anywhere             reject-with icmp-host-prohibited
    0     0 DROP       all  --  any    any     anywhere             anywhere             ctstate INVALID
    0     0 REJECT     all  --  any    any     anywhere             anywhere             reject-with icmp-host-prohibited
    0     0 REJECT     all  --  any    covenant  anywhere             anywhere             reject-with icmp-port-unreachable
   13   768 REJECT     all  --  any    virbr0  anywhere             anywhere             reject-with icmp-port-unreachable
    0     0 REJECT     all  --  covenant any     anywhere             anywhere             reject-with icmp-port-unreachable
    0     0 REJECT     all  --  virbr0 any     anywhere             anywhere             reject-with icmp-port-unreachable

```
