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
                    sh '''
                    if [ ! -d "terraform-aws-projects" ]; then
                        git clone https://github.com/shashidas95/terraform-aws-projects.git .
                    else
                        git pull origin main
                    fi

                    # Change ownership and permissions if required
                    sudo chown -R $(whoami):$(id -gn) .
                    chmod -R 755 .
                    '''
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
                dir('terraform') {  // Use relative path to 'terraform' directory
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {  // Use relative path to 'terraform' directory
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
