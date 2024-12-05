pipeline {
    agent {
        label 'app-agent'
    }

    tools {
        maven 'maven-jenkins'
    }
    /*
    triggers {
        githubPush()
    }
    */
    parameters {
        choice choices: ['Maven', 'Docker'], description: 'Build step to run', name: 'buildstep'
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') //Uses the credentials as value of the variable
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') //Uses the credentials as value of the variable
        AWS_DEFAULT_REGION = "us-east-1" //Allows to define the default AWS region if in the TF config is not declared
    }

    stages {
        stage('Checkout SCM') {
            when {
                expression { params.buildstep == 'Maven' || params.buildstep == 'Docker' }
            }

            steps {
                git branch: 'main', url: 'https://github.com/yahasop/spring-petclinic.git'
            }
        }
        
        stage('Package') {
            when {
                expression { params.buildstep == 'Maven' }
            }
            steps {
                //sh 'mvn package'
                sh 'mvn package pmd:pmd checkstyle:checkstyle'
            }
        }
        
        stage('Record') {
            when {
                expression { params.buildstep == 'Maven' }
            }
            steps {
                recordIssues sourceCodeRetention: 'LAST_BUILD', tools: [pmdParser(), checkStyle()]
            }
        }
        
        /*
        stage('Archiving artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*jar', followSymlinks: false
            }
        }
        */

        /*
        stage('Get ECRConfig') {
            when {
                expression { params.buildstep == 'Docker' }
            }
            steps {
                sh '''
                    echo $ECR_URL
                    
                '''
            }
        }
        */

        stage('Dockerizing') {
            when {
                expression { params.buildstep == 'Docker' }
            }
            steps {
                sh 'sudo usermod -aG docker jenkins'
                sh 'newgrp docker'
                sh '''
                    ECR_URL="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryUri | cut -d \'/\' -f 1)"
                    ECR_NAME="$(aws ecr describe-repositories | jq -r .repositories[0].repositoryName)"
                    sudo docker rmi $ECR_NAME:latest 2> /dev/null
                    sudo docker rmi $ECR_URL/$ECR_NAME:latest 2> /dev/null
                    sudo aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                    sudo docker build -t $ECR_NAME .
                    sudo docker images
                    sudo docker tag $ECR_NAME:latest $ECR_URL/$ECR_NAME:latest
                    sudo docker push $ECR_URL/$ECR_NAME:latest
                '''
            }
        }

        stage('Deploy') {
            when {
                expression { params.buildstep == 'Docker' }
            }
            steps {
                sh 'sudo docker run -d --name petclinic -p 8080:8080 $ECR_URL/$ECR_NAME:latest'
            }
        }
    }
}