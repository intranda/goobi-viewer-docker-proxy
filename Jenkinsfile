pipeline {

  agent none

  options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '15', daysToKeepStr: '90', numToKeepStr: '')
  }

  stages {
    stage('prepare') {
      agent any
      steps {
        sh 'git clean -fdx'
      }
    }
    stage('build docker image') {
      agent any
      steps {
        script{
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage = docker.build("goobi-viewer-docker-proxy:${BRANCH_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage_public = docker.build("intranda/goobi-viewer-docker-proxy:${BRANCH_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
          }
        }
      }
    }
    stage('basic tests'){
      agent any
      steps{
        script {
          dockerimage.inside {
            sh 'test -f /usr/local/apache2/conf/httpd.conf.template'
            sh 'envsubst -V'
          }
        }
      }
    }
    stage('publish docker devel image to internal repository'){
      agent any
      steps{
        script {
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage.push("${env.BRANCH_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage.push("${env.BRANCH_NAME}")
          }
        }
      }
    }
    stage('publish docker production image to internal repository'){
      agent any
      when { branch 'master' }
      steps{
        script {
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage.push("${env.TAG_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage.push("latest")
          }
        }
      }
    }
    stage('publish develop image to Docker Hub'){
      agent any
      when {
        branch 'develop'
      }
      steps{
        script{
          docker.withRegistry('','0b13af35-a2fb-41f7-8ec7-01eaddcbe99d'){
            dockerimage_public.push("${env.BRANCH_NAME}")
          }
        }
      }
    }
    stage('publish production image to Docker Hub'){
      agent any
      when {
        branch 'master'
      }
      steps{
        script{
          docker.withRegistry('','0b13af35-a2fb-41f7-8ec7-01eaddcbe99d'){
            dockerimage_public.push("latest")
          }
        }
      }
    }
    stage('publish develop image to GitHub container registry'){
      agent any
      when {
        branch 'develop'
      }
      steps{
        script{
          docker.withRegistry('https://ghcr.io','jenkins-github-container-registry'){
            dockerimage_public.push("${env.BRANCH_NAME}")
          }
        }
      }
    }
    stage('publish production image to GitHub container registry'){
      agent any
      when {
        branch 'master'
      }
      steps{
        script{
          docker.withRegistry('https://ghcr.io','jenkins-github-container-registry'){
            dockerimage_public.push("latest")
          }
        }
      }
    }
  }
  post {
    changed {
      emailext(
        subject: '${DEFAULT_SUBJECT}',
        body: '${DEFAULT_CONTENT}',
        recipientProviders: [requestor(),culprits()],
        attachLog: true
      )
    }
  }
}
/* vim: set ts=2 sw=2 tw=120 et :*/
