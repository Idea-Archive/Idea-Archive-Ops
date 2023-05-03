resource "aws_db_subnet_group" "ia-subnet-group" {
    name = "ia-subnet-group"
    subnet_ids = [
        aws_subnet.ia-private-subnet-2a.id,
        aws_subnet.ia-private-subnet-2b.id
    ]
}

resource "aws_security_group" "ia-rds-sg" {
    name = "ia-rds-sg"
    vpc_id = aws_vpc.ia-vpc.id

    ingress{
        description = "Allow MySQL traffic from only the ia-main-server instance."
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.ia-main-server-sg.id]
    }

    tags = {
        Name = "ia-rds-sg"
    }
}

resource "aws_db_instance" "ia-backend-database" {
    allocated_storage = 20
    max_allocated_storage = 50
    availability_zone = "ap-northeast-2a"
    db_subnet_group_name = aws_db_subnet_group.ia-subnet-group.id
    vpc_security_group_ids = [aws_security_group.ia-rds-sg.id]
    engine = "mysql"
    engine_version = "8.0.32"
    instance_class = "db.t3.micro"
    skip_final_snapshot = true
    identifier = "ia-mysql"
    username = "admin"
    password = var.db_password
    name = "iaDatabase"
    port = "3306"
}