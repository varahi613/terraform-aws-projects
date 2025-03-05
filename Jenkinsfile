pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-credentials')  // Ensure 'aws-credentials' is defined in Jenkins
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        AWS_REGION = 'us-west-1'
        PATH = "/opt/homebrew/bin:$PATH"  // Ensure Terraform is in the PATH if it's installed here
    }

    stages {
        stage('Checkout Repository') {
            steps {
                script {
                    // Listing files in the workspace to verify if repository is properly checked out
                    sh 'ls -lah'
                }
            }
        }

        stage('Validate Terraform Installation') {
            steps {
                script {
                    // Check if Terraform is available
                    sh 'terraform --version'  // Ensure Terraform is installed and available
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {  // Use relative path to 'terraform' directory
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    // Create an execution plan and save it to 'tfplan'
                    sh 'terraform plan -out=tfplan -lock=false'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    // Apply the Terraform plan
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
