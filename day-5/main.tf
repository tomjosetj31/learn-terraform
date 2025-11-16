provider "aws" {
    region = "eu-central-1"
}

variable "cidr" {
    default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
    key_name = "terraform-example"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-central-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route" "route" {
    route_table_id = aws_route_table.rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
    name = "terraform-example"
    description = "terraform-example"
    vpc_id = aws_vpc.myvpc.id
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
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "terraform-example"
    }
}

resource "aws_instance" "server" {
    ami = "ami-0108a2280f5bb78d7"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet1.id
    security_groups = [aws_security_group.sg.id]
    key_name = aws_key_pair.example.key_name
    tags = {
        Name = "terraform-example"
    }
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("~/.ssh/id_rsa")
        host = self.public_ip
    }
    provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y python3-pip",
            "pip3 install flask",
            "python3 /home/ubuntu/app.py",
        ]
    }
}