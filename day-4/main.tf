provider "aws" {
    region = "eu-central-1"
}

module "ec2_instance" {
    source = "../day-3/modules/ec2_instance"
    ami_id = "ami-0108a2280f5bb78d7"
    instance_type = "t2.micro"
}

resource "aws_s3_bucket" "terraform_state_file_bucket" {
    bucket = "terraform-state-file-bucket"
    region = "eu-central-1"
}

resource "aws_dynamodb_table" "terraform_state_file_lock_table" {
    name = "terraform-state-file-lock-table"
    region = "eu-central-1"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}