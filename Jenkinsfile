pipeline {
  agent any

  environment {
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    INVENTORY = 'ansible/inventory.ini'
    PLAYBOOK  = 'ansible/deploy.yml'
    ARTIFACT_VERSION = readFile('version').trim()
  }

  stages {
    stage('Tests') {
      when { changeRequest() }
      steps {
        script {
          sh '''
            python3 -m venv venv
            . venv/bin/activate
            pip install -r requirements.txt
            python3 -m unittest discover tests || true
            deactivate
          '''
        }
      }
    }

    stage('SonarQube Analysis') {
      when { changeRequest() }
      steps {
        script {
          withSonarQubeEnv('mySonarQube') {
            sh '''
              sonar-scanner \
                -Dsonar.projectKey=cicd-app \
                -Dsonar.sources=. \
            '''
          }
        }
      }
    }

    stage('SonarQube Quality Gate') {
      when { changeRequest() }
      steps {
        timeout(time: 10, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

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

    // stage('Create Docker image') {
    //   when { branch 'master' }
    //   steps {
    //       sh "docker build -t cicd-app:${ARTIFACT_VERSION} ."
    //   }
    // }

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
            sh "make push-latest"
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