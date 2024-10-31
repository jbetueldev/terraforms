variable "aws_access_key" {
  description = "The IAM public access key"
}

variable "aws_secret_key" {
  description = "IAM secret access key"
}

variable "aws_region" {
  description = "The AWS region things are created in"
}

variable "vpc" {
  default = "vpc-06b1d9d81eb12e0e3" # Default VPC ID - "vpc-0ecaddf0718b263ba"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16" # Default VPC CIDR
}

variable "subnets" {
  default = ["subnet-03fce9776ad049bb1", "subnet-03a3677ab22f481ed", "subnet-022143b44cf322ff2"] # Default VPC subnets - ["subnet-0e9e104ecefec7134", "subnet-05ef39f53289ba7ce", "subnet-0a287b1973b613896"]
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"] # Default AZs - ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "metabase/metabase:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "3000"
}

variable "app_url" {
  default = "https://metabase-test.spinbet.com"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = "1"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "4096"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "8192"
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}

variable "location" {
  description = "Deployment location"
  default     = "london"
}