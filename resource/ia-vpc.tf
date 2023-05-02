data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "ia-vpc"{
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"

    tags = {
        Name = "ia-vpc"
    }
}

resource "aws_subnet" "ia-public-subnet-2a" {
    vpc_id = aws_vpc.ia-vpc.id
    cidr_block = "192.168.0.0/20"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        "Name" = "ia-public-subnet-2a"
    }
}

resource "aws_subnet" "ia-public-subnet-2b" {
    vpc_id = aws_vpc.ia-vpc.id
    cidr_block = "192.168.32.0/20"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = {
        "Name" = "ia-public-subnet-2b"
    }
}

resource "aws_subnet" "ia-private-subnet-2a" {
    vpc_id = aws_vpc.ia-vpc.id
    cidr_block = "192.168.16.0/20"
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        "Name" = "ia-private-subnet-2a"
    }
}

resource "aws_subnet" "ia-private-subnet-2b" {
    vpc_id = aws_vpc.ia-vpc.id
    cidr_block = "192.168.48.0/20"
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = {
        "Name" = "ia-private-subnet-2b"
    }
}

resource "aws_internet_gateway" "ia-igw" {
    vpc_id = aws_vpc.ia-vpc.id
    tags = {
        Name = "ia-igw"
    }
}

resource "aws_eip" "ia-nat-eip" {
    vpc = true

    lifecycle{
        create_before_destroy = true
    }

    tags = {
        Name = "nat-eip"
    }
}

resource "aws_nat_gateway" "ia-nat" {
    allocation_id = aws_eip.ia-nat-eip.id

    subnet_id = aws_subnet.ia-public-subnet-2a.id

    tags = {
        Name = "ia-public-nat"
    }
}

resource "aws_route_table" "ia-public-rtb" {
    vpc_id = aws_vpc.ia-vpc.id

    tags = {
        Name = "ia-public-rtb"
    }
}

resource "aws_route_table" "ia-private-rtb" {
    vpc_id = aws_vpc.ia-vpc.id

    tags = {
        Name = "ia-private-rtb"
    }
}

resource "aws_route_table_association" "ia-public-rt-association-1" {
    subnet_id = aws_subnet.ia-public-subnet-2a.id
    route_table_id = aws_route_table.ia-public-rtb.id
}

resource "aws_route_table_association" "ia-public-rt-association-2" {
    subnet_id = aws_subnet.ia-public-subnet-2b.id
    route_table_id = aws_route_table.ia-public-rtb.id
}

resource "aws_route_table_association" "ia-private-rt-association-1" {
    subnet_id = aws_subnet.ia-private-subnet-2a.id
    route_table_id = aws_route_table.ia-private-rtb.id
}


resource "aws_route_table_association" "ia-private-rt-association-2" {
    subnet_id = aws_subnet.ia-private-subnet-2b.id
    route_table_id = aws_route_table.ia-private-rtb.id
}

resource "aws_route" "private_rt_nat" {
    route_table_id = aws_route_table.ia-private-rtb.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ia-nat.id
}