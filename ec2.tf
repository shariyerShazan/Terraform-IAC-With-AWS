#! key pair for login

resource "aws_key_pair" "my_key" {
  key_name = "tera-key-ec2"
  public_key = file("tera-key-ec2.pub")
}

#! vpc and security group

resource "aws_default_vpc" "my_vpc" {
  
}

resource "aws_security_group" "my_security_group" {
   name = "automate-security-group"
   description = "this will add a terraform generated security group"
   # interpolation
   vpc_id = aws_default_vpc.my_vpc.id 

   # inbound roules
    # SSH
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH access"
    }

    # HTTP
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP access"
    }

    # Node.js app
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Node.js app"
    }

    
    # outbound roules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "all access open outbound"  
    }

    tags = {
      Name = "Automate security group"
    }
}

#! ec2 instance 

resource "aws_instance" "my_ec2_instance" {
  key_name = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type = "t2.micro"
  ami = "ami-01a00762f46d584a1" # ubuntu
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
  tags = {
    Name = "MY first automate aws instance"
  }
}