#---networking/main.tf---

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = var.availability_zones
  result_count = var.max_subnets
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "week24-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "week24_internet_gateway" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "week24-igw"
  }
}

resource "aws_subnet" "week24_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "week24-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "week24_public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "week24-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.week24_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.week24_internet_gateway.id
}


resource "aws_route_table_association" "public_rt_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.week24_public_subnet[count.index].id
  route_table_id = aws_route_table.week24_public_rt.id
}