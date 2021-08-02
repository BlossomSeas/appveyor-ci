if ((git ls-remote --heads origin "${env:APPVEYOR_REPO_BRANCH}_cache") -Eq $Null) {
  return
}



# Check if cache exists
git pull origin "${env:APPVEYOR_REPO_BRANCH}_cache" --depth=1 --allow-unrelated-histories --quiet

if ((Test-Path -Path "${env:APPVEYOR_BUILD_FOLDER}/cache.zip") -Eq $False) {
  return
}



#############################################



echo "Restoring build cache`n`n"


unzip "-DDqqo" "${env:APPVEYOR_BUILD_FOLDER}/cache.zip"



#############################################



# Check for new commits since last build
$MASTER_HASH = $(git ls-remote "https://github.com/${env:APPVEYOR_REPO_NAME}" HEAD | `
                 awk '{ print $1 }')


$LAST_HASH = (Get-Content -Path "cache.hash" -Raw) `
              -Replace "`r|`n",""


if ($MASTER_HASH -Eq $LAST_HASH) {
  return
}



#############################################



echo "Scanning new files`n"



# Cache commit date
git fetch origin $LAST_HASH --depth=1 --no-tags --quiet

$LAST_DATE = git log $LAST_HASH -1 --format="%ci"



# Current commit
git fetch origin $MASTER_HASH --shallow-since=$LAST_DATE --no-tags --quiet



# Changed files between builds
$CACHE_LIST = git diff $LAST_HASH..$MASTER_HASH --name-only
echo $CACHE_LIST



# Rebuild new files
$NEW_TIME = $(Get-Date)

ForEach ($File in $CACHE_LIST) {
  Set-ItemProperty -Path $File -Name LastWriteTime -Value $NEW_TIME -ErrorAction 'SilentlyContinue'
}



#############################################



# Wait for timestamps to clear
Start-Sleep -Milliseconds 1


echo "`n"
