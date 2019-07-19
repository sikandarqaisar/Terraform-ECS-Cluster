resource "aws_ecs_cluster" "webapp_cluster" {
    name = "${var.name_prefix}_webapp_cluster"
}


resource "aws_ecs_service" "webapp_service" {
    count="${var.serviceCount}"
    name = "${element(var.ecs_name , count.index)}"
    cluster = "${aws_ecs_cluster.webapp_cluster.id}"
    task_definition = "${aws_ecs_task_definition.webapp_definition[count.index].arn}"
    desired_count = "${var.count_webapp}"
    deployment_minimum_healthy_percent = "${var.minimum_healthy_percent_webapp}"
    iam_role = "${var.ecs_service_role}"

    load_balancer {
        target_group_arn = "${element(var.webapp_tg_Arn,count.index)}"
        container_name = "${element(var.containerName,count.index)}"        
        container_port = 80
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_task_definition" "webapp_definition" {
    count="${var.serviceCount}"
    family = "${element(var.task_definition,count.index)}"
    container_definitions = "${data.template_file.task_webapp[count.index].rendered}"

    lifecycle {
        create_before_destroy = true
    }
}