resource "aws_alb" "swarm_cheguei_lb" {
  subnets         = module.cheguei_vpc.subnet_ids #[aws_subnet.containers_cheguei_subnet.id, aws_subnet.containers_cheguei_subnet_az_1b.id]
  security_groups = [aws_security_group.cheguei_security_group.id]
}

# Basic https listener to HTTPS certificate
resource "aws_alb_listener" "swarm_cheguei_lb_https" {
  load_balancer_arn = aws_alb.swarm_cheguei_lb.arn
  certificate_arn   = aws_acm_certificate_validation.swarm_cert.certificate_arn
  port              = "443"
  protocol          = "HTTPS"
  # Default action, and other paramters removed for BLOG
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.swarm_cheguei_instances.arn
  }
}

resource "aws_lb_target_group" "swarm_cheguei_instances" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.cheguei_vpc.vpc_id
}

# managers
resource "aws_lb_target_group_attachment" "swarm_cheguei_lb_attachment_managers" {
  target_group_arn = aws_lb_target_group.swarm_cheguei_instances.arn
  target_id        = module.ec2_instance_manager.id
  port             = 80
}

# workers
resource "aws_lb_target_group_attachment" "swarm_cheguei_lb_attachment_workers" {
  for_each = module.ec2_instance_worker_nodes

  target_group_arn = aws_lb_target_group.swarm_cheguei_instances.arn
  target_id        = each.value.id
  port             = 80
}

# Always good practice to redirect http to https
resource "aws_alb_listener" "swarm_cheguei_lb_http" {
  load_balancer_arn = aws_alb.swarm_cheguei_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
