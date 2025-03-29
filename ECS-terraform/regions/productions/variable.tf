variable "ecs_cluster_name" {
  type    = string
  default = "cloud-zeina-production-cluster"
}


variable "name" {
    type    = string
    default = "wordpress"
}

variable "family" {
  type    = string
  default = "wordpress-task"
}

variable "requires_compatibilities" {
  type    = list(string)
  default = ["FARGATE"]
}

variable "network_mode" {
  type    = string
  default = "awsvpc"
}

variable "image" {
  type    = string
  default = "wordpress:latest"
}

variable "memory" {
  type    = number
  default = 512
}

variable "cpu" {
  type    = number
  default = 256
}

variable "container_port" {
  type    = number
  default = 80
}

variable "host_port" {
  type    = number
  default = 80
}

variable "protocol" {
  type    = string
  default = "tcp"
}

# Role ARNs
variable "execution_role_arn" {
  type    = string
  default = "arn:aws:iam::454180850305:role/ecsTaskExecutionRole"
}

variable "task_role_arn" {
  type    = string
  default = null 
}



