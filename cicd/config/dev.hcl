bucket         = "devops-workflow-terraform-backend"
key            = "cicd/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-lock-table"