variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

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
  default = "NodeJS-MySQL-Todo"          # AWS KEY PAIR SHOULD BE IN THE SAME FOLDER WHERE YOU RUN TERRAFORM COMMANDS
}
