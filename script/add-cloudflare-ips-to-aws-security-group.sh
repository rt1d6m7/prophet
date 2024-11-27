#!/bin/bash
SG_ID="sg-xxxxxxxxxxxxxxxxx"

# Adding ipv4
for p in $(curl --fail --silent https://www.cloudflare.com/ips-v4);
do
        aws ec2 authorize-security-group-ingress --group-id $SG_ID --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges="[{CidrIp=$p,Description='Cloudflare IPv4 - updated by instance'}]"
        aws ec2 authorize-security-group-ingress --group-id $SG_ID --ip-permissions IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges="[{CidrIp=$p,Description='Cloudflare IPv4 - updated by instance'}]"
        echo "$p has been added"
done
echo "IPv4 completed"

# Adding ipv6
for p in $(curl --fail --silent https://www.cloudflare.com/ips-v6);
do
        aws ec2 authorize-security-group-ingress --group-id $SG_ID --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,Ipv6Ranges="[{CidrIpv6=$p,Description='Cloudflare IPv6 - updated by instance'}]"
        aws ec2 authorize-security-group-ingress --group-id $SG_ID --ip-permissions IpProtocol=tcp,FromPort=443,ToPort=443,Ipv6Ranges="[{CidrIpv6=$p,Description='Cloudflare IPv6 - updated by instance'}]"
        echo "$p has been added"
done
echo "IPv6 completed"
