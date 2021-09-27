variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "liam-johnston-my-tf-test-bucket"
}

variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default     = {}
}

variable "region" {
  type        = string
  description = "The region to deploy in"
  default     = "us-east-1"
}

variable "username" {
  type        = string
  description = "Username of who is deploying this, for naming purposes"
  default     = "liam-johnston"
}
