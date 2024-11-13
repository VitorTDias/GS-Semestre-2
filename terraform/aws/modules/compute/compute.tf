# RESOURCE: SECURITY GROUP
resource "aws_security_group" "vpc_sg_pub" {
    vpc_id = var.vpc10_id
    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = [var.vpc_cidr]
    }
    
    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg_elb" {
  name        = "sg_elb"
  description = "sg_elb"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_elb"
  }
}

resource "aws_lb" "ec2_lb" {
  name               = "ec2-elb"
  load_balancer_type = "application"
  subnets            = [var.sn_vpc10_pub1a, var.sn_vpc10_pub1b]
  security_groups    = [aws_security_group.sg_elb.id]
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "lbtg"
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "ec2_lb_listener" {
  protocol          = "HTTP"
  port              = 80
  load_balancer_arn = aws_lb.ec2_lb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}


data "template_file" "user_data" {
    template = "${file("./modules/compute/scripts/user_data.sh")}"
}

resource "aws_instance" "instance-a" {
    ami                    = var.ec2_ami
    instance_type          = "t2.micro"
    subnet_id              = var.sn_vpc10_pub1a
    vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
    user_data              = "${base64encode(data.template_file.user_data.rendered)}"
    key_name               = "vockey"
    tags = {
        Name = "instance-a"
    }
}

resource "aws_instance" "instance-b" {
    ami                    = var.ec2_ami
    instance_type          = "t2.micro"
    subnet_id              = var.sn_vpc10_pub1b
    vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
    user_data              = "${base64encode(data.template_file.user_data.rendered)}"
    key_name               = "vockey"
    tags = {
        Name = "instance-b"
    }
}

resource "aws_instance" "instance-c" {
 	ami = var.ec2_ami
	 instance_type = "t2.micro"
 	subnet_id = var.sn_vpc10_pub1a
 	vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
 	user_data = "${base64encode(data.template_file.user_data.rendered)}"
 	key_name = "vockey"
	 tags = {
 		Name = "instance-c"
 }
}
resource "aws_instance" "instance-d" {
 	ami = var.ec2_ami
 	instance_type = "t2.micro"
 	subnet_id = var.sn_vpc10_pub1b
 	vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
	user_data = "${base64encode(data.template_file.user_data.rendered)}"
 	key_name = "vockey"
 	tags = {
		 Name = "instance-d"
 }
}


