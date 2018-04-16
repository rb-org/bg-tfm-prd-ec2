#!/bin/bash

ws_update_dns(){

    echo "------------------------------------"
    echo "Running ws_plan_dns"

    REGION='eu-west-1'
    RR_GRN_WWW_HC_ID=$(aws route53 list-resource-record-sets --region ${REGION} --hosted-zone-id ${zone_id} --query "ResourceRecordSets[?SetIdentifier == 'www-grn'].HealthCheckId" --output text )
    RR_BLU_WWW_HC_ID=$(aws route53 list-resource-record-sets --region ${REGION} --hosted-zone-id ${zone_id} --query "ResourceRecordSets[?SetIdentifier == 'www-blu'].HealthCheckId" --output text )


    if [[ $(echo "$ws_running_color_dev" |grep grn) = "grn" ]]; then
        echo "Updating Green"

        WEIGHT_BLU=0
        WEIGHT_GRN=100

    elif [[ $(echo "$ws_running_color_dev" |grep blu) = "blu" ]]; then
        echo "Updating Blue"

        WEIGHT_BLU=100
        WEIGHT_GRN=0

    else 
        echo "Something went wrong"
        echo "------------------------------------"
        echo "DNS Update Vars"
        echo
        echo "Region: ${REGION}"
        echo "RR Grn Health Chk Id: ${RR_GRN_WWW_HC_ID}"
        echo "RR Blu Health Chk Id: ${RR_BLU_WWW_HC_ID}"
        echo "RR Update json: ${RR_UPDATE}"
        echo "Weighting Blu: $WEIGHT_BLU"
        echo "Weighting Grn: $WEIGHT_GRN"
        exit 1
    fi
    echo "------------------------------------"
    echo "Making the Change"

    RR_UPDATE="{ "ChangeBatch": { "Comment": "Stop routing traffic to blue",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "www.${cert_domain}",
        "Type": "CNAME",
        "SetIdentifier": "www-blu",
        "Weight": ${WEIGHT_BLU}
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "ws-blu.${cert_domain}"
          }
        ],
        "HealthCheckId": "${RR_BLU_WWW_HC_ID}"
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "www.${cert_domain}",
        "Type": "CNAME",
        "SetIdentifier": "www-grn",
        "Weight": ${WEIGHT_GRN}
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "ws-grn.${cert_domain}"
          }
        ],
        "HealthCheckId": "${RR_GRN_WWW_HC_ID}"
      }
    }
  ] } }"

aws route53 change-resource-record-sets --hosted-zone-id ${zone_id} --cli-input-json $RR_UPDATE


}


ws_update_dns