resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.env_prefix}-vpc"
  }
}

resource "aws_route_table_association" "a-rtb-subnet"{
  subnet_id = module.myapp-subnet.subnet.id
  route_table_id = module.myapp-subnet.route_table.id
}


module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.vpc_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id
}

module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myapp-vpc.id
  env_prefix = var.env_prefix
  image_name = var.image_name
  my_ip = var.my_ip
  subnet_id = module.myapp-subnet.subnet.id
  instance_type = var.instance_type
  public_key_location = var.public_key_location
  avail_zone = var.avail_zone
}
