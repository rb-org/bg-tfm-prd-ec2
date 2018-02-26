region = "eu-west-1"

vpc_cidr = "10.202.0.0/16"

environment = "dev"

az_count = 2

key_name = {
    type = "map"
    eu-west-1 = "bg-d202-euw"
}

// Web Tier

# AMI id is likely to change depending on the environment/workspace
# AMI id needs to map to a region. Becos we can't do map of maps AMI id is set here while instance type map is set in variables
# It's important the ami_blu and ami_grn maps are not spread over multiple lines
bg-web-ws-ami_blu = {type = "map" eu-west-1 = "ami-21eb9658"}
bg-web-ws-ami_grn = {type = "map" eu-west-1 = "ami-21eb9658"}

bg-web-ws-des_blu = 0
bg-web-ws-des_grn = 1

app_version_web_blu = "20171221.59"
app_version_web_grn = "20180225.13"


