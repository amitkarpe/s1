# This is OpenShift installation exercise


Following code will be use to install OSC on master and node
```
host $(hostname)
ping -c1 gnu.org
ping -c1 lab.example.com

dig <node_hostname> @<DNS Server IP_address> +short

# Success
dig workstation.lab.example.com @master  +short

dig master.lab.example.com @127.0.0.1 +short
dig node1.lab.example.com @127.0.0.1  +short
dig workstation.lab.example.com @127.0.0.1  +short
dig master.lab.example.com @10.168.119.110 +short
dig master.lab.example.com @10.168.116.53 +short

[root@workstation ~]# dig *.lab.example.com
<snip>
*.lab.example.com.      0       IN      A       10.168.116.53

# Failed
dig node1.lab.example.com @192.168.10.50  +short
dig master.lab.example.com @10.129.15.29  +short
dig master.lab.example.com @8.8.8.8 +short
```
