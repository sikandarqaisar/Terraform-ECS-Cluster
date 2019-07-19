resource "aws_launch_configuration" "webapp_on_demand" {
    instance_type = "${var.instance_type}"
    image_id = "${var.ecs_image_id}"
    iam_instance_profile = "${var.ecs_instance_profile}"
    user_data = "${data.template_file.autoscaling_user_data.rendered}"
    key_name = "${var.ec2_key_name}"
    security_groups = ["${var.sg_webapp_instances_id}"]
    associate_public_ip_address = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "webapp_on_demand" {
    name = "${var.name_prefix}_webapp_on_demand"
    max_size = "${var.max_size}"
    min_size = "${var.min_size}"
    desired_capacity = "${var.desired_capacity_on_demand}" 
    health_check_grace_period = 300
    health_check_type = "EC2"
    force_delete = true
    launch_configuration = "${aws_launch_configuration.webapp_on_demand.name}"
    vpc_zone_identifier =  "${compact(split(",", var.subnet_ids))}"

    tag {
        key = "Name"
        value = "${var.name_prefix}-webapp"
        propagate_at_launch = true
    }

    lifecycle {
        create_before_destroy = true
    }
}






//LOAD BALANCER

resource "aws_alb" "main" {
  lifecycle { create_before_destroy = true }
  name = "${var.name_prefix}-webapp-alb"
  subnets = "${compact(split(",", var.subnet_ids))}"
  security_groups = ["${var.sg_webapp_albs_id}"]
  idle_timeout = 400
  tags ={
        Name = "${var.name_prefix}_webapp_alb"
  }
}

resource "aws_alb_target_group" "webapp_tg" {
  count="${var.serviceCount}"
  name                 = "${var.TgName[count.index]}"
  port                 = "${element(var.LBport,count.index)}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"

  deregistration_delay = 10

  health_check {
    interval            = "60"
    path                = "/"
    port                = "${element(var.LBport,count.index)}"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"
    protocol            = "HTTP"
  }

  tags ={
        Name = "${var.name_prefix}_webapp_tg"
  }

  depends_on = ["aws_alb.main"]
}

resource "aws_alb_listener" "frontend_http" {
  count="${var.serviceCount}"
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "${element(var.LBport,count.index)}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.webapp_tg[count.index].id}"
    type             = "forward"
  }

  depends_on = ["aws_alb.main"]
}
