output "vpc10_id" {
    value = "${aws_vpc.vpc10.id}"
}

output "sn_vpc10_pub1a" {
    value = "${aws_subnet.sn_vpc10_pub1a.id}"
}

output "sn_vpc10_pub1b" {
    value = "${aws_subnet.sn_vpc10_pub1b.id}"
}