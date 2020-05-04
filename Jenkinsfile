pipeline {
    agent any
    stages {
        stage('terrfaorm') {
            steps {
                echo "HELLO WELCOME TO TERRAFORM"
                sh "/usr/local/bin/terraform init"
                sh "/usr/local/bin/terraform apply -auto-approve"
             
            }
        }
        
        stage('validation in aws') {
            steps {
                sh "aws iam list-users"
                
            }
        }
        
        }
}
