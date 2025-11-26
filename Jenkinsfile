pipeline {
  environment {
    KUBECONFIG_PATH = '$JENKINS_HOME/config'
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    INVENTORY = 'ansible/inventory.ini'
    PLAYBOOK  = 'ansible/deploy.yml'
  }

  options {
    skipDefaultCheckout()
  }

  triggers { }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Deploy to stage (PR only)') {
      when { changeRequest() }
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ansible_ssh_key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
          sh '''
            echo "Placeholder for Ansible deployment to stage environment..."
          '''
        }
      }
    }

    stage('Test connectivity to k8s cluster') {
      when { branch 'master' }
      steps {
        sh '''
          export KUBECONFIG="$KUBECONFIG_PATH"
          kubectl get nodes
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