resource "aws_vpc" "cheguei_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "${var.prefix}-vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "cheguei_subnets" {
  count = 2   
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.cheguei_vpc.id
  cidr_block = "10.10.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
      Name = "${var.prefix}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "cheguei-igw" {
  vpc_id = aws_vpc.cheguei_vpc.id
  tags = {
      Name = "${var.prefix}-igw"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "containers_cheguei_internet_access" {
  route_table_id         = aws_vpc.cheguei_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cheguei-igw.id
}

resource "aws_route_table" "cheguei-rtb" {
  vpc_id = aws_vpc.cheguei_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.cheguei-igw.id
  }
  tags = {
      Name = "${var.prefix}-rtb"
  }
}

resource "aws_route_table_association" "cheguei-rtb-association" {
  count = 2
  route_table_id = aws_route_table.cheguei-rtb.id
  subnet_id = aws_subnet.cheguei_subnets.*.id[count.index]
}
