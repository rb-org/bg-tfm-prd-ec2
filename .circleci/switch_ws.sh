#!/bin/sh

# We need to update the tfvars file with some environment variables from CircleCI
echo "------------------------------------"
echo "Updating secrets"
echo -e  | tee -a env/"${WKSPC}".tfvars
echo -e "acc_id = ${acc_id}" | tee -a env/"${WKSPC}".tfvars
echo -e "allowed_ips = ${allowed_ips}" | tee -a env/"${WKSPC}".tfvars
echo -e "cert_domain = ${cert_domain}" | tee -a env/"${WKSPC}".tfvars
echo -e "zone_id = ${zone_id}" | tee -a env/"${WKSPC}".tfvars

CCI_PROJECT=$CIRCLE_PROJECT_REPONAME
CCI_USERNAME=$CIRCLE_PROJECT_USERNAME

# AppVer and AMI Id vars have just been updated. We need to use these on the color that was previously secondary ASG
# ws_running_color_dev tells us which color is currently in primary ASG

ws_plan(){

    echo "------------------------------------"
    echo "Running ws_plan"
    if [[ $ws_running_color_dev = *"grn"* ]]; then
        echo "Updating Blue"

        echo -e "bg-web-ws-ami_blu = {type = \"map\" eu-west-1 = \"${ws_ami_id_latest_dev}\"}" | tee -a env/"${WKSPC}".tfvars
        echo -e "bg-web-ws-ami_grn = {type = \"map\" eu-west-1 = \"${ws_ami_id_running_dev}\"}" | tee -a env/"${WKSPC}".tfvars

        echo -e "bg-web-ws-des_blu = 1" | tee -a env/"${WKSPC}".tfvars
        echo -e "bg-web-ws-des_grn = 1" | tee -a env/"${WKSPC}".tfvars

        echo -e "app_version_web_blu = \"${ws_app_ver_latest_dev}\""| tee -a env/"${WKSPC}".tfvars
        echo -e "app_version_web_grn = \"${ws_app_ver_running_dev}\"" | tee -a env/"${WKSPC}".tfvars

        echo -e "www_dns_weight_blu = 100" | tee -a env/"${WKSPC}".tfvars
        echo -e "www_dns_weight_grn = 0" | tee -a env/"${WKSPC}".tfvars

        echo -e "bg-web-ws = \"blu\"" | tee -a env/"${WKSPC}".tfvars
    elif [[ $ws_running_color_dev = *"blu"* ]]; then
        echo "Updating Green"

        echo -e "bg-web-ws-ami_grn = {type = \"map\" eu-west-1 = \"${ws_ami_id_latest_dev}\"}" | tee -a env/"${WKSPC}".tfvars
        echo -e "bg-web-ws-ami_blu = {type = \"map\" eu-west-1 = \"${ws_ami_id_running_dev}\"}" | tee -a env/"${WKSPC}".tfvars

        echo -e "bg-web-ws-des_grn = 1" | tee -a env/"${WKSPC}".tfvars
        echo -e "bg-web-ws-des_blu = 1" | tee -a env/"${WKSPC}".tfvars

        echo -e "app_version_web_grn = \"${ws_app_ver_latest_dev}\"" | tee -a env/"${WKSPC}".tfvars
        echo -e "app_version_web_blu = \"${ws_app_ver_running_dev}\"" | tee -a env/"${WKSPC}".tfvars

        echo -e "www_dns_weight_grn = 100" | tee -a env/"${WKSPC}".tfvars
        echo -e "www_dns_weight_blu = 0" | tee -a env/"${WKSPC}".tfvars

        echo -e "bg-web-ws = \"grn\"" | tee -a env/"${WKSPC}".tfvars   
    else 
        echo "Something went wrong"
        echo "------------------------------------"
        echo "${WKSPC}.tfvars"
        echo
        cat env/"${WKSPC}".tfvars
        echo "------------------------------------"
        echo "CircleCI Env Vars"
        echo
        echo "Latest AMI Id: ${ws_ami_id_latest_dev}"
        echo "Running AMI Id: ${ws_ami_id_running_dev}"
        echo "Latest App Ver: ${ws_app_ver_latest_dev}"
        echo "Running App Ver: ${ws_app_ver_running_dev}"
        echo "Running Color: $ws_running_color_dev"
        exit 1
    fi
    echo "------------------------------------"
    cat env/"${WKSPC}".tfvars
    echo "------------------------------------"

}

ws_apply(){

    echo "------------------------------------"
    echo "Running ws_apply"

    if [[ $ws_running_color_dev = *"grn"* ]]; then
        echo "------------------------------------"
        echo "Updating env var ws_running_color_dev = blu"
        #curl -u "${CCI_TOKEN}": -X DELETE https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar/ws_running_color_dev
        curl -u "${CCI_TOKEN}": -X POST --header "Content-Type: application/json" -d '{"name":"ws_running_color_dev", "value":"blu"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 
    elif
        echo "------------------------------------"
        echo "Updating ws_running_color_dev = grn"
        #curl -u "${CCI_TOKEN}": -X DELETE https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar/ws_running_color_dev
        curl -u "${CCI_TOKEN}": -X POST --header "Content-Type: application/json" -d '{"name":"ws_running_color_dev", "value":"grn"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 
    else
        echo "Something went wrong"
        echo "------------------------------------"
        cat env/"${WKSPC}".tfvars
        echo "------------------------------------"
        exit 1
    fi

    # Update last vars so we know what was deployed in primary ASG
    echo "------------------------------------"
    echo "Updating env var ws_ami_id_running_dev"
    curl -u "${CCI_TOKEN}": -X POST --header "Content-Type: application/json" -d '{"name":"ws_ami_id_running_dev", "value":"'$ws_ami_id_latest_dev'"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 

    echo "Updating env var ws_app_ver_running_dev"
    curl -u "${CCI_TOKEN}": -X POST --header "Content-Type: application/json" -d '{"name":"ws_app_ver_running_dev", "value":"'$ws_app_ver_latest_dev'"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 
    
}

if [[ "$RUN_WS_PLAN" = "true" ]]; then
    ws_plan
elif [[ "$RUN_WS_APPLY" = "true" ]]; then
    ws_apply
else
    echo "Something went wrong"
    exit 1
fi
