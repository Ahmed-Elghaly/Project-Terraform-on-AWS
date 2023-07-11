resource "aws_lb" "network-lb" {
  name               = var.name-lb     #"network-lb1"
  internal           = var.state-lb
  load_balancer_type = "network"
  subnets            = [var.nlb-sub1-id, var.nlb-sub2-id]
}


#listner
resource "aws_lb_listener" "listner-1" {
  load_balancer_arn = aws_lb.network-lb.arn
  port              = 80
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = var.ltg-arn
  }
}


