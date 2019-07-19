//LOAD-BALANCER-PARAMETERS
variable "name_prefix" {}
variable "aws_region" {}
variable "desired_capacity_on_demand" {}
variable "ec2_key_name" {}
variable "instance_type" {}
variable "ecs_image_id" {}
variable "min_size" {}
variable "max_size" {}
variable "TgName"{
    type="list"
}
variable "LBport"{
    type="list"
}

variable "serviceCount"{}






//ECS-PARAMETERS
variable "count_webapp" {}
variable "minimum_healthy_percent_webapp" {}
variable "ecs_name" {
    type    = "list"
    } 
variable "task_definition" {
    type    = "list"
    } 
variable "webapp_docker_image_name" { 
    type    = "list"
    }
variable "webapp_docker_image_tag" {
     type    = "list"
}
variable "containerName" {
     type    = "list"
}
variable "hostPort"{
     type    = "list"
}





//VPC-PARAMETERS
variable "subnet_azs" {}