provider "aws" {
  region = var.aws_region
}


# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidr_public
  map_public_ip_on_launch = true
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create Security Group (Allow SSH, HTTP, and HTTPS)
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Use Existing Key Pair
data "aws_key_pair" "existing_key" {
  key_name = var.ssh_key_name
}

# Create EC2 Instance
# Create EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] # ✅ Corrected here
  key_name               = var.ssh_key_name               # Existing key pair

  tags = {
    Name = "CI/CD-EC2"
  }
}

