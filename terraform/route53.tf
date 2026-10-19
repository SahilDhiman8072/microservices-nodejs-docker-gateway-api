resource "aws_route53_zone" "microapp_zone" {
  name = "sahildevops.online"
}


resource "aws_route53_record" "microapp_cname" {
  zone_id = aws_route53_zone.microapp_zone.zone_id
  name    = "app.sahildevops.online"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.microapp_bl.dns_name]
}
