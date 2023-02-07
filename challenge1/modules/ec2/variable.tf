variable "ami" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "key_name" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list
  default = []
}

variable "vpc_security_group_ids" {
  type    = list
  default = []
}

variable "associate_public_ip_address" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "total_instance" {
    type = number 
}

variable "prefix" {
    type = string 
}

variable "vpc_id" {
    type = string 
}