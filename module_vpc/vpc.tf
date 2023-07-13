# main.tf

variable "vpcs" {
  description = "List of VPC configurations"
  type        = list(object({
    name               = string
    cidr_block         = string
    subnet_cidr_blocks = list(string)
    availability_zones = list(string)
    enable_dns_hostnames = bool
  }))
}

resource "aws_vpc" "vpc" {
  count                = length(var.vpcs)
  cidr_block           = var.vpcs[count.index].cidr_block
  enable_dns_hostnames = var.vpcs[count.index].enable_dns_hostnames

  tags = {
    Name = var.vpcs[count.index].name
  }
}

resource "aws_subnet" "subnets" {
  count                = length(var.vpcs[count.index].subnet_cidr_blocks)
  vpc_id               = aws_vpc.vpc[count.index].id
  cidr_block           = var.vpcs[count.index].subnet_cidr_blocks[count.index]
  availability_zone    = var.vpcs[count.index].availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet ${count.index}"
  }
}

# resource "aws_internet_gateway" "gateway" {
#   count = length(var.vpcs)

#   vpc_id = aws_vpc.main[count.index].id

#   tags = {
#     Name = "InternetGateway"
#   }
# }

# resource "aws_route_table" "public" {
#   count = length(var.vpcs)

#   vpc_id = aws_vpc.main[count.index].id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gateway[count.index].id
#   }

#   tags = {
#     Name = "PublicRouteTable"
#   }
# }

# resource "aws_route_table_association" "public_association" {
#   count          = length(var.vpcs) * length(var.vpcs[count.index].subnet_cidr_blocks)
#   subnet_id      = aws_subnet.subnets[count.index].id
#   route_table_id = aws_route_table.public[count.index].id
# }
