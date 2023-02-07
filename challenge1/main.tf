# Create all networking components
module "network" {
    source = "./modules/network"

    region = "ap-south-1"
    prefix = "myproj"
    vpc_cidr = "10.0.0.0/16"
    mgt_subnet_cidr = ["10.0.0.0/26"]
    web_subnet_cidr = ["10.0.1.0/26", "10.0.2.0/26"]
    app_subnet_cidr = ["10.0.3.0/26", "10.0.4.0/26"]
    db_subnet_cidr = ["10.0.5.0/26", "10.0.6.0/26"]
}

# Create web instances in multi az
module "web-instances" {
    source                      = "./modules/ec2"

    total_instance              = 2
    region                      = "ap-south-1"
    prefix                      = "myproj-web"
    subnet_ids                  = module.network.web-subnet-id
    vpc_security_group_ids      = [module.network.web-sg]
    associate_public_ip_address = true
    ami                         = "ami-04169621312341331"
    instance_type               = "t3.medium"
    key_name                    = "myproj-web"

    vpc_id                      = module.network.vpc_id
}

# Create app instances in multi az
module "app-instances" {
    source                      = "./modules/ec2"

    total_instance              = 2
    region                      = "ap-south-1"
    prefix                      = "myproj-app"
    subnet_ids                  = module.network.app-subnet-id
    vpc_security_group_ids      = [module.network.app-sg]
    associate_public_ip_address = true
    ami                         = "ami-04169621312341331"
    instance_type               = "t3.medium"
    key_name                    = "myproj-app"

    vpc_id                      = module.network.vpc_id
}

# Create rds in multi az
module "rds" {
  depends_on = [module.network]
  source = "./modules/db"

  identifier             = "myproj-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = "adi658"
  vpc_security_group_ids = [module.network.db-sg]
  publicly_accessible    = false
  skip_final_snapshot    = true

  subnet_ids             = module.network.db-subnet-id

  parameter_group_family = "postgres14"
}
