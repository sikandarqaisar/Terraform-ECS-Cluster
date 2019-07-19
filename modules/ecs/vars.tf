variable "name_prefix" {}
variable "aws_region" {}
variable "count_webapp" {}
variable "desired_capacity_on_demand" {}
variable "minimum_healthy_percent_webapp" {}
variable "webapp_tg_Arn"{}
variable "ecs_service_role" {}
variable "ecs_name" {} 
variable "task_definition" {} 
variable "webapp_docker_image_name" {}
variable "webapp_docker_image_tag" {}
variable "containerName" {}
variable "hostPort"{}
variable "serviceCount"{}
