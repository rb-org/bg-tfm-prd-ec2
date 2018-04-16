#!/bin/bash

new_zone_id=$(echo ${zone_id} | sed "s/\"//g;")
new_cert_domain=$(echo ${cert_domain} | sed "s/\"//g;")

ws_update_dns(){

    echo "------------------------------------"
    echo "Running ws_plan_dns"

    REGION='eu-west-1'
    RR_GRN_WWW_HC_ID=$(aws route53 list-resource-record-sets --region ${REGION} --hosted-zone-id ${new_zone_id} --query "ResourceRecordSets[?SetIdentifier == 'www-grn'].HealthCheckId" --output text )
    RR_BLU_WWW_HC_ID=$(aws route53 list-resource-record-sets --region ${REGION} --hosted-zone-id ${new_zone_id} --query "ResourceRecordSets[?SetIdentifier == 'www-blu'].HealthCheckId" --output text )


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

    RR_UPDATE="{ \"ChangeBatch\": { 
        \"Comment\": \"Stop routing traffic to blue\",
        \"Changes\": [
            {
            \"Action\": \"UPSERT\",
            \"ResourceRecordSet\": {
                \"Name\": \"www.${new_cert_domain}\",
                \"Type\": \"CNAME\",
                \"SetIdentifier\": \"www-blu\",
                \"Weight\": ${WEIGHT_BLU},
                \"TTL\": 5,
                \"ResourceRecords\": [
                    {
                        \"Value\": \"ws-blu.${new_cert_domain}\"
                    }
                ],
                \"HealthCheckId\": \"${RR_BLU_WWW_HC_ID}\"
                }
            },
            {
            \"Action\": \"UPSERT\",
            \"ResourceRecordSet\": {
            \"Name\": \"www.${new_cert_domain}\",
                \"Type\": \"CNAME\",
                \"SetIdentifier\": \"www-grn\",
                \"Weight\": ${WEIGHT_GRN},
                \"TTL\": 5,
                \"ResourceRecords\": [
                    {
                        \"Value\": \"ws-grn.${new_cert_domain}\"
                    }
                ],
                \"HealthCheckId\": \"${RR_GRN_WWW_HC_ID}\"
                }  
            }
        ] 
    } }"

    echo $RR_UPDATE

    CHG_ID=$(aws route53 change-resource-record-sets --hosted-zone-id ${new_zone_id} --cli-input-json "${RR_UPDATE}" --query "ChangeInfo.Id" --output text)

    sleep 10
    STATUS=$(aws route53 get-change --id ${CHG_ID} --query "ChangeInfo.Status" --output text)

    if [ ${STATUS} == "PENDING" ] || [ ${STATUS} == "INSYNC" ]; then
        echo "Update status: ${STATUS}"
    else
        echo "Something went wrong"
        exit 1
    fi
}


ws_update_dns