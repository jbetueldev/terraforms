variable "public_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "az" {
  type        = string
  description = "Availability Zone"
  default     = "us-east-1a"
}

variable "key_name" {
  default = "NodeJS-MySQL-Todo"
}