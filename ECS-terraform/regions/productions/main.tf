provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket  = "cloud-zeina-terraform-state"
    key     = "Cloud-zeina-ECS/staging/terraform/state.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

module "ecs_cluster" {
  source           = "/home/bharathibk/Downloads/bb/CloudZenia/ECS-terraform/modules/ecs_cluster"
  ecs_cluster_name = var.ecs_cluster_name
}

# Output ECS Cluster Name
output "ecs_cluster_name" {
  value = module.ecs_cluster.ecs_cluster_name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

module "ecs_task_definition" {
  source                    = "/home/bharathibk/Downloads/bb/CloudZenia/ECS-terraform/modules/ecs_task"
  family                    = var.family
  requires_compatibilities  = var.requires_compatibilities
  network_mode              = var.network_mode
  cpu                       = var.cpu
  memory                    = var.memory
  execution_role_arn        = var.execution_role_arn
  task_role_arn             = var.task_role_arn
  name                      = var.name
  image                     = var.image
  container_port            = var.container_port
  host_port                 = var.host_port
  protocol                  = var.protocol
}

output "task_definition_arn" {
  value = module.ecs_task_definition.task_definition_arn
}

output "task_definition_family" {
  value = module.ecs_task_definition.task_definition_family
}


module "ecs_service" {
  source = "/home/bharathibk/Downloads/bb/CloudZenia/ECS-terraform/modules/ecs_service"

  ecs_cluster_id      = module.ecs_cluster.ecs_cluster_id 
  ecs_task_definition = module.ecs_task_definition.task_definition_arn
  security_group_id   = "sg-045074e3d55f242e9"
  subnet_id           = ["subnet-06367989c8e6fc6a4", "subnet-0785ba59f3c5735cb"]
  desired_count       = 2
}

# Outputs
output "ecs_cluster_id" {
  value = module.ecs_cluster.ecs_cluster_id
}

output "ecs_task_definition_arn" {
  value = module.ecs_task_definition.task_definition_arn
}

output "ecs_task_definition_family" {
  value = module.ecs_task_definition.task_definition_family
}