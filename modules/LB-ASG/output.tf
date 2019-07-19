
output "alb_dns_name" {
    value = "${aws_alb.main.dns_name}"
}
output "webapp_tg_Arn"{
    value = "${aws_alb_target_group.webapp_tg.*.arn}"
}
