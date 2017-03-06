buildMarkedAsFailed = false

withPostActions(['updateBranchProtection']) {
  node {
    stage ('setup') {
      deleteDir()
      checkout scm
      processCommitMessage()
    }
    stage ('build') {
      echo 'Hello, World!'
    }
  }
}

def withPostActions(actions, body) {
    try {
        body.call()
    } catch (e) {
        buildMarkedAsFailed = true
        throw e
    } finally {
        for (action in actions) {
            echo "executing action $action"
            "${action}"()
        }
    }
}


def processCommitMessage() {
  echo 'Processing commit message'
  withCredentials([[$class: 'StringBinding', credentialsId: 'akosda-github-personal-token', variable: 'GITHUB_TOKEN']]) {
    sh '''
      COMMIT_ID=`git log -1 --format="id=%H"`
      COMMIT_MSG=`git log -1 --format="msg=%s"`
      scripts/set-context-status.sh $GITHUB_TOKEN "${COMMIT_ID}" "${COMMIT_MSG}"
    '''
  }
}

def updateBranchProtection() {
  node {
    checkout scm
    if(buildMarkedAsFailed) {
      addRequiredStatusCheck()
    } else {
      removeRequiredStatusCheck()
    }
  }
}

def addRequiredStatusCheck() {
  echo 'Adding master-is-red required status check on master branch'
  withCredentials([[$class: 'StringBinding', credentialsId: 'akosda-github-personal-token', variable: 'GITHUB_TOKEN']]) {
    sh 'scripts/add-status-check.sh $GITHUB_TOKEN'
  }
}

def removeRequiredStatusCheck() {
  echo 'Removing master-is-red required status check on master branch'
  withCredentials([[$class: 'StringBinding', credentialsId: 'akosda-github-personal-token', variable: 'GITHUB_TOKEN']]) {
    sh 'scripts/remove-status-check.sh $GITHUB_TOKEN'
  }
}
