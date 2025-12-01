pipeline {
  agent any

  environment {
    KUBECONFIG_PATH = '/var/lib/jenkins/.kube/config'
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    INVENTORY = 'ansible/inventory.ini'
    PLAYBOOK  = 'ansible/deploy.yml'
    ARTIFACT_VERSION = readFile('version').trim()
  }

  stages {
    stage('Deploy to stage (PR only)') {
      when { changeRequest() }
      steps {
          sh '''
            echo "Placeholder for Ansible deployment to stage environment..."
          '''
      }
    }

    stage('Create Docker image') {
      when { branch 'master' }
      steps {
          sh "docker build -t cicd-app:${ARTIFACT_VERSION} ."
      }
    }

    stage('Push Docker image') {
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
            sh "docker push viyd/cicd-app:app-${ARTIFACT_VERSION}"
          }
        }
      }
    }



    stage('Test connectivity to k8s cluster') {
      when { branch 'master' }
      steps {
        sh '''
          kubectl --kubeconfig="$KUBECONFIG_PATH" get nodes
        '''
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