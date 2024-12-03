pipeline {
    agent {
        label 'app-agent'
    }

    tools {
        maven 'maven-jenkins'
    }
    
    triggers {
        githubPush()
    }

    parameters {
        choice choices: ['Maven', 'Docker'], description: 'Build step to run', name: 'buildstep'
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

        stage('Dockerizing') {
            when {
                expression { params.buildstep == 'Docker' }
            }
            steps {
                sh 'sudo usermod -aG docker jenkins'
                sh 'newgrp docker'
                sh 'docker build -t petclinic:1.0 .'
                sh 'docker images'
            }
        }

        stage('Deploy') {
            when {
                expression { params.buildstep == 'Docker' }
            }
            steps {
                sh 'docker run -d --name petclinic -p 8080:8080 petclinic:${env.BUILD_NUMBER}.0'
            }
        }
    }
}