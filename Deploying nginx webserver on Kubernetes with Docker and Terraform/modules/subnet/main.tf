resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "k8s-igw"
  }
}

resource "aws_subnet" "k8s_public_sub" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-public-sub"
  }
}


resource "aws_default_route_table" "k8s_public_rtb" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "k8s_public_rtb"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.k8s_public_sub.id
  route_table_id = aws_default_route_table.k8s_public_rtb.id
}