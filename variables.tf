variable "vm_name" {
  type        = string
  description = "Name of the newly created VM"

}

variable "admin_username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The password for the local account that will be created on the new VM."
  default     = "Systech123"
}

variable "hostname" {

  type        = string
  description = "The Host name of the newly created VM."
  default     = "azurevm"
}

variable "publisher" {
  type        = string
  description = "the publisher's name  of the OS that need to install in the new VM "

}

variable "offer" {
  type        = string
  description = "the probuct name of the OS that need to install in the new VM"

}

variable "sku" {
  type        = string
  description = "This will represents the specific variant of the product"
}

variable "os_version" {
  type        = string
  description = "The version of the image "
  default     = "latest"
}

variable "tags" {
  type        = string
  description = "To tags the resoucre under one name"
}

variable "location" {
  type        = string
  description = "The region to deploy resources"

}