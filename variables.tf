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
  default     = "liamjohnston"
}

variable "app_name" {
  type        = string
  description = "The name of this application"
  default     = "baseinfra"
}

variable "project_name" {
  type        = string
  description = "The name of the project that this app is apart of."
  default     = "node-weather-app"
}

variable "cidr_address" {
  type        = string
  description = "The CIDR Address of the VPC"
  default     = "10.1.0.0/22"

  validation {
    condition     = alltrue([for byte in split(".", split("/", var.cidr_address)[0]) : parseint(byte, 10) > -1 && parseint(byte, 10) < 255])
    error_message = "Invalid CIDR Address, one or more bytes have invalid values."
  }

  validation {
    condition     = parseint(split("/", var.cidr_address)[1], 10) < 24
    error_message = "Invalid CIDR Address, the subnet range is too small for this application."
  }
}
