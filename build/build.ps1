run_script "build/helper.ps1"



#####################################



if( ${env:PROJECT} -Eq $Null ) {
  $env:PROJECT = ${env:APPVEYOR_PROJECT_NAME}
}


if( ${env:SOLUTION} -Eq $Null ) {
  $env:SOLUTION = "Makefile"
}



#####################################



$env:BUILD_PATH = Split-Path ${env:SOLUTION} -Parent


if( ${env:BUILD_PATH} -Eq $Null ) {
  $env:BUILD_PATH = "."
}


$env:SOLUTION = Split-Path ${env:SOLUTION} -Leaf



#####################################



cd ${env:APPVEYOR_BUILD_FOLDER}



if (Test-Path ".gitmodules") {
  git submodule update --init --recursive --depth 1

  echo "`n`n"
}



# After submodules, not before
${env:REMOTE_ORIGIN_FETCH} = git config remote.origin.fetch

git config --local remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"



#####################################



$global:REPO_DEFAULT_BRANCH = $(git ls-remote --symref https://github.com/${env:APPVEYOR_REPO_NAME} HEAD | `
                                awk -F"[:/\\t]*" '/ref/ { print $4 }')


$global:REPO_DEFAULT_HASH = $(git ls-remote "https://github.com/${env:APPVEYOR_REPO_NAME}" HEAD | `
                              awk '{ print $1 }')



git fetch origin $REPO_DEFAULT_HASH --depth=1 --no-tags --quiet

$global:REPO_DEFAULT_TIME = git log $REPO_DEFAULT_HASH -1 --format="%ci"



# Unshallow to merge-base
$LAST_COMMIT = "HEAD"

while (1) {
  $LAST_COMMIT = git rev-list --date-order --max-parents=0 $LAST_COMMIT
  $LAST_TIME = git log $LAST_COMMIT -1 --format="%ci"


  if ($LAST_TIME -Le $REPO_MASTER_TIME) {
    break
  }


  git fetch origin ${env:APPVEYOR_REPO_BRANCH} --deepen=25 --no-tags --quiet
}



#####################################



run_script "build/compiler"


run_script "build/tools/git_edit"
