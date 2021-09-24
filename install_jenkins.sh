

#!/bin/bash
echo "Terraform script run" > /var/log/terra.log
sudo yum -y update

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "Install Maven"
sudo yum install -y maven 

echo "Install git"
sudo yum install -y git

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
#sudo usermod -a -G docker jenkins
#sudo service docker start
sudo chkconfig docker on

echo "Intall Jenkins Dependencies required for Amazon Linux"
sudo amazon-linux-extras install epel -y

echo "Install Jenkins"
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install jenkins -y
#sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on
sudo service docker start
sudo service jenkins start

