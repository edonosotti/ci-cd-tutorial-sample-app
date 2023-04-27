pipeline {
    agent any
    stages {
        stage('Get code from GitHub') {
            steps {
                git 'https://github.com/slezinskiy/ci-cd-tutorial-sample-app.git'
            }
        }
        stage('Run tests') {
            steps {
                sh 'ls -la'
            }
            post {
                success {
                    build job: 'your-build-job'
                }
            }
        }
        stage('Build Docker image') {
            steps {
                #sh 'docker build -t your-image-name .'
                echo "build docker"

            }
        }
        stage('Deploy to Kubernetes') {
            when {
                branch 'master'
            }
            steps {
                echo "deploy to prod"
            }
        }
    }
}
