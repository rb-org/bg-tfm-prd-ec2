# /bin/sh

# We need to update the tfvars file with some environment variables from CircleCI
echo -e \n | tee -a env/${WKSPC}.tfvars
echo -e "acc_id = ${acc_id}" | tee -a env/${WKSPC}.tfvars
echo -e "allowed_ips = ${allowed_ips}" | tee -a env/${WKSPC}.tfvars
echo -e "cert_domain = ${cert_domain}" | tee -a env/${WKSPC}.tfvars
echo -e "zone_id = ${zone_id}" | tee -a env/${WKSPC}.tfvars

# AppVer and AMI Id vars have just been updated. We need to use these on the color that was previously secondary ASG
# ws_color_last_dev tells us which color is currently in primary ASG
# 

if [ ws_color_last_dev == "\"grn\"" -o ws_color_last_dev -eq "\"grn\"" ]; then

    echo -e "bg-web-ws-ami_blu = {type = \"map\" eu-west-1 = \"${ws_ami_id_latest_dev}\"}" | tee -a env/${WKSPC}.tfvars
    echo -e "bg-web-ws-ami_grn = {type = \"map\" eu-west-1 = \"${ws_ami_id_last_dev}\"}" | tee -a env/${WKSPC}.tfvars

    echo -e "bg-web-ws-des_blu = 1" | tee -a env/${WKSPC}.tfvars
    echo -e "bg-web-ws-des_grn = 1" | tee -a env/${WKSPC}.tfvars

    echo -e "app_version_web_blu = \"${ws_app_ver_latest_dev}\""| tee -a env/${WKSPC}.tfvars
    echo -e "app_version_web_grn = \"${ws_app_ver_last_dev}\"" | tee -a env/${WKSPC}.tfvars

    echo -e "www_dns_weight_blu = 100" | tee -a env/${WKSPC}.tfvars
    echo -e "www_dns_weight_grn = 0" | tee -a env/${WKSPC}.tfvars

    echo -e "bg-web-ws = \"blu\""

    cat env/d202.tfvars
    echo $CCI_TOKEN
    echo $CCI_USERNAME
    echo $CCI_PROJECT

    curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_color_last_dev", "value":"blu"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 

else

    echo -e "bg-web-ws-ami_grn = {type = \"map\" eu-west-1 = \"${ws_ami_id_latest_dev}\"}" | tee -a env/${WKSPC}.tfvars
    echo -e "bg-web-ws-ami_blu = {type = \"map\" eu-west-1 = \"${ws_ami_id_last_dev}\"}" | tee -a env/${WKSPC}.tfvars

    echo -e "bg-web-ws-des_grn = 1" | tee -a env/${WKSPC}.tfvars
    echo -e "bg-web-ws-des_blu = 1" | tee -a env/${WKSPC}.tfvars

    echo -e "app_version_web_grn = \"${ws_app_ver_latest_dev}\"" | tee -a env/${WKSPC}.tfvars
    echo -e "app_version_web_blu = \"${ws_app_ver_last_dev}\"" | tee -a env/${WKSPC}.tfvars

    echo -e "www_dns_weight_grn = 100" | tee -a env/${WKSPC}.tfvars
    echo -e "www_dns_weight_blu = 0" | tee -a env/${WKSPC}.tfvars

    echo -e "bg-web-ws = \"grn\""

    cat env/d202.tfvars
    echo $CCI_TOKEN
    echo $CCI_USERNAME
    echo $CCI_PROJECT

    curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_color_last_dev", "value":"blu"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 

fi

# Update last vars so we know what was deployed in primary ASG
curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_ami_id_last_dev", "value":"'$ws_ami_id_latest_dev'"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 
curl -u ${CCI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{"name":"ws_app_ver_last_dev", "value":"'$ws_app_ver_latest_dev'"}' https://circleci.com/api/v1.1/project/github/${CCI_USERNAME}/${CCI_PROJECT}/envvar 
