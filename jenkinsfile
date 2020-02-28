pipeline {
    agent any 
    stages {
        stage('git clone') {
            steps {
                git 'https://github.com/venkatasankarapu/terraform-git.git'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
    
}
