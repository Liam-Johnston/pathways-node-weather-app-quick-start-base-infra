resource "aws_ecr_repository" "this" {
  name              = "${var.username}-${var.project_name}"
}

resource "aws_ssm_parameter" "ecr_repository_name_store" {
  name  = "/${var.username}/${var.project_name}/ecr_repository_url"
  type  = "String"
  value = aws_ecr_repository.this.repository_url
}
