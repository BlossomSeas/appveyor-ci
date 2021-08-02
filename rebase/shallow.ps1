# Download shallow repo
git fetch repo_master ${env:APPVEYOR_REPO_BRANCH} --no-tags --shallow-since=${REPO_MASTER_TIME}
