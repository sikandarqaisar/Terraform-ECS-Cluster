provider "aws"{
    region= "us-east-2"
}

module "vpc"{
    source = "./modules/vpc"
    subnet_azs= "${var.subnet_azs}"
    aws_region= "${var.aws_region}"
    name_prefix= "${var.name_prefix}"
}
module "iam"{
    source = "./modules/IAM/iam"
    aws_region= "${var.aws_region}"
    name_prefix= "${var.name_prefix}"     
}
module "LB-ASG"{
    source = "./modules/LB-ASG"
    desired_capacity_on_demand= "${var.desired_capacity_on_demand}"
    ec2_key_name= "${var.ec2_key_name}"
    max_size="${var.max_size}"
    min_size="${var.min_size}"
    instance_type= "${var.instance_type}"
    serviceCount="${var.serviceCount}"
    ecs_image_id= "${var.ecs_image_id}" 
    aws_region= "${var.aws_region}"
    name_prefix= "${var.name_prefix}" 
    LBport ="${var.LBport}"
    TgName= "${var.TgName}" 
    webapp_cluster_name= "${module.ecs.webapp_cluster_name}"
    sg_webapp_instances_id ="${module.vpc.sg_webapp_instances_id}"
    vpc_id ="${module.vpc.vpc_id}"
    subnet_ids= "${module.vpc.subnet_ids}"
    ecs_instance_profile="${module.iam.ecs_instance_profile}"
    ecs_service_role="${module.iam.ecs_service_role}"
    sg_webapp_albs_id ="${module.vpc.sg_webapp_albs_id}"
}
module "ecs"{
    source ="./modules/ecs"
    serviceCount="${var.serviceCount}"
    aws_region= "${var.aws_region}"
    name_prefix= "${var.name_prefix}"
    ecs_name="${var.ecs_name}"
    task_definition="${var.task_definition}"
    containerName="${var.containerName}"
    hostPort="${var.hostPort}"
    ecs_service_role="${module.iam.ecs_service_role}"
    webapp_tg_Arn= "${module.LB-ASG.webapp_tg_Arn}"
    webapp_docker_image_name= "${var.webapp_docker_image_name}"
    webapp_docker_image_tag= "${var.webapp_docker_image_tag}"
    count_webapp= "${var.count_webapp}"
    desired_capacity_on_demand= "${var.desired_capacity_on_demand}"
    minimum_healthy_percent_webapp= "${var.minimum_healthy_percent_webapp}"
 }

