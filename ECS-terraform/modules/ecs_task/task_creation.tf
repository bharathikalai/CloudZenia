resource "aws_ecs_task_definition" "wordpress_task" {
  family                   = var.family
  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = var.name
    image     = var.image
    essential = true

    memory    = var.memory
    cpu       = var.cpu

    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.host_port
      protocol      = var.protocol
    }]
  }])
}
