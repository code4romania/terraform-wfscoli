resource "aws_route53_zone" "main" {
  name = "${var.subdomain}.wfscoli.ro"
}
