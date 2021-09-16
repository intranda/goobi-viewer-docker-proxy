pipeline {

  agent any

  options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '15', daysToKeepStr: '90', numToKeepStr: '')
  }

  stages {
    stage('prepare') {
      steps {
        sh 'git clean -fdx'
      }
    }
    stage('build docker image') {
      agent any
      steps {
        script{
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage = docker.build("goobi-viewer-proxy:${BRANCH_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage_gei = docker.build("gei/goobi-viewer-proxy:${BRANCH_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
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
            dockerimage_gei.push("${env.TAG_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage_gei.push("latest")
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
