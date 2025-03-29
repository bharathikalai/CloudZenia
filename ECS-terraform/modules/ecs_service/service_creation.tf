resource "aws_ecs_service" "service" {
  name            = "my-ecs-service"
  cluster         = var.ecs_cluster_id
  task_definition = var.ecs_task_definition
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.subnet_id]
    security_groups = [var.security_group_id]
    assign_public_ip = false
  }
  
  depends_on = [aws_ecs_cluster.cluster]
}