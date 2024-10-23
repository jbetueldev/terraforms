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

variable "subnets" {
  default = ["subnet-03fce9776ad049bb1", "subnet-03a3677ab22f481ed", "subnet-022143b44cf322ff2"] # Default VPC subnets - ["subnet-0e9e104ecefec7134", "subnet-05ef39f53289ba7ce", "subnet-0a287b1973b613896"]
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "metabase/metabase:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "3000"

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

# variable "rds_writer_endpoint" {
#   default = aws_rds_cluster.dev_london_general_purpose_rds.endpoint
# }