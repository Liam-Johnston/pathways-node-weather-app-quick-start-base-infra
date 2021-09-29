variable "az" {
  description = "The avaliability zone that this subnet is being deployed in."
  type        = string
}

variable "az_suffix" {
  description = "The suffix value for the avaliability zone i.e. a, b, c, d ...etc"
}

variable "vpc_id" {
  description = "The ID of the vpc that this subnet is being deployed in."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block that you want to associate this subnet to."
  type        = string
}

variable "username" {
  description = "The username of the user that is deploying this."
  type        = string
}

variable "subnet_type" {
  description = "The type of subnet that this is. Either 'private' or 'public'"
  type        = string

  validation {
    condition     = var.subnet_type == "private" || var.subnet_type == "public"
    error_message = "Invalid subnet type, the accepted subnet type is either 'private' or 'public'."
  }
}

variable "rt_gw_id" {
  type        = string
  default     = null
  description = "The Internet Gateway ID to include in the route table for this subnet. This variable is mutually exclusive of the variable 'rt_nat_gw_id'."
}

variable "rt_nat_gw_id" {
  type        = string
  default     = null
  description = "The NAT Gateway ID of the public subnet deployed in the same avaliability zone. This variable is mutually exclusive of the variable 'rt_gw_id'."
}


