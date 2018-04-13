# /bin/sh

# We need to update the tfvars file with some environment variables from CircleCI
echo -e  | tee -a env/${WKSPC}.tfvars
echo -e "acc_id = ${acc_id}" | tee -a env/${WKSPC}.tfvars
echo -e "allowed_ips = ${allowed_ips}" | tee -a env/${WKSPC}.tfvars
echo -e "cert_domain = ${cert_domain}" | tee -a env/${WKSPC}.tfvars
echo -e "zone_id = ${zone_id}" | tee -a env/${WKSPC}.tfvars

CCI_PROJECT=$CIRCLE_PROJECT_REPONAME
CCI_USERNAME=$CIRCLE_PROJECT_USERNAME

# AppVer and AMI Id vars have just been updated. We need to use these on the color that was previously secondary ASG
# ws_color_last_dev tells us which color is currently in primary ASG

ws_plan(){

    echo "Running ws_plan"

    if [[ $ws_color_last_dev == *"grn"* ]]; then

        echo -e "bg-web-ws-ami_blu = {type = \"map\" eu-west-1 = \"${ws_ami_id_latest_dev}\"}" | tee -a env/${WKSPC}.tfvars
        echo -e "bg-web-ws-ami_grn = {type = \"map\" eu-west-1 = \"${ws_ami_id_last_dev}\"}" | tee -a env/${WKSPC}.tfvars

        echo -e "bg-web-ws-des_blu = 1" | tee -a env/${WKSPC}.tfvars
        echo -e "bg-web-ws-des_grn = 1" | tee -a env/${WKSPC}.tfvars

        echo -e "app_version_web_blu = \"${ws_app_ver_latest_dev}\""| tee -a env/${WKSPC}.tfvars
        echo -e "app_version_web_grn = \"${ws_app_ver_last_dev}\"" | tee -a env/${WKSPC}.tfvars

        echo -e "www_dns_weight_blu = 100" | tee -a env/${WKSPC}.tfvars
        echo -e "www_dns_weight_grn = 0" | tee -a env/${WKSPC}.tfvars

        echo -e "bg-web-ws = \"blu\"" | tee -a env/${WKSPC}.tfvars

    else

        echo -e "bg-web-ws-ami_grn = {type = \"map\" eu-west-1 = \"${ws_ami_id_latest_dev}\"}" | tee -a env/${WKSPC}.tfvars
        echo -e "bg-web-ws-ami_blu = {type = \"map\" eu-west-1 = \"${ws_ami_id_last_dev}\"}" | tee -a env/${WKSPC}.tfvars

        echo -e "bg-web-ws-des_grn = 1" | tee -a env/${WKSPC}.tfvars
        echo -e "bg-web-ws-des_blu = 1" | tee -a env/${WKSPC}.tfvars

        echo -e "app_version_web_grn = \"${ws_app_ver_latest_dev}\"" | tee -a env/${WKSPC}.tfvars
        echo -e "app_version_web_blu = \"${ws_app_ver_last_dev}\"" | tee -a env/${WKSPC}.tfvars

        echo -e "www_dns_weight_grn = 100" | tee -a env/${WKSPC}.tfvars
        echo -e "www_dns_weight_blu = 0" | tee -a env/${WKSPC}.tfvars

        echo -e "bg-web-ws = \"grn\"" | tee -a env/${WKSPC}.tfvars

    fi

    cat env/${WKSPC}.tfvars

}


ws_apply(){

    echo "Running ws_apply"

    if [ $ws_color_last_dev == "\"grn\"" ]; then

        #curl -u ${CCI_TOKEN}: -X DELETE https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar/ws_color_last_dev
        curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_color_last_dev", "value":"blu"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 

    else

        #curl -u ${CCI_TOKEN}: -X DELETE https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar/ws_color_last_dev
        curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_color_last_dev", "value":"blu"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 

    fi

    # Update last vars so we know what was deployed in primary ASG
    curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_ami_id_last_dev", "value":"'$ws_ami_id_latest_dev'"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 
    curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_app_ver_last_dev", "value":"'$ws_app_ver_latest_dev'"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 

    cat env/${WKSPC}.tfvars
    
}

if [ $RUN_WS_PLAN = "true" ]; then
    ws_plan
elif [ $RUN_WS_APPLY = "true" ]; then
    ws_apply
else
    echo "Something went wrong"
    exit 1
fi