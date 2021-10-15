variable "username" {
  type        = string
  description = "Username of who is deploying this, for naming purposes"
  default     = "liamjohnston"
}

variable "project_name" {
  type = string
  description = "The name of the project that this app is apart of."
  default = "pathwaysdojo"
}
