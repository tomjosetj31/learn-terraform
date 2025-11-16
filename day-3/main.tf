provider "aws" {
    region = "eu-central-1"
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_id = "ami-0108a2280f5bb78d7"
    instance_type = "t2.micro"
}