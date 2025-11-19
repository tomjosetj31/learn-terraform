provider "aws" {
    region = "eu-central-1"
}

provider "vault" {
    address = "http://127.0.0.1:8200"
    set_namespace_from_token = true

    auth_login {
      path = "auth/approle/login"
      parameters = {
        role_id = "1234567890"
        secret_id = "1234567890"
      }
    }
}

data "vault_kv_secret" "example" {
    namespace = "secret/data/terraform"
    path = "terraform"
}

resource "aws_instance" "example" {
    ami = "ami-0108a2280f5bb78d7"
    instance_type = "t2.micro"
    tags = {
        Name = "terraform-example-${data.vault_kv_secret.example.data["environment"]}"
    }
}

output "public_ip" {
    value = aws_instance.example.public_ip
}