provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "example" {
    ami = "ami-0108a2280f5bb78d7"
    instance_type = "t2.micro"
    tags = {
        Name = "terraform-example"
    }
    subnet_id = "subnet-0108a2280f5bb78d7"
    key_name = "terraform-example"
}