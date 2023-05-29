provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "k8s-vpc"
  }
}

module "my_subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = aws_vpc.k8s_vpc.id
  default_route_table_id = aws_vpc.k8s_vpc.default_route_table_id
}


module "webserver" {
  source    = "./modules/webserver"
  vpc_id    = aws_vpc.k8s_vpc.id
  subnet_id = module.my_subnet.subnet.id
}