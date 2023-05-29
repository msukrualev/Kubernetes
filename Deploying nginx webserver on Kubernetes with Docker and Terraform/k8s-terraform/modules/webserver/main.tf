resource "aws_security_group" "control-plane-sec-gr" {
  name        = "control-plane-sec-gr"
  description = "control-plane-sec-gr"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 2379
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 10250
    to_port          = 10259
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 5473
    to_port          = 5473
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "control-plane-sec-gr"
  }
}

resource "aws_security_group" "worker-sec-gr" {
  name        = "worker-sec-gr"
  description = "worker-sec-gr"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 5473
    to_port          = 5473
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "worker-sec-gr"
  }
}



resource "aws_instance" "control" {
  ami           = "ami-0dba2cb6798deb6d8"
  instance_type = "t3a.small"
  key_name = "mehmet"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.control-plane-sec-gr.id]
  user_data = file("control-plane-userdata.sh")

  tags = {
    Name = "k8s-control-plane"
  }
}

resource "aws_instance" "worker" {
  ami           = "ami-0dba2cb6798deb6d8"
  instance_type = "t3a.small"
  key_name = "mehmet"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.worker-sec-gr.id]
  user_data = file("worker-userdata.sh")

  tags = {
    Name = "k8s-worker"
  }
}