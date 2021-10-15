variable "username" {
  description = "The username of the user that is deploying this."
  type        = string
}

variable "az" {
  description = "The avaliability zone that these subnets are being deployed in."
  type        = string
}

variable "az_suffix" {
  description = "The suffix value for the avaliability zone i.e. a, b, c, d ...etc"
}

variable "vpc_id" {
  description = "The ID of the vpc that these subnets are being deployed in."
  type        = string
}

variable "private_cidr_block" {
  description = "The CIDR block that you want to associate the private subnet to."
  type        = string
}

variable "public_cidr_block" {
  description = "The CIDR block that you want to associate the public subnet to."
  type        = string
}

variable "internet_gateway_id" {
  type        = string
  default     = null
  description = "The Internet Gateway ID to include in the route table for the public subnet."
}
