module "rede" {
 source = "./modules/rede"
}

module "compute" {
 source = "./modules/compute"
 ec2_ami = "ami-0f409bae3775dc8e5"
 vpc_id = "${module.vpc10_id}"
 subnet_az1a_id = "${module.sn_vpc10_pub1a}"
 subnet_az1b_id = "${module.sn_vpc10_pub1b}"
}