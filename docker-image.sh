sudo usermod -aG docker jenkins
sudo newgrp docker
ECR_URL="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryUri | cut -d '/' -f 1)"
ECR_NAME="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryName)"
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin $ECR_URL
sudo docker build -t $ECR_NAME .
sudo docker tag $ECR_NAME:latest $ECR_URL/$ECR_NAME:latest
sudo docker images
sudo docker push $ECR_URL/$ECR_NAME:latest