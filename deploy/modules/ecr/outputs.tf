output "container_registry_name" {
  description = "The url of the container registry"
  value = aws_ecr_repository.this.name
}
