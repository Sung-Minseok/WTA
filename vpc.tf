# vpc.tf

resource "aws_vpc" "WTA" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "WTA"
    }
}

resource "aws_subnet" "wta-public-ap-northeast-2a" {
    vpc_id = aws_vpc.WTA.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-2a"

    tags = {
      "Name" = "wta-public-ap-northeast-2a"
    }
}

resource "aws_subnet" "wta-public-ap-northeast-2c" {
    vpc_id = aws_vpc.WTA.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-northeast-2c"

    tags = {
      "Name" = "wta-public-ap-northeast-2c"
    }
}

resource "aws_subnet" "wta-private-ap-northeast-2a" {
    vpc_id = aws_vpc.WTA.id
    cidr_block = "10.0.101.0/24"
    availability_zone = "ap-northeast-2a"

    tags = {
      "Name" = "wta-private-ap-northeast-2a"
    }
}

resource "aws_subnet" "wta-private-ap-northeast-2c" {
    vpc_id = aws_vpc.WTA.id
    cidr_block = "10.0.102.0/24"
    availability_zone = "ap-northeast-2c"

    tags = {
      "Name" = "wta-private-ap-northeast-2c"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.WTA.id

    tags = {
      "Name" = "wta_vpc_IGW"
    }
}

resource "aws_route_table" "wta_public_rt" {
    vpc_id = aws_vpc.WTA.id

    tags = {
      "Name" = "wta_public_rt"
    }
}

resource "aws_route_table_association" "wta_public_rt_association_a" {
    subnet_id = aws_subnet.wta-public-ap-northeast-2a.id
    route_table_id = aws_route_table.wta_public_rt.id
}

resource "aws_route_table_association" "wta_public_rt_association_c" {
    subnet_id = aws_subnet.wta-public-ap-northeast-2c.id
    route_table_id = aws_route_table.wta_public_rt.id
}


resource "aws_eip" "wta_nat_ip" {
    vpc = true

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_nat_gateway" "wta_nat_gateway" {
    allocation_id = aws_eip.wta_nat_ip.id
    subnet_id = aws_subnet.wta-public-ap-northeast-2a.id

    tags = {
      "Name" = "NAT_gateway"
    }
}

resource "aws_route_table" "wta_private_rt" {
    vpc_id = aws_vpc.WTA.id

    tags = {
      "Name" = "wta_private_rt"
    }
}

resource "aws_route_table_association" "wta_private_rt_association_a" {
    subnet_id = aws_subnet.wta-private-ap-northeast-2a.id
    route_table_id = aws_route_table.wta_private_rt.id
}

resource "aws_route_table_association" "wta_private_rt_association_c" {
    subnet_id = aws_subnet.wta-private-ap-northeast-2c.id
    route_table_id = aws_route_table.wta_private_rt.id
}


resource "aws_route" "wta_private_rt_nat" {
    route_table_id = aws_route_table.wta_private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wta_nat_gateway.id


}