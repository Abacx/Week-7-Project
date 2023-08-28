# Create a VPC
resource "aws_vpc""CRA-Week-7-VPC" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "CRA-Week7-VPC"

}
}

#Public subnets
resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.CRA-Week-7-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public subnet 1"
  }
}

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.CRA-Week-7-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Public subnet 2"
  }
}

#Private subnets
resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.CRA-Week-7-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Private subnet 1"
  }
}

resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.CRA-Week-7-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Private subnet 2"
  }
}

#Public route table

resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.CRA-Week-7-VPC.id

  tags = {
    Name = "Public route table"
  }
}

#Private route table

resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.CRA-Week-7-VPC.id

  tags = {
    Name = "Private route table"
  }
}

# Route table Association - Public

resource "aws_route_table_association""Prod-pub-route-table-association-1" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}


# Route table Association - Private

resource "aws_route_table_association""Prod-priv-route-table-association-1" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

# Route table Association - Private

resource "aws_route_table_association""Prod-priv-route-table-association-2" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

# Internet gateway
resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.CRA-Week-7-VPC.id

  tags = {
    Name = "Prod-igw"
  }
}

#AWS route - IGW to route table

resource "aws_route" "Prod-igw-association" {
route_table_id            = aws_route_table.Prod-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Prod-igw.id
}

#NAT gateway

resource "aws_nat_gateway" "Prod-Nat-gateway" {
  subnet_id     = aws_subnet.Prod-pub-sub1.id
  allocation_id = aws_eip.Prod-eip.id

  tags = {
    Name = "Prod-Nat-gateway"
  }
  
}
#AWS EIP
resource "aws_eip" "Prod-eip" {  
  vpc = true
}
#Nat gateway to Priv sub
resource "aws_route" "Prod-Nat-association" {
  route_table_id            = aws_route_table.Prod-priv-route-table.id
  destination_cidr_block    = "10.0.3.0/24"
nat_gateway_id = aws_nat_gateway.Prod-Nat-gateway.id

}
