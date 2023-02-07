# Create ec2
resource "aws_instance" "instance" {
  count                       = var.total_instance
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name

  subnet_id                   = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    "Name" : "${var.prefix}-ec2"
  }
}