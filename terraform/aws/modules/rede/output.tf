output "vpc_id" {
    value = "${aws_vpc.vpc10.id}"
}

output "subnet_az1a_id" {
    value = "${aws_subnet.sn_vpc10_pub1a.id}"
}

output "subnet_az1b_id" {
    value = "${aws_subnet.sn_vpc10_pub1b.id}"
}