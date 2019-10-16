# HomeLab

```
iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -o enp12s0 -j MASQUERADE
```

```
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.126.0/24 masquerade'
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.124.0/24 masquerade'
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.122.0/24 masquerade'
```


- sudo dnf install network-scripts -y

```
[root@nostromo network-scripts]# cat ifcfg-br1
DEVICE=br1
NAME=br1
TYPE=Bridge
ONBOOT=yes
BOOTPROTO=static
NM_CONTROLLED=no
PROXY_METHOD=none
BROWSER_ONLY=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
IPADDR=192.168.1.101
PREFIX=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
IPV6_PRIVACY=no
```

```
[root@nostromo network-scripts]# cat ifcfg-enp12s0
TYPE=Ethernet
BRIDGE=br1
ONBOOT=yes
BOOTPROTO=none
NM_CONTROLLED=no
MTU=1500
NAME=enp12s0
DEVICE=enp12s0
```
