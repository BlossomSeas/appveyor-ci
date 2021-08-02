$LAST_HASH = $REPO_MASTER_HASH



# Reset shallow state
git reset ${env:APPVEYOR_REPO_BRANCH} --hard
git fetch origin ${env:APPVEYOR_REPO_BRANCH} --depth=10 --no-tags --quiet



#############################################



# Find merge-base commit manually
do {
  $HASH_LIST = git log $LAST_HASH -25 --format="%H"


  ForEach ($LAST_HASH in $HASH_LIST) {
    $LastTime = git log $LAST_HASH -1 --format="%ci"

    if ($LastTime -Le $REPO_MASTER_TIME) {
      break
    }
  }


  if ($LastTime -Gt $REPO_MASTER_TIME) {
    git fetch origin ${env:APPVEYOR_REPO_BRANCH} --deepen=25 --no-tags --quiet
  }
} while ($LastTime -Gt $REPO_MASTER_TIME)



#############################################



Set-Content -Path "${env:APPVEYOR_BUILD_FOLDER}/cache.hash" -Value $LAST_HASH -NoNewline
