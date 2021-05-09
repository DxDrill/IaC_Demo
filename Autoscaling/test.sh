#!/bin/bash
sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl status docker
sudo apt install git -y
sudo git clone https://github.com/Olympus-Team/OKRs-enterprise-api
sudo git clone https://github.com/Olympus-Team/OKRs-enterprise-frontend
cd OKRs-enterprise-api
sudo touch .env && cp .env.example


# sudo docker pull ductn4/green-rain
# sudo docker run -d -p 80:3000 ductn4/green-rain