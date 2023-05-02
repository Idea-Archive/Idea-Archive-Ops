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
    name = var.security_group_name
    vpc_id = "${aws_vpc.ia-vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform-sg"
    }
}

variable "security_group_name" {
    description = "The name of the security group"
    type = string
    default = "terraform-example-instance"
}