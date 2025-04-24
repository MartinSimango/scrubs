#!/bin/bash

DOMAIN=$1
if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi

echo "Assuming role to update Route 53 DNS records..."
creds=($(aws sts assume-role \
  --role-arn arn:aws:iam::648421211512:role/dns-updater  \
  --role-session-name test-session \
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
  --output text))

export AWS_ACCESS_KEY_ID=${creds[0]}
export AWS_SECRET_ACCESS_KEY=${creds[1]}
export AWS_SESSION_TOKEN=${creds[2]}



ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='$DOMAIN'].Id" --output text --no-cli-pager | sed 's/\/hostedzone\///')
if [ -z "$ZONE_ID" ]; then
  echo "Hosted zone for $DOMAIN not found."
  exit 1
fi

TTL=300
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
if [ -z "$PUBLIC_IP" ]; then
  echo "Failed to retrieve public IP address."
  exit 1
fi


cat > /tmp/record.json <<EOF 
{
  "Comment": "Update record to reflect new IP address",
  "Changes": [
  {
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "$DOMAIN",
      "Type": "A",
      "TTL": $TTL,
      "ResourceRecords": [
        {
          "Value": "$PUBLIC_IP"
        }
      ]
    }
  }
  ]
}
EOF


echo "Records to create: "
cat /tmp/record.json

aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" --change-batch file:///tmp/record.json
