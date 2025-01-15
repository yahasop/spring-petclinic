pipeline {
    agent {
        label 'agent2'
    }

    tools {
        maven 'maven-jenkins'
        git 'Default'
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

        stage('Package(Test/Build)') {
            when {
                expression { params.buildstep == 'Maven' }
            }
            steps {
                sh 'mvn package pmd:pmd checkstyle:checkstyle'
            }
        }
        
        stage('Record the static code analysis tests') {
            when {
                expression { params.buildstep == 'Maven' }
            }
            steps {
                recordIssues sourceCodeRetention: 'LAST_BUILD', tools: [pmdParser(), checkStyle()]
            }
        }

        stage('Build and Push Image') {
            when {
                expression { params.buildstep == 'Docker' }
            }
            steps {
                sh 'chmod u+x docker-pushing-image.sh'
                sh './docker-pushing-image.sh'
            }
        }
    }
}