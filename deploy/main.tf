module "networking" {
  source = "./modules/networking"

  username     = var.username
  cidr_address = var.cidr_address
  region       = var.region
  az_names     = data.aws_availability_zones.available.names
}

module "container_registry" {
  source = "./modules/ecr"

  username     = var.username
  project_name = var.project_name
}

module "self_healing_service" {
  source = "./modules/self_healing_function"

  username            = var.username
  project_name        = var.project_name
  github_access_token = var.github_access_token
}

output "container_registry_name" {
  description = "The url of the container registry that is deployed with this app."
  value       = module.container_registry.container_registry_name
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name}"]
}

output "bucket_name_arn" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name_arn}"]
}
