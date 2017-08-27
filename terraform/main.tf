# Ensure you have AWS access id and secret as env

provider "aws" {
  region = "ap-southeast-2"
}

data "aws_security_group" "existing" {
  id = "sg-1891197f"
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-e2021d81"
  instance_type = "t2.micro"
  key_name = "aws.home"
  security_groups  = ["${data.aws_security_group.existing.id}"]

  user_data = <<-EOF
              #!/bin/bash
              curl -fsSL get.docker.com -o get-docker.sh
              sudo sh get-docker.sh
              sudo usermod -aG docker ubuntu
              EOF
 lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size = 3
  max_size = 3
  # load_balancers = ["${aws_elb.example.name}"]
  # health_check_type = "ELB"
  tag {
    key = "Name"
    value = "mgr-node-${count.index}"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {}
