output "task_definition_arn" {
  value       = aws_ecs_task_definition.wordpress_task.arn
}

output "task_definition_family" {
  value       = aws_ecs_task_definition.wordpress_task.family
}
