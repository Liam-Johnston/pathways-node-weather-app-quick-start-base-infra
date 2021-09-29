provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner   = var.username
      Project = "pathwaysdojo"
    }
  }
}
