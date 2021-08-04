variable "server_count" {
  type    = number
  default = 1
}

variable "server_image" {
  type = string
}

variable "client_count" {
  type    = number
  default = 2
}

variable "client_image" {
  type = string
}

variable "router_image" {
  type = string
}

variable "management_username" {
  type    = string
  default = "management"
}

variable "management_ssh_pubkey" {
  type = string
}

variable "management_ssh_port" {
  type    = number
  default = 22
}

variable "project_name" {
  type    = string
  default = "terraform"
}
