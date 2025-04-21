#!/bin/bash
DOMAIN=$1
if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi


ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='$DOMAIN'].Id" --output text --no-cli-pager | sed 's/\/hostedzone\///')
if [ -z "$ZONE_ID" ]; then
  echo "Hosted zone for $DOMAIN not found."
  exit 1
fi

RECORDS=(
  "www.$DOMAIN"
  "www.dev.$DOMAIN"
  "api.$DOMAIN"
  "api.dev.$DOMAIN"
)

RECORD_COUNT=${#RECORDS[@]}
TTL=300

PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
if [ -z "$PUBLIC_IP" ]; then
  echo "Failed to retrieve public IP address."
  exit 1
fi

upsert_record() {
  local record_name=$1
  echo "$(cat <<EOF
  {
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "$record_name", 
      "Type": "A",
      "TTL": $TTL,
      "ResourceRecords": [
        {
          "Value": "$PUBLIC_IP"
        }
      ]
    }
  }
EOF
)"
}



cat > /tmp/record.json <<EOF
{
  "Comment": "Update record to reflect new IP address",
  "Changes": [
EOF

for ((i=0; i<($RECORD_COUNT)-1; i++)); do
  RECORD=${RECORDS[$i]} 
  echo "$(upsert_record "$RECORD")," >> /tmp/record.json

done

echo "$(upsert_record "${RECORDS[($RECORD_COUNT)-1]}")" >> /tmp/record.json
echo "]}" >> /tmp/record.json

echo "Records to create: "
cat /tmp/record.json

aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" --change-batch file:///tmp/record.json
