#--------------------------VPC Module---------------------------------#
module "aws-vpc" {
  source           = "../../../../terraform-modules/vpc"
  vpc_cidr_block   = "${var.vpc_cidr_block}"
  vpc_tag          = "${var.vpc_tag}"
  dean_vpc_cidr_block   = "${var.dean_vpc_cidr_block}"
  dean_vpc_tag          = "${var.dean_vpc_tag}"
}

#--------------------------Subnet Module---------------------------------#
module "aws-subnet" {
  source            = "../../../../terraform-modules/subnet"
  vpc_id            = "${module.aws-vpc.vpc_id}"
  subnet_cidr_block = "${var.subnet_cidr_block}"
  subnet_tag        = "${var.subnet_tag}"
}

# #--------------------------Internetway Module---------------------------------#
module "aws-igw" {
 source                    = "../../../../terraform-modules/igw"
 vpc_id                    = "${module.aws-vpc.vpc_id}"
 subnet_id                 = "${module.aws-subnet.subnet_id}"
 destination_cidr_block    = "${var.destination_cidr_block}"
 public_subnet_cidr_blocks = "${var.public_subnet_cidr_blocks}"
 igw_tag                   = "${var.igw_tag}"
 rt_tag                    = "${var.rt_tag}"
 }

#-------------------------Nategateway Module---------------------------------#
module "aws-ngw" {
  source       = "../../../../terraform-modules/natgateway"
  vpc_id       = "${module.aws-vpc.vpc_id}"
  subnet_id    = "${module.aws-subnet.subnet_id}"
  }
#-------------------------Flow  log Module---------------------------------#
module "aws-flow-log" {
  source       = "../../../../terraform-modules/vpc-flow-logs"
  vpc_id       = "${module.aws-vpc.vpc_id}"
  }

#-------------------------ACL Module---------------------------------#
module "aws-acl" {
  source       = "../../../../terraform-modules/acl"
  vpc_id       = "${module.aws-vpc.vpc_id}"
  }

# #--------------------------SG Module---------------------------------#
module "aws-sg" {
  source                     = "../../../../terraform-modules/sg"
  security_group_name        = "${var.security_group_name}"
  security_group_description = "${var.security_group_description}"
  vpc_id                     = "${module.aws-vpc.vpc_id}"
  tcp_ports                  = "${var.tcp_ports}"
  cidrs                      = "${var.cidrs}"
  sg_tag                     = "${var.sg_tag}"
}


# #--------------------------IAM Module---------------------------------#
module "aws-iam" {
   source         = "../../../../terraform-modules/iam"
   user_count            = "${var.user_count}"
   CSS-Admin-Role        = "${var.CSS-Admin-Role}"
   CSS-Billing-Role      = "${var.CSS-Billing-Role}"
   CSS-Cust-Admin-Role   = "${var.CSS-Cust-Admin-Role}"
   CSS-Cust-ISSO-Role    = "${var.CSS-Cust-ISSO-Role}"
   CSS-Security-Role     = "${var.CSS-Security-Role}"
   CSS-Support-Role      = "${var.CSS-Support-Role}"
  
}

#--------------------------EC2 Module---------------------------------#
module "aws-ec2" {
  source           = "../../../../terraform-modules/ec2"
  ec2_count        = "${var.ec2_count }"
  ami_id           = "${var.ami_id }" 
  instance_type    = "${var.instance_type}"  
  ec2_tag          = "${var.ec2_tag}"  
  subnet_id        = "${element(module.aws-subnet.subnet_id, 0)}" 
 }

#   #   # #--------------------------RDS Module---------------------------------#
# # module "aws-rds" {
# #   source                         = "../../../../terraform-modules/rds"
# #    vpc_id                        = "${module.aws-vpc.vpc_id}"
# #    subnet_id1                    = "${element(module.aws-subnet.subnet_id, 0)}" 
# #    subnet_id2                    = "${element(module.aws-subnet.subnet_id, 1)}"
# #    rds_name                      = "${var.rds_name}"
# #    protocol                      = "${var.protocol}"
# #    to_port                       = "${var.to_port}"
# #    type                          = "${var.type}"
# #    cidr_blocks                   = "${var.cidr_blocks}"
# #    allocated_storage             = "${var.allocated_storage}"
# #    storage_type                  = "${var.storage_type}"
# #    engine                        = "${var.engine}"
# #    engine_version                = "${var.engine_version}"
# #    instance_class                = "${var.instance_class}"
# #    name                          = "${var.name}"
# #    username                      = "${var.username}"
# #    password                      = "${var.password}"
# #    parameter_group_name          = "${var.parameter_group_name}"
# #    allow_major_version_upgrade   = "${var.allow_major_version_upgrade}"
# #    auto_minor_version_upgrade    = "${var.auto_minor_version_upgrade}"
# #    backup_retention_period       = "${var.backup_retention_period}"
# #    maintenance_window            = "${var.backup_window}"
# #    multi_az                      = "${var.multi_az}"
# #    skip_final_snapshot           = "${var.skip_final_snapshot}"
# #    subnet_group_tag              = "${var.subnet_group_tag}"
# #    backup_window                 = "${var.backup_window}"
# #    from_port                     = "${var.from_port}"

# #   }
#------------------------------LoadBalancer Module-------------------------------#
 module "aws-alb" {

  source                  = "../../../../terraform-modules/loadbalancer"
  vpc_id                 = "${module.aws-vpc.vpc_id}"
  subnet_id1             = "${element(module.aws-subnet.subnet_id, 0)}" 
  subnet_id2             = "${element(module.aws-subnet.subnet_id, 1)}"
  lb_name                = "${var.lb_name}"
  load_balancer_type     = "${var.load_balancer_type}"
  ip_address_type        = "${var.ip_address_type}"
  alb_tag                = "${var.alb_tag}"

}
 

# # #--------------------------SNS Module---------------------------------#
module "aws-sns" {
  source                                = "../../../../terraform-modules/sns"
  security_name_display                 = "${var.security_name_display}"
  support_name_display                  = "${var.support_name_display}"
  support_email_addresses               = "${var.support_email_addresses}"
  security_email_addresses              = "${var.security_email_addresses}"
 
 }


 #-------------Cloudwatch  Values---------------------------#

  module "aws-cw" {
  source                                = "../../../../terraform-modules/cloudwatch"
  log_group_name                        = "${var.log_group_name}"
  retention_day                         = "${var.retention_day}"
  log_group_tag                         = "${var.log_group_tag}"
  alarm_name                            = "${var.alarm_name}"
  comparison_operator                   = "${var.comparison_operator}"
  evaluation_periods                    = "${var.evaluation_periods}"
  metric_name                           = "${var.metric_name}"
  namespace                             = "${var.namespace}"
  period                                = "${var.period}"
  statistic                             = "${var.statistic}"
  threshold                             = "${var.threshold}"
  alarm_description                     = "${var.alarm_description}"
  insufficient_data_actions             = "${var.insufficient_data_actions}"

 }

#--------------------------Cloudtrail Module---------------------------------#
module "aws-ct" {
  source                                = "../../../../terraform-modules/cloudtrail"
  ct_name                               = "${var.ct_name}"
  #s3_bucket_region                      = "${var.s3_bucket_region}"
  create_s3_bucket                      = "${var.create_s3_bucket}"
  s3_bucket_name                        = "${var.ct_name}"
  enable_s3_bucket_expiration           = "${var.enable_s3_bucket_expiration}"
  s3_bucket_days_to_expiration          = "${var.s3_bucket_days_to_expiration}"
  enable_s3_bucket_transition           = "${var.enable_s3_bucket_transition}"
  s3_bucket_days_to_transition          = "${var.s3_bucket_days_to_transition}"
  s3_bucket_transition_storage_class    = "${var.s3_bucket_transition_storage_class}"
  enable_logging                        = "${var.enable_logging}"
  include_global_service_events         = "${var.include_global_service_events}"
  is_multi_region_trail                 = "${var.is_multi_region_trail}"
  enable_log_file_validation            = "${var.enable_log_file_validation}"
  is_organization_trail                 = "${var.is_organization_trail}"
  s3_key_prefix                         = "${var.s3_key_prefix}"
}


#----------------------------------Config Rules & Record-------------------#

module "aws-configrule" {
  source                             = "../../../../terraform-modules/configrule"
  config_rule                        = "${var.config_rule}"
  config_record                      = "${var.config_record}"
  config_role                        = "${var.config_role}"
  config_policy                      = "${var.config_policy}"
 }

 #---------------------------------Lambda Function-------------------#

module "aws-lambda" {
  source                             = "../../../../terraform-modules/lambdafunction"
  lambda_fun_name                    = "${var.lambda_fun_name}"
  iam_lambda_role                    = "${var.iam_lambda_role}"
  handler                            = "${var.handler}"
  run_time                           = "${var.run_time}"
 }
#-------------------------GaurdDuty Module----------------#
module "aws-gd" {
   source             = "../../../../terraform-modules/gaurd-duty"
   aws_account_id     = "${var.aws_account_id}"
   users              = "${var.users}"
   #aws_region         = "${var.aws_region}"
     
}
