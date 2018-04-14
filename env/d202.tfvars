# d202 tfvars ############################

region = "eu-west-1"

vpc_cidr = "10.202.0.0/16"

environment = "dev"

az_count = 2

key_name = {
  type      = "map"
  eu-west-1 = "xyz-bg-d202-euw"
}

##########################################