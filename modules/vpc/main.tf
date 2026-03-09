# Creates the primary VPC that hosts all EKS and networking resources
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = "${var.name}-vpc", Component = "vpc" })
}

# Attaches an Internet Gateway to enable outbound internet access for public subnets
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw", Component = "vpc" })
}

# Creates public subnets across availability zones for internet-facing resources
resource "aws_subnet" "public" {
  for_each = {
    for idx, az in var.azs : az => var.public_subnet_cidrs[idx]
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                                = "${var.name}-public-${each.key}"
    Tier                                = "public"
    Component                           = "vpc"
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/${var.name}" = "shared"
  })
}

# Creates private subnets across availability zones for internal workloads like EKS nodes
resource "aws_subnet" "private" {
  for_each = {
    for idx, az in var.azs : az => var.private_subnet_cidrs[idx]
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(var.tags, {
    Name                                     = "${var.name}-private-${each.key}"
    Tier                                     = "private"
    Component                                = "vpc"
    "kubernetes.io/role/internal-elb"        = "1"
    "kubernetes.io/cluster/${var.name}"      = "shared"
  })
}

# Defines a route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-rt-public" })
}

# Adds a default route to the Internet Gateway for public traffic
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associates the public route table with all public subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Allocates an Elastic IP for the NAT Gateway if enabled
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.name}-eip-nat" })
}

# Creates a NAT Gateway in a public subnet for outbound access from private subnets
resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = values(aws_subnet.public)[0].id
  tags          = merge(var.tags, { Name = "${var.name}-nat" })
  depends_on    = [aws_internet_gateway.this]
}

# Defines a route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-rt-private" })
}

# Adds a default route from private subnets to the NAT Gateway
resource "aws_route" "private_to_nat" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

# Associates the private route table with all private subnets
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Creates a baseline security group with unrestricted outbound access
resource "aws_security_group" "base" {
  name        = "${var.name}-base-sg"
  description = "Baseline security group for the VPC"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-base-sg" })
}