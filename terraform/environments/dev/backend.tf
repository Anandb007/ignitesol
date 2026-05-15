terraform {
  backend "s3" {
    bucket         = "ignitesol-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ignitesol-terraform-locks"
    encrypt        = true
  }
}
