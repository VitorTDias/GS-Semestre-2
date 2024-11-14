variable "rg_name" {
    type    = string
    default = "rg2-gs-semestre2"
}

variable "location" {
    type    = string
    default = "brazilsouth"
}

variable "vnet10_cidr" {
    type    = string
    default = "10.0.0.0/16"
}

variable "subnet_vnet10a_cidr" {
    type    = string
    default = "10.0.1.0/24"
}

variable "subnet_vnet10b_cidr" {
    type    = string
    default = "10.0.2.0/24"
}
