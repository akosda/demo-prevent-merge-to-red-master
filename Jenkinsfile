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
  sh '''
    COMMIT_ID=`git log -1 --format="id=%H"`
    COMMIT_MSG=`git log -1 --format="msg=%s"`
    if [[ $COMMIT_MSG == *"fix-master-job"* ]]; then
      echo "Setting continuous-integration/master-is-red context on $COMMIT_ID to 'success'..."
      echo "Faking GitHub API call!"
    else
      echo "Commit message does not match fix pattern. Skipping GitHub API call."
    fi
  '''
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
