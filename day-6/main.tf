provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
    description = "The AMI ID to deploy"
    type = string
}

variable "instance_type" {
    description = "The instance type to deploy"
    # type = string
    type = map(string) # new approach
    default = {
        "dev" =  "t2.micro"
        "stg" = "t2.medium"
        "prod" = "t2.xlarge" 
    }
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_id = var.ami_id
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  
}