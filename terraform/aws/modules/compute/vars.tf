variable "vpc_id" {}
variable "subnet_az1a_id" {}
variable "subnet_az1b_id" {}


variable "ec2_ami" {
   type    = string
   default = "ami-02e136e904f3da870"
#    validation {
#        condition = (
#            length(var.ec2_ami) > 4 &&
#            substr(var.ec2_ami, 0, 4) == "ami-"
#        )
#        error_message = "The valor da variável ec2_ami deve iniciar com \"ami-\"."
#    }
}