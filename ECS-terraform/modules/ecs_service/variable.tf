# variables.tf
variable "ecs_cluster_id" {
  type        = string
}

variable "ecs_task_definition" {
  type        = string
}

variable "security_group_id" {
  type        = string
}

variable "subnet_id" {
type        = list(string)

}

variable "desired_count" {
  type        = number
}