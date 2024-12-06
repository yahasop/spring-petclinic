sudo usermod -aG docker jenkins
sudo newgrp docker
ECR_URL="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryUri | cut -d '/' -f 1)"
ECR_NAME="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryName)"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
docker build -t $ECR_NAME .
docker tag $ECR_NAME:latest $ECR_URL/$ECR_NAME:latest
docker images
docker push $ECR_URL/$ECR_NAME:latest