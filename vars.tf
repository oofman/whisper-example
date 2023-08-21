variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "whisper-example"
}

variable "ssh-source-address" {
  type    = string
  default = "*" # replace with your IP / Office VPN IP
}