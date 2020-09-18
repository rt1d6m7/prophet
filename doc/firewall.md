**Firewalld**

Check all the active zones and active services

`firewall-cmd --get-active-zones`

`firewall-cmd --get-services`

List all active services, ports

`firewall-cmd --zone=public --list-all`

Add, Remove Ports and check status

`firewall-cmd --permanent --zone=public --add-port=80/tcp`

`firewall-cmd --zone=public --remove-port=80/tcp`

`firewall-cmd --zone=public --list-ports`

Add, Remove Services and check status

`firewall-cmd --zone=public --add-service=ftp`

`firewall-cmd --zone=public --remove-service=ftp`

`firewall-cmd --zone=public --list-services`

Block Incoming and Outgoing Packets (Panic Mode)

`firewall-cmd --panic-on`

`firewall-cmd --panic-off`


`service firewalld restart`

**UFW**

Check status

`ufw status`

*Allow Connections*

`ufw allow ssh`

`ufw allow 22/tcp`

`ufw allow 1000:2000/tcp` // with port range

`ufw allow from 192.168.255.255` // from specific IP addresses

*Denying Connections*

`ufw deny 22`

`ufw deny ssh`

*Remove Rules*

`ufw delete allow ssh`

`ufw delete allow 80/tcp`

`ufw delete allow 1000:2000/tcp`

`ufw status numbered` // list out all the current rules in a numbered list

`ufw delete [number]`

