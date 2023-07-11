# Create Target Group
resource "aws_lb_target_group" "target_group" {
  name        = var.name-tg
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vcp-tg-id
  target_type = "instance"
   health_check {
    enabled = true
    path    = "/"
  }

}


