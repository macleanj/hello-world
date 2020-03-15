/*
 * This is a test pipeline that can be (copied and) used to a Jenkins pipeline project as PoC.
 **/

// This library with the branch to test
tgr = library identifier: 'tested-git-repo@develop', retriever: modernSCM (
  [ $class: 'GitSCMSource',
    remote: 'https://github.com/macleanj/jenkins-library.git',
    credentialsId: 'futurice-maclean-github'
  ]
)

jsl = library identifier: 'k8sagent@develop', retriever: modernSCM (
  [ $class: 'GitSCMSource',
    remote: 'https://github.com/macleanj/jenkins-k8sagent-lib.git',
    credentialsId: 'futurice-maclean-github'
  ]
)

// Environment instantiation
def cicd = [build: [:], git: [:], jenkins: [:], config: [:], env: [:]]
cicd.build.debug = 0
cicd.build.throttle = 1
cicd.build.agent = ""

// The following variable are available start of the pipeline (before node {} and pipeline {})
// current dir = /
if (cicd.build.debug == 1) { println "DEBUG: Bare Environment\n" + "env".execute().text }
/*
JENKINS_SLAVE_AGENT_PORT=50000
LANG=C.UTF-8
HOSTNAME=jenkins-master
JENKINS_UC=https://updates.jenkins.io
JAVA_OPTS=-Xmx2048m
JAVA_HOME=/usr/local/openjdk-8
JAVA_VERSION=8u242
PWD=/
HOME=/var/jenkins_home
COPY_REFERENCE_FILE_LOG=/var/jenkins_home/copy_reference_file.log
JENKINS_HOME=/var/jenkins_home
REF=/usr/share/jenkins/ref
JAVA_BASE_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_
JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
SHLVL=0
JAVA_URL_VERSION=8u242b08
JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
JENKINS_VERSION=2.219
*/

// Enables to collect all GIT and Jenkins variables
// current dir = /
node ('master') {
  stage('Set environment') {
    sh 'echo "master - Stage: Set environment"'
    if (cicd.build.debug == 1) { echo "DEBUG: CICD Environment\n" + sh(script: "printenv | sort", returnStdout: true) }
    // cicd.build.agent = (BUILD_NUMBER.toInteger() <= cicd.build.throttle) ? k8sagent(name: 'base+s_micro', label: 'jnlp', cloud: 'kubernetes') : [cloud:'disabled', label:'disabled', timeout: 1]
    cicd.build.agent = (BUILD_NUMBER.toInteger() <= cicd.build.throttle) ? k8sagent(name: 'base+s_micro', label: 'jnlp', cloud: 'kubernetes') : []
    println "CICD Agent: " + cicd.build.agent
  }
}

pipeline {
  options {
    // skipDefaultCheckout()
    disableConcurrentBuilds()
    buildDiscarder(
      logRotator(
        artifactDaysToKeepStr: '', 
        artifactNumToKeepStr: '5', 
        daysToKeepStr: '', 
        numToKeepStr: '5'
      )
    )
    timestamps()
  }

  // ****************************************************
  // ********************** Agents **********************
  // Parametized agent - NOT WORKING!!
  // agent { kubernetes(cicd.build.agent) }

  // None. Set per stage?
  // agent none

  // Any
  agent any

  // Fixed lable
  // agent {
  //   label 'docker'
  // }

  // Kubernetes fixed podTemplate
  // agent {
  //   kubernetes {
  //     label 'jnlp'
  //     cloud 'kubernetes'
  //     // defaultContainer 'jenkins-builder'
  //     // instanceCap 1
  //     // yamlFile "build/k8/build-pod-img.yml"
  //     yamlFile "build/k8/build-pod-img.yml"
  //   }
  // }

  // Kubernetes merged podTemplate via library
  // agent {
  //   // Mind the _ (underscore) in the definition. Containers themselves will have the _ exchanged for a -
  //   kubernetes(k8sagent(name: 'base+s_micro', label: 'jnlp', cloud: 'kubernetes'))
  // }
  // // ********************** Agents **********************
  // ****************************************************
  stages {
    stage ('Set environment') {
      // agent { kubernetes(k8sagent(name: 'base+s_micro', label: 'jnlp', cloud: 'kubernetes')) }
      when {
        beforeAgent true
        expression { 1 == 1 }
      }
      steps {
        sh "echo HERE > /tmp/tessie"
      }
    }
    stage ('Set environment 2') {
      // agent { kubernetes(k8sagent(name: 'base+s_micro', label: 'jnlp', cloud: 'kubernetes')) }
      when {
        beforeAgent true
        expression { 1 == 1 }
      }
      steps {
        sh "cat /tmp/tessie"
      }
    }
  }
}
