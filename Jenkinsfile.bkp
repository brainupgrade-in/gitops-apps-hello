pipeline {
  agent {
    kubernetes {
      label 'jenkins-slave'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    env:
    - name: DOCKER_HOST
      value: tcp://docker:2375
    image: docker
    command:
    - cat
    tty: true
  - name: tools
    image: argoproj/argo-cd-ci-builder
    command:
    - cat
    tty: true
"""
    }
  }
  stages {

    stage('Build') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh "docker login -u ${USERNAME} -p ${PASSWORD} "
            sh "docker build --build-arg='BUILD_ID=${env.BUILD_ID}' --build-arg='GIT_COMMIT_ID=${env.GIT_COMMIT}' -t brainupgrade/hello:${env.GIT_COMMIT} ."
            sh "docker push brainupgrade/hello:${env.GIT_COMMIT}"
          }
        }
      }
    }

    stage('Deploy E2E') {
      when {
          branch 'main'
      }      
      environment {
        GIT_CREDS = credentials('bu-github-credentials')
      }
      steps {
        input message:'Approve deployment to E2E?'
        container('tools') {
          sh "git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/brainupgrade-in/gitops-k8s-apps.git"
          sh "git config --global user.email 'ci@ci.com'"

          dir("gitops-k8s-apps") {
            sh "cd ./hello/e2e && kustomize edit set image brainupgrade/hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }
    stage('Deploy to UAT') {
      when {
          branch 'main'
      }      
      steps {
        input message:'Approve deployment to UAT?'
        container('tools') {
          dir("gitops-k8s-apps") {
            sh "cd ./hello/uat && kustomize edit set image brainupgrade/hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }

    stage('Deploy to Prod') {
      when {
          branch 'main'
      }      
      steps {
        input message:'Approve deployment to PROD?'
        container('tools') {
          dir("gitops-k8s-apps") {
            sh "cd ./hello/prod && kustomize edit set image brainupgrade/hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }
    stage('final') {
      when {
          branch 'main'
      }      
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh "docker login -u ${USERNAME} -p ${PASSWORD} "
            sh "docker tag brainupgrade/hello:${env.GIT_COMMIT} brainupgrade/hello:latest"
            sh "docker push brainupgrade/hello:latest "
          }
        }
      }
    }  
  }
}
