variable "username" {
  description = "The username of the user that is deploying this."
  type        = string
}


variable "cidr_address" {
  type        = string
  description = "The CIDR Address of the VPC"
}

variable "region" {
  type        = string
  description = "The region to deploy in"
}

variable "az_names" {
  type        = list(string)
  description = "A list of the names of the Avaliability Zones that this is getting deployed into"
}
