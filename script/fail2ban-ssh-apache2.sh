#!/bin/bash
# OS: Ubuntu 18 LTS

echo -e "\n>_ README\n Run as sudo user"
echo -e "\n>_ Getting user inputs\n"

read -p "IP address to whitelist ? : " IP_ADDR

echo -e "\n>_ Installing\n"

apt-get install fail2ban -y 

echo -e "\n>_ Setting up\n"

cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = $IP_ADDR
# mta = mail
# destemail = youraccount@email.com
# sendername = Fail2BanAlerts
# action = %(action_mwl)s

##To block failed login attempts use the below jail.
[apache]
enabled = true
port = http,https
filter = apache-auth
logpath = /var/log/apache2/*error.log
maxretry = 3
bantime = 600

##To block the remote host that is trying to request suspicious URLs, use the below jail.
[apache-overflows]
enabled = true
port = http,https
filter = apache-overflows
logpath = /var/log/apache2/*error.log

##To block the remote host that is trying to search for scripts on the website to execute, use the below jail.
[apache-noscript]
enabled = true
port = http,https
filter = apache-noscript
logpath = /var/log/apache2/*error.log
maxretry = 3
bantime = 600

##To block the remote host that is trying to request malicious bot, use below jail.
[apache-badbots]
enabled = true
port = http,https
filter = apache-badbots
logpath = /var/log/apache2/*error.log
maxretry = 3
bantime = 600

##To stop DOS attack from remote host.
[http-get-dos]
enabled = true
port = http,https
filter = http-get-dos
logpath = /var/log/apache2/*access.log
maxretry = 400
findtime = 400
bantime = 200
action = iptables[name=HTTP, port=http, protocol=tcp]

##To block the failed login attempts on the SSH server, use the below jail.
[ssh]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 6000
EOF

cat <<EOF > /etc/fail2ban/filter.d/http-get-dos.conf
# Fail2Ban configuration file
[Definition]

# Option: failregex
# Note: This regex will match any GET entry in your logs, so basically all valid and not valid entries are a match.
# You should set up in the jail.conf file, the maxretry and findtime carefully in order to avoid false positives.
failregex = ^<HOST> -.*"(GET|POST).*
# Option: ignoreregex
ignoreregex =
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
echo -e "\n>_ README\n Check jail status with the following custom command: fail2ban-all-status"