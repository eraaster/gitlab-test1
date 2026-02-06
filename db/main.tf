################################
# DB Security Group
################################
resource "aws_security_group" "aurora_sg" {
  name        = "aurora-db-sg"
  description = "Allow MySQL access only from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EKS Node SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aurora-db-sg"
  }
}

################################
# DB Subnet Group
################################
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "aurora-db-subnet-group"
  }
}

################################
# Aurora MySQL Cluster
################################
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "cloudwave-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.05.2"

  database_name           = "cloudwave"
  master_username         = var.db_username
  master_password         = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]

  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"

  skip_final_snapshot     = true

  tags = {
    Name = "cloudwave-aurora"
  }
}

################################
# Aurora Cluster Instances
################################
resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 2
  identifier         = "cloudwave-aurora-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id

  instance_class     = "db.r6g.large"
  engine             = aws_rds_cluster.aurora_cluster.engine

  publicly_accessible = false

  tags = {
    Name = "cloudwave-aurora-instance-${count.index}"
  }
}
