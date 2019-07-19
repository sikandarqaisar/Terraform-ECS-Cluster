data "template_file" "task_webapp" {
    count="${var.serviceCount}"
    template= "${file("./modules/ecs/templates/ecs_task_webapp.tpl")}"
    vars = {
        containerName = "${var.containerName[count.index]}"
        webapp_docker_image = "${element(var.webapp_docker_image_name,count.index)}:${element(var.webapp_docker_image_tag,count.index)}"
        hostPort ="${element(var.hostPort,count.index)}"
    }
}
