pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Repository') {
            steps {
                script {
                    // No need to clone again, Jenkins already did it
                    sh 'ls -lah'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {  // Use relative path to 'terraform' directory
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
