$LCV = 1
$MSG = "${env:TITLE}"



##################################



if ($env:TITLE -Eq $Null) {
  git commit --amend --author="${env:GIT_AUTHOR} <${env:GIT_EMAIL}>" --no-edit
}


else {
  while (1) {
    $LINE = iex("$" + "env:LINE" + $LCV)

    if ($LINE -Eq $Null) {
      break
    }



    if ($LCV -Eq 1) {
      $MSG += "`n"
    }

    $LCV += 1



    $MSG += "`n" + "$LINE"
  }


  git commit --amend -m "$MSG" --author="${env:GIT_AUTHOR} <${env:GIT_EMAIL}>"
}



##################################



git push -f origin HEAD:${env:APPVEYOR_REPO_BRANCH}
git log -1
