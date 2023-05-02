resource "aws_instance" "ia-bastion" {
    ami = "ami-04cebc8d6c4f297a3"
    instance_type =  "t2.micro"
    subnet_id = "${aws_subnet.ia-public-subnet-2a.id}"
    vpc_security_group_ids = [aws_security_group.ia-bastion-sg.id]
    key_name = "IA_KEY"

    tags = {
        Name = "ia-bastion"
    }
}

resource "aws_instance" "ia-main-server" {
    ami = "ami-04cebc8d6c4f297a3"
    instance_type = "t3.micro"
    subnet_id = "${aws_subnet.ia-private-subnet-2a.id}"
    vpc_security_group_ids = [aws_security_group.ia-main-server-sg.id]
    key_name = "IA_KEY"

    tags = {
        Name = "ia-main-server"
    }
}   

resource "aws_eip" "ia-bastion-eip" {
    instance = aws_instance.ia-bastion.id
    vpc = true
    
    tags = {
        Name = "bastion-eip"
    }
}

resource "aws_eip_association" "ia-bastion-eip-association" {
    instance_id   = aws_instance.ia-bastion.id
    allocation_id = aws_eip.ia-bastion-eip.id
}

resource "aws_security_group" "ia-bastion-sg" {
    vpc_id = "${aws_vpc.ia-vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform-sg"
    }
}

resource "aws_security_group" "ia-main-server-sg" {
    vpc_id = "${aws_vpc.ia-vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.ia-bastion-sg.id]
    }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ia-main-server-sg"
    }

}