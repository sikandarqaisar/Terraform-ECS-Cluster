//LOAD-BALANCER-PARAMETERS
name_prefix = "sikandar-prod"
aws_region = "us-east-2"
desired_capacity_on_demand = "2"
ec2_key_name = "sikandarKeypair-ohio"
instance_type = "t2.micro"
ecs_image_id = "ami-0329a1fdc914b0c55"
TgName = ["TG1","TG2"]
LBport = ["8080","8081"]
serviceCount=1
max_size=3
min_size=0













//ECS-PARAMETERS
count_webapp = 2
minimum_healthy_percent_webapp = 50
hostPort=["8080","8081"]
containerName= ["container1", "container2"]
webapp_docker_image_tag = ["latest", "latest"]
webapp_docker_image_name = ["nginx", "httpd"]
task_definition  = ["webapp1", "webapp2"]
ecs_name = ["service1", "service2"]







//VPC-PARAMETERS
subnet_azs = "a,b"
