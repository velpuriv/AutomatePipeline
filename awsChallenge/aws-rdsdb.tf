resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.database_subnet_group_name
  subnet_ids = module.vpc.database_subnets

  tags = {
    Name = var.database_subnet_group_name
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.name}-rds-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Adjust as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-rds-sg"
  }
}

data "aws_secretsmanager_secret" "db_secret" {
  name = "db_credentials"
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}



resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "mydatabase"
  #   username               = "admin"
  #   password               = "MySecurePass123"
  username               = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["username"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["password"]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = {
    Name        = "${var.name}-rds"
    Environment = var.environment
  }
}
