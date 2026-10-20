data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-otuokx4e-vpc"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnets" "subnets_public" {
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_security_group" "sg_ssh" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-otuokx4e-sg-ssh"]
  }
}

data "aws_security_group" "sg_http" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-otuokx4e-sg-http"]
  }
}

data "aws_security_group" "sg_lb_http" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-otuokx4e-sg-lb"]
  }
}

variable "template_blue" {
  type        = string
  description = "template name"
  default     = "cmtr-otuokx4e-blue-template"
}

variable "template_green" {
  type        = string
  description = "template name"
  default     = "cmtr-otuokx4e-green-template"
}
variable "asg_blue" {
  type        = string
  description = "autoscaling group name"
  default     = "cmtr-otuokx4e-blue-asg"
}
variable "asg_green" {
  type        = string
  description = "autoscaling group name"
  default     = "cmtr-otuokx4e-green-asg"
}
variable "loadbalancer" {
  type        = string
  description = "loadbalancer name"
  default     = "cmtr-otuokx4e-lb"
}

variable "iam_profile" {
  type        = string
  description = "loadbalancer name"
  default     = "cmtr-otuokx4e-instance_profile"
}

variable "tg_green" {
  type        = string
  description = "target group"
  default     = "cmtr-otuokx4e-green-tg"
}

variable "tg_blue" {
  type        = string
  description = "target group"
  default     = "cmtr-otuokx4e-blue-tg"
}

variable "blue_weight" {
  type        = number
  description = "blue weight"
  default     = 100
}

variable "green_weight" {
  type        = number
  description = "green weight"
  default     = 0
}