variable "compartment_id" {
  type = string
}

variable "comp_source_id" {
  type = string
}

variable "comp_display_name" {
  type    = string
  default = "ubuntu"
}

variable "ssh_key_path" {
  description = "ssh key location on local."
  type        = string
}

variable "domain_id" {
  description = "root id for parent compartment"
  type        = string
}

variable "tenancy_ocid" {
  description = ""
  type = string
}

variable "user_ocid" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "region" {
  type = string
}
