# Git Test
# Data Block

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

# Resource Block

resource "aws_instance" "jenkins-instance" {
  ami             = "${data.aws_ami.amazon-linux-2.id}"
  instance_type   = "t2.micro"
  key_name        = "sh_p2_keypair"
  security_groups = [aws_security_group.sg_allow_ssh_jenkins.name]
  user_data = "${file("install_jenkins.sh")}"

  associate_public_ip_address = true
  tags = {
    Name = "Jenkins-Instance"
  }
}

# Security Group

resource "aws_security_group" "sg_allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  tags = {
    "Terraform" = "true"
  }

}

output "jenkins_ip_address" {
  value = "${aws_instance.jenkins-instance.public_dns}"
}
