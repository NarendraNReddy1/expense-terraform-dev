module "db" {
  source = "git::https://github.com/NarendraNReddy1/terraform-aws-secruitygroup.git"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB MySQL Instances"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_name="db"
  common_tags = var.common_tags

}

module "backend" {
  source = "git::https://github.com/NarendraNReddy1/terraform-aws-secruitygroup.git"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for backend Instances"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_name="backend"
  common_tags = var.common_tags

}

module "bastion" {
  source = "git::https://github.com/NarendraNReddy1/terraform-aws-secruitygroup.git"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for bastion Instances"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_name="bastion"
  common_tags = var.common_tags

}


module "ansible" {
  source = "git::https://github.com/NarendraNReddy1/terraform-aws-secruitygroup.git"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for ansible Instances"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_name="ansible"
  common_tags = var.common_tags

}




module "frontend" {
  source = "git::https://github.com/NarendraNReddy1/terraform-aws-secruitygroup.git"
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

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  to_port           = 3306
  from_port         = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #backend
  security_group_id = module.db.sg_id
}

#### BACKEND


resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  to_port           = 8080
  from_port         = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id #backend
  security_group_id = module.backend.sg_id
}


resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #backend
  security_group_id = module.backend.sg_id
}


resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id #backend
  security_group_id = module.backend.sg_id
}


##### FRONTEND

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}


resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.frontend.sg_id
}


### BASTION

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}


##### ANSIBLE
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ansible.sg_id
}



