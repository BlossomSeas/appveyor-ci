if (${env:GIT_CLEAN} -Eq "yes") {
  cd ${env:APPVEYOR_BUILD_FOLDER}

  Move-Item -Path ${env:GIT_ARCHIVE} -Destination ..\
  Move-Item -Path .git* -Destination ..\
  Move-Item -Path .git -Destination ..\ -Force



  cd ..

  Remove-Item -Recurse -Force ${env:APPVEYOR_BUILD_FOLDER}
  New-Item -Path ${env:APPVEYOR_BUILD_FOLDER} -itemtype directory



  Move-Item -Path ${env:GIT_ARCHIVE} -Destination ${env:APPVEYOR_BUILD_FOLDER}
  Move-Item -Path .git* -Destination ${env:APPVEYOR_BUILD_FOLDER} -Force
  Move-Item -Path .git -Destination ${env:APPVEYOR_BUILD_FOLDER} -Force

  cd ${env:APPVEYOR_BUILD_FOLDER}
}



##########################################



7z x ${env:GIT_ARCHIVE} -aoa
del ${env:GIT_ARCHIVE}

git add .



##########################################



$title = git log -1 --pretty=format:'%s'


git reset --soft HEAD~1
git commit -m "$title"
