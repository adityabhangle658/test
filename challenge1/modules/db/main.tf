# generate pwd for rds
resource "random_password" "master"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

# store pwd in secret manager
resource "aws_secretsmanager_secret" "password" {
  name = "myproj-db-password"
}

# store pwd in secret manager
resource "aws_secretsmanager_secret_version" "password" {
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

resource "aws_db_instance" "education" {
  identifier             = var.identifier
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  username               = var.username
  password               = random_password.master.result
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = var.vpc_security_group_ids
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "education" {
  name   = "myproj-db-param-group"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "myproj-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "myproj-db-subnet-group"
  }
}