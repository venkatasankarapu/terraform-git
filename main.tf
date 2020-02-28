provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}

variable "vpc_cidr" {
	description = "CIDR for vpc"
	default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
	description = "CIDR for pulic subnet"
	default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
	description = "CIDR for private subnet"
	default = "10.0.2.0/24"
}

resource "aws_vpc" "Nike" {
	cidr_block = "${var.vpc_cidr}"
	enable_dns_hostnames = true
	
	tags = {
	  Name = "Nike-vpc"
	}
}

resource "aws_subnet" "nike-public-subnet" {
	vpc_id = "${aws_vpc.Nike.id}"
	cidr_block = "${var.public_subnet_cidr }"
	availability_zone = "us-east-2a"
	
	tags = {
	  Name = "Nike web public subnet"
	}
}

resource "aws_subnet" "nike-private-subnet" {
        vpc_id = "${aws_vpc.Nike.id}"
        cidr_block = "${var.private_subnet_cidr }"
        availability_zone = "us-east-2b"

        tags = {
          Name = "Nike database private subnet"
        }
}

resource "aws_internet_gateway" "gw" {
	vpc_id = "${aws_vpc.Nike.id}"

	tags = {
	  Name = "Nike IGW"
	}
}

resource "aws_route_table" "web-public-rt" {
	vpc_id = "${aws_vpc.Nike.id}"

	route {
	  cidr_block = "0.0.0.0/0"
	  gateway_id = "${aws_internet_gateway.gw.id}"
	}

	tags = {
	  Name = "public subnet RT"
	}
}	

resource "aws_route_table_association" "web-public-rt" {
	subnet_id = "${aws_subnet.nike-public-subnet.id}"
	route_table_id = "${aws_route_table.web-public-rt.id}"
}

resource "aws_security_group" "web" {
  name = "vpc_nike_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.Nike.id}"

  tags = {
    Name = "Web SG"
  }
}
	

resource "aws_instance" "Nike-Test"  {
  ami = "ami-f4f4cf91"   # ubuntu 16.04
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.nike-public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("install.sh")}"
   
  tags = {
     name ="Nike-web"
	}
}


