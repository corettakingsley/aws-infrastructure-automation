
provider "aws" {
  region = "af-south-1"

  default_tags {
    tags = {
      Project     = "Nova-Retail"
      Environment = "Development"
      ManagedBy   = "Terraform"
    }
  }
}
