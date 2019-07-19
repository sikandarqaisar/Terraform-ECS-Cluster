data "template_file" "autoscaling_user_data" {
    template = "${file("./modules/LB-ASG/templates/autoscaling_user_data.tpl")}"
    vars ={
        ecs_cluster = "${var.webapp_cluster_name}"
    }
}