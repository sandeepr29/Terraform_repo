variable "vpc_cidr" {
 default = " "
}

variable "tenancy" {
 default = ""
}

variable "subnet_cidr" {
 type = "list"
}


variable "zones" {
    type    = "list"
}

variable "ami" {}


variable "instance_type" {}

variable "key_name" {}
