pipeline {
  agent any

  environment {
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    INVENTORY = 'ansible/inventory.ini'
    PLAYBOOK  = 'ansible/deploy.yml'
    ARTIFACT_VERSION = readFile('version').trim()
  }

  stages {
    stage('Deploy to stage (PR only)') {
      when {
        anyOf {
          changeRequest();
          branch 'master';
        }
      }
      steps {
          sh '''
            make deploy-stage
          '''
      }
    }

    stage('Create Docker image') {
      when { branch 'master' }
      steps {
          sh "docker build -t cicd-app:${ARTIFACT_VERSION} ."
      }
    }

    stage('Push Docker image to Docker Hub') {
      when { branch 'master' }
      steps {
        script {
          sh "docker tag cicd-app:${ARTIFACT_VERSION} viyd/cicd-app:${ARTIFACT_VERSION}"
    
          withCredentials([usernamePassword(
              credentialsId: 'DOCKERHUB',
              usernameVariable: 'USERNAME',
              passwordVariable: 'PASSWORD'
          )]) {
            sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
            sh "docker push viyd/cicd-app:${ARTIFACT_VERSION}"
          }
        }
      }
    }

    stage('Deploy to production') {
      when { branch 'master' }
      steps {
        withCredentials([file(credentialsId: 'jenkins-kubeconfig', variable: 'KCFG')]) {
          sh "kubectl --kubeconfig=$KCFG rollout restart deployment cicd-app"
        }
      }
    }
  }

  post {
    success {
      echo "Deployment finished: SUCCESS"
    }
    failure {
      echo "Deployment finished: FAILURE"
    }
  }
}