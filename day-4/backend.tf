terraform {
    backend "s3" {
        bucket = "terraform-state-file-bucket"
        region = "eu-central-1"
        key = "tom/terraform.tfstate"
        dynamodb_table = "terraform-state-file-lock-table"
    }
}