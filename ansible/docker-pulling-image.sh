#sudo usermod -aG docker jenkins
#sudo newgrp docker
sudo aws configure set region us-east-1
ECR_URL="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryUri | cut -d '/' -f 1)"
ECR_NAME="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryName)"
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin $ECR_URL
sudo docker pull $ECR_URL/$ECR_NAME:latest
sudo docker run -d --name petclinic -p 8080:8080 $ECR_URL/$ECR_NAME:latest