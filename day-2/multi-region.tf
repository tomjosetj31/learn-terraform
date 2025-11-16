provider "aws" {
    alias = "eu-central-1"
    region = "eu-central-1"
}

provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

resource "aws_instance" "example-eu" {
    provider = aws.eu-central-1
    ami = "ami-0108a2280f5bb78d7"
    instance_type = "t2.micro"
    tags = {
        Name = "terraform-example-eu"
    }
    subnet_id = "subnet-0108a2280f5bb78d7"
    key_name = "terraform-example"
}

resource "aws_instance" "example-us" {
    provider = aws.us-east-1
    ami = "ami-0108a2280f5bb78d7"
    instance_type = "t2.micro"
    tags = {
        Name = "terraform-example-us"
    }
    subnet_id = "subnet-0108a2280f5bb78d7"
    key_name = "terraform-example"
}