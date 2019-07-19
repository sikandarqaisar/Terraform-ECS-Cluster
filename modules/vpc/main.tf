resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags ={
        Name = "${var.name_prefix}-webapp"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags ={
        Name = "${var.name_prefix}-webapp"
    }
}

resource "aws_route_table" "r" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags  ={
        Name = "${var.name_prefix}-webapp"
    }
}

resource "aws_main_route_table_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.r.id}"
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
    domain_name_servers = ["AmazonProvidedDNS"]

    tags  ={
        Name = "${var.name_prefix}-webapp"
    }
}

resource "aws_vpc_dhcp_options_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}

resource "aws_subnet" "subnet" {
    count = 2
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.${count.index}.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${var.aws_region}${element(split(",", var.subnet_azs), count.index)}"
    tags  ={
        Name = "${var.name_prefix}-webapp"
    }
}








//SECURITY GROUP



resource "aws_security_group" "webapp_albs" {
    name = "${var.name_prefix}-webapp-albs"
    vpc_id = "${aws_vpc.main.id}"
    description = "Security group for ALBs"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        
    ingress {
        from_port = 8081
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags ={
        Name = "${var.name_prefix}-webapp"
    }
}

resource "aws_security_group" "webapp_instances" {
    name = "${var.name_prefix}-webapp-instances"
    vpc_id = "${aws_vpc.main.id}"
    description = "Security group for instances"

    tags ={
        Name = "${var.name_prefix}-webapp"
    }
}

resource "aws_security_group_rule" "allow_all_egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.webapp_instances.id}"
}


resource "aws_security_group_rule" "allow_all_from_albs" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"

    security_group_id = "${aws_security_group.webapp_instances.id}"
    source_security_group_id = "${aws_security_group.webapp_albs.id}"
}


resource "aws_security_group_rule" "allow_ssh_from_internet" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.webapp_instances.id}"
}
