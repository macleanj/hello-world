@Library("cicd@develop") _cicd
@Library("custom@develop") _custom

// Global settings. Can be overwritten locally if needed.
def (cicd, log) = cicdByTag()
this.cicd = cicd
this.log = log

pipeline {
  options {
    buildDiscarder(
      logRotator(
        artifactDaysToKeepStr : cicd.job.options.logRotator.artifactDaysToKeepStr,
        artifactNumToKeepStr  : cicd.job.options.logRotator.artifactNumToKeepStr,
        daysToKeepStr         : cicd.job.options.logRotator.daysToKeepStr,
        numToKeepStr          : cicd.job.options.logRotator.numToKeepStr
      )
    )
    disableConcurrentBuilds()
    disableResume()
    // skipDefaultCheckout()
    timeout(cicd.job.options.timeout)
    timestamps()
  }

  agent {
    kubernetes(cicd.job.environment.agent)
  }

  stages {
    stage ('Build Image') {
      when {
        expression { cicd.job.enabled == 1 }
        expression { cicd.job.buildEnabled == 1 }
      }
      steps {
        _build(this)
      }
    }

    stage ('Publish Image') {
      when {
        expression { cicd.job.enabled == 1 }
        expression { cicd.job.buildEnabled == 1 }
      }
      steps {
        withCredentials([usernamePassword(credentialsId: cicd.job.environment.registryCredentials, usernameVariable: 'user', passwordVariable: 'pass')]) {
          _publish(this, user, pass)
        }
      }
    }

  // stages
  }

// pipeline
}

