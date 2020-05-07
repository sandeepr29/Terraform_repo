pipeline {
    agent any
    stages {
        stage('Deploy') {
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
    post {
       always {
          mail to: 'bcl@nclasters.org',
          subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
          body: "${env.BUILD_URL} has result ${currentBuild.result}"
    }
  }    
}
