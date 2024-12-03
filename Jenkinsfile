pipeline {
    agent {
        label 'agent2'
    }

    tools {
        maven 'maven-jenkins'
    }
    
    triggers {
        githubPush()
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/yahasop/spring-petclinic.git'
            }
        }
        
        stage('Package') {
            steps {
                //sh 'mvn package'
                sh 'mvn package pmd:pmd checkstyle:checkstyle'
            }
        }
        
        stage('Record') {
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
            steps {
                sh 'docker build -t petclinic:1.0 .'
                sh 'docker images'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d --name petclinic -p 8080:8080 petclinic:${env.BUILD_NUMBER}.0'
            }
        }
    }
}