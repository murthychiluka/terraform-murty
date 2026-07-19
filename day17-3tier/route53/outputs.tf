output "record_fqdn" {
  value = aws_route53_record.alb_alias.fqdn
}