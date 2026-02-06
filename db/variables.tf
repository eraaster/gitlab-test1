variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for DB subnet group"
  type        = list(string)
}

variable "eks_node_sg_id" {
  description = "EKS node security group id (placeholder)"
  type        = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
