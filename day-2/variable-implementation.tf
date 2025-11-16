provider "aws" {
    region = "eu-central-1"
}

variable "instance_type" {
    description = "The instance type to deploy"
    type = string
    default = "t3.micro"
}

variable "ami_id" {
    description = "The AMI ID to deploy"
    type = string
    default = "ami-0108a2280f5bb78d7"
}

resource "aws_instance" "example" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        Name = "terraform-example"
    }
    subnet_id = "subnet-0108a2280f5bb78d7"
    key_name = "terraform-example"
}

output "public_ip" {
    description = "The public IP of the created Instance"
    value = awsinstance.example.public_ip
}