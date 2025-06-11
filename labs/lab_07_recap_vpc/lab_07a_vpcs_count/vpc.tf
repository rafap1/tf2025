
resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${local.name_suffix}"
  }
}

## ================ Internet Gateway ================
# note single internet GW at VPC level (unlike NAT GW - one per AZ )

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags   = { "Name" = "igw-${local.name_suffix}" }
}


## ================ Subnets =============================
## Subnets - public start at "1", private at "11",  db at "31" - leave space for bigger private subnets
resource "aws_subnet" "public_subnet" {
  count             = var.az_count
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = cidrsubnet(var.vpc_cidr, local.subnet_prefix, 1 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = { 
    "tier" = "public", 
    "Name" = "public-${local.name_suffix}-${count.index}" 
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = cidrsubnet(var.vpc_cidr, local.subnet_prefix, 11 + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags                    = { 
    "tier" = "private", 
    "Name" = "private-${local.name_suffix}-${count.index}" 
    }
}

resource "aws_subnet" "db_subnet" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = cidrsubnet(var.vpc_cidr, local.subnet_prefix, 31 + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags                    = { "tier" = "db", "Name" = "db-${local.name_suffix}-${count.index}" }

}


## ================ NAT Gateway ================
## NAT GWs and their corresponding public IPs created only if var.create_nat_gw = true
resource "aws_eip" "nat_ip" {
  count      = var.create_nat_gw ? var.az_count : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags       = { "Name" = "eip-${count.index}" }
}

resource "aws_nat_gateway" "natgw" {
  count         = var.create_nat_gw ? var.az_count : 0
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags          = { "Name" = "natgw-${local.name_suffix}-${count.index}" }

}
## ================ Route Tables ===============
## Note that there are different ways to create aws_route_table
## This one contains routes inline
resource "aws_route_table" "public_subnet_rt" {
  count  = var.az_count
  vpc_id = aws_vpc.vpc1.id
  tags   = { "Name" = "public-${local.name_suffix}-${count.index}" }
}

resource "aws_route" "def_route_public" {
  count                  = var.az_count
  route_table_id         = aws_route_table.public_subnet_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pub" {
  count          = var.az_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_rt[count.index].id
}

resource "aws_route_table" "private_subnet_rt" {
  count  = var.az_count
  vpc_id = aws_vpc.vpc1.id
  tags   = { "Name" = "private-${local.name_suffix}-${count.index}" }
}

## These routes of 0.0.0.0/0 => NAT GW is only created if we have NAT GW (var.create_nat_gateway = true)
## If we do create them, we create one per AZ because we will have a NAT GW per AZ
resource "aws_route" "def_nat_gw" {
  count                  = var.create_nat_gw ? var.az_count : 0
  route_table_id         = aws_route_table.private_subnet_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[count.index].id
}

resource "aws_route_table_association" "priv" {
  count = var.az_count

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet_rt[count.index].id
}

resource "aws_route_table" "db_subnet_rt" {
  count = var.az_count
  vpc_id = aws_vpc.vpc1.id
  tags   = { "Name" = "database-${count.index}" }
}

resource "aws_route_table_association" "db" {
  count = var.az_count
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_subnet_rt[count.index].id
}
