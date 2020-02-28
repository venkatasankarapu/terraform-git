provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}


resource "aws_instance" "Nike-Test"  {
  ami = "ami-f4f4cf91"   # ubuntu 16.04
  instance_type = "t2.micro"
   
  tags = {
     name ="Nike-test"
   }
}


