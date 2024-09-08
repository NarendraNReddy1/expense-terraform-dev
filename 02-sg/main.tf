module "db" {
  source = "../../terraform-aws-secruitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB MySQL Instances"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_name="db"
  common_tags = var.common_tags

}

module "backend" {
  source = "../../terraform-aws-secruitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for backend Instances"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_name="backend"
  common_tags = var.common_tags

}



module "frontend" {
  source = "../../terraform-aws-secruitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for frontend Instances"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_name="frontend"
  common_tags = var.common_tags

}

##### RULES

resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  to_port           = 3306
  from_port         = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id #backend
  security_group_id = module.db.sg_id
}


resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  to_port           = 8080
  from_port         = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id #backend
  security_group_id = module.backend.sg_id
}


resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}


