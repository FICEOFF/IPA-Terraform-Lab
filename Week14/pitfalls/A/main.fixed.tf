module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name_prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

module "web_server" {
  source = "./modules/web-server"

  name_prefix   = local.name_prefix
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnets[0]
  ingress_rules = local.ingress_rules
  servers       = local.effective_servers
  root_volume   = local.effective_root_volume
  tags          = local.common_tags
}

resource "aws_security_group" "app" {
  name   = "${local.name_prefix}-app"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "db" {
  name   = "${local.name_prefix}-db"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "app_from_db" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.db.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
