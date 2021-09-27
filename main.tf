module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}

module "networking" {
  source = "./modules/networking"

  username     = var.username
  cidr_address = "10.1.0.0/23"
  region       = var.region
  az_names     = data.aws_availability_zones.available.names
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name}"]
}

output "bucket_name_arn" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name_arn}"]
}
