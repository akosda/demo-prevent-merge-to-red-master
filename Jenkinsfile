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
      COMMIT_ID=`git log -1 --format="%H"`
      COMMIT_MSG=`git log -1 --format="%s"`
      scripts/set-context-status.sh $GITHUB_TOKEN "${COMMIT_ID}" "${COMMIT_MSG}"
    '''
  }
}

def updateBranchProtection() {
  if(onMasterBranch()) {
    node {
      checkout scm
      if(buildMarkedAsFailed) {
        addRequiredStatusCheck()
      } else {
        removeRequiredStatusCheck()
      }
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

enum BUILD_TYPE {
    MASTER, FEATURE_BRANCH, PULL_REQUEST, NOT_DEFINED
}

def currentBranch() {
    env.BRANCH_NAME
}

BUILD_TYPE buildType() {
    if (currentBranch() == 'master') BUILD_TYPE.MASTER
    else if (currentBranch() =~ /PROD.*|prod.*/) BUILD_TYPE.FEATURE_BRANCH
    else if (currentBranch() =~ /PR-.*/) BUILD_TYPE.PULL_REQUEST
    else BUILD_TYPE.NOT_DEFINED
}

def onMasterBranch() {
    buildType() == BUILD_TYPE.MASTER
}

def onPullRequest() {
    buildType() == BUILD_TYPE.PULL_REQUEST
}

def pullRequestId() {
    currentBranch().replace('PR-', '')
}

def repoNameInPullRequest() {
    def organization = env.CHANGE_URL.split("/")[3]
    def repo = env.CHANGE_URL.split("/")[4]
    organization + "/" + repo
}

def isBuildSuccessful() {
    (!currentBuild.result && !buildMarkedAsFailed)
}
