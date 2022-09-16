#!/bin/bash
# https://github.com/rt1d6m7
# OS: Ubuntu

echo -e "\n>_ README\n Run as sudo user"
echo -e "\n>_ Getting user inputs\n"

read -p "IP address to whitelist ? : " IP_ADDR

echo -e "\n>_ Installing\n"

apt-get update && apt-get install fail2ban -y 

echo -e "\n>_ Setting up\n"

cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = $IP_ADDR
# mta = mail
# destemail = youraccount@email.com
# sendername = Fail2BanAlerts
# action = %(action_mwl)s

##To block the failed login attempts on the SSH server, use the below jail.
[ssh]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 2
bantime = 6000
EOF

cat <<\EOF > /usr/bin/fail2ban-all-status
#!/bin/bash

JAILS=`fail2ban-client status | grep "Jail list" | sed -E 's/^[^:]+:[ \t]+//' | sed 's/,//g'`
for JAIL in $JAILS
do
  fail2ban-client status $JAIL
done
EOF

chmod 755 /usr/bin/fail2ban-all-status

systemctl enable fail2ban && systemctl restart fail2ban && systemctl status fail2ban

echo -e "\n>_ Setup completed\n"
echo -e "\n>_ README\n Check jail status with the following custom command: sudo fail2ban-all-status"