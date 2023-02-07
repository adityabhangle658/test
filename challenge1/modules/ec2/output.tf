output instance_ids {
    value = aws_instance.instance.*.id
}

output public_ip {
    value = aws_instance.instance.*.public_ip
}