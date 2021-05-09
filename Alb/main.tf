#-----Create Application Load Balancer----------#
resource "aws_lb" "alb-web" {
  name               = "alb-web"
  internal           = false
  load_balancer_type = "application"
  subnets = [var.public_subnet_1, var.public_subnet_2]
  security_groups = [var.allow_web_traffic]
  enable_deletion_protection = false
  tags = {
    Environment = "alb-web"
  }
}

#------Create Target Group-------#
resource "aws_lb_target_group" "web" {
  name     = "terraform-example-alb-target"
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/"
    port = 80
  }
}

#--------Create Listener-----------#
resource "aws_lb_listener" "Web-Alb" {
  load_balancer_arn = aws_lb.alb-web.id
  port = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.web.id
    type = "forward"
  } 
}


#----Attach EC2 FE to Target Group----#
resource "aws_lb_target_group_attachment" "fe_1" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = var.Frontend_1
  port             = 80
}

resource "aws_lb_target_group_attachment" "fe_2" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = var.Frontend_2
  port             = 80
}
