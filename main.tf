provider "aws" {
        region = "us-east-1"
}

#VPC
resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "${var.tenancy}"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "main-vpc-aws"
    }
}


# Subnets
# Subnet 1
resource "aws_subnet" "main-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_cidr[0]}"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.zones[0]}"

    tags {
        Name = "main-public-aws1"
    }
}

# Subnet 2
resource "aws_subnet" "main-private-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_cidr[1]}"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.zones[1]}"

    tags {
        Name = "main-private-aws1"
    }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "main-IGN-aws"
    }
}

# route tables
resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags {
        Name = "main-public-1-aws"
    }
}

# route associations public
#map/associate subnet 1 to route table
resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

# route associations private
#map/associate subnet 2 to route table
resource "aws_route_table_association" "main-private-1-a" {
    subnet_id = "${aws_subnet.main-private-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

#security-groups
resource "aws_security_group" "instance" {
  name = "terraform-aws-sec"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#aws-instance-1
#aws instance in subnet 1
resource "aws_instance" "my-instance-1" {
        ami = "${var.ami}"
        instance_type = "${var.instance_type}"
        #depends_on = [aws_vpc.main.id]
        #vpc_id = "${aws_vpc.main.id}"
        subnet_id = "${aws_subnet.main-public-1.id}"
        key_name = "${var.key_name}"
        vpc_security_group_ids = ["${aws_security_group.instance.id}"]
       user_data = "${file("develop.sh")}"
        tags = {
                name = "my-instance-1"
        }
}

output "vpc_id" {
 value = "${aws_vpc.main.id}"
}

output "pub_subnet_id" {
 value = "${aws_subnet.main-public-1.id}"
}

output "psubnet_id" {
 value =  "${aws_subnet.main-private-1.id}"
}
