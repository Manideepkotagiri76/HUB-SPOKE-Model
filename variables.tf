variable "example-vnet" {
  type = string
    description = "This is Spoke1-Vnet"
}

variable "example-subnet" {
  type = string
    description = "This is Spoke1-Subnet"
}

variable "example-vnet2" {
  type = string
    description = "This is Spoke2-Vnet"
}

variable "example-subnet2" {
  type = string
    description = "This is Spoke2-Subnet"
}

variable "example-rg1" {
  type = string
    description = "This is Spoke2-Subnet"
    default = "Spoke2-rg"
}

variable "example-rg" {
  type = string
    description = "This is Spoke2-Subnet"
    default = "Spoke1-rg"
}