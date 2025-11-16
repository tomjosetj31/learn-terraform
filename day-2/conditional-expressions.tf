provider "aws" {
    region = "eu-central-1"
}

variable "environment" {
    description = "The environment to deploy the resources in"
    type = string
    default = "development"
}

resource "aws_instance" "example" {
    ami = "ami-0108a2280f5bb78d7"
    instance_type = var.environment == "production" ? "t2.large" : "t2.micro"
    tags = {
        Environment = var.environment
        Name = var.environment == "production" ? "prod-instance" : "dev-instance"
    }
}

output "instance_id" {
    description = "The instance created"
    value = aws_instance.example.id
}