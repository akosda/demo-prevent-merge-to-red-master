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

def processCommitMessage() {
  sh '''
    COMMIT_ID=`git log -1 --format="id=%H"`
    COMMIT_MSG=`git log -1 --format="msg=%s"`
    if [[ $COMMIT_MSG == *"fix-master-job"* ]]; then
      echo "Setting continuous-integration/master-is-red context to 'success' on this branch..."
      echo "Faking GitHub API call"
    else
      echo "Commit message does not match fix pattern. Skipping GitHub API call."
    fi
  '''
}
