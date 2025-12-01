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

    // stage('Push Docker image to Docker Hub') {
    //   when { branch 'master' }
    //   steps {
    //     script {
    //       sh "docker tag cicd-app:${ARTIFACT_VERSION} viyd/cicd-app:${ARTIFACT_VERSION}"
    
    //       withCredentials([usernamePassword(
    //           credentialsId: 'DOCKERHUB',
    //           usernameVariable: 'USERNAME',
    //           passwordVariable: 'PASSWORD'
    //       )]) {
    //         sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
    //         sh "docker push viyd/cicd-app:app-${ARTIFACT_VERSION}"
    //       }
    //     }
    //   }
    // }

    stage('Push Docker image to local registry') {
      when { branch 'master' }
      steps {
        script {
          sh "docker tag cicd-app:${ARTIFACT_VERSION} localhost:5000/cicd-app:${ARTIFACT_VERSION}"
          sh "docker push localhost:5000/cicd-app:${ARTIFACT_VERSION}"
        }
      }
    }

    stage('Deploy to production') {
      when { branch 'master' }
      steps {
        sh '''
          kubectl --kubeconfig="$KUBECONFIG_PATH" set image deployment/cicd-app cicd-app=localhost:5000/cicd-app:${ARTIFACT_VERSION} --record
          kubectl  --kubeconfig="$KUBECONFIG_PATH" rollout status deployment/cicd-app
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