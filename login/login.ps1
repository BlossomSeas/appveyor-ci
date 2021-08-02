if( ${env:GIT_AUTHOR} -Eq $Null ) {
  $env:GIT_AUTHOR = ${env:APPVEYOR_REPO_COMMIT_AUTHOR}
}


if( ${env:GIT_EMAIL} -Eq $Null ) {
  $env:GIT_EMAIL = ${env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL}
}



git config --unset credential.helper
git config --unset user.name
git config --unset user.email



###############################################



git config user.name "${env:GIT_AUTHOR}"
git config user.email "${env:GIT_EMAIL}"


git config advice.detachedHead false
git config core.autocrlf false
git config pull.rebase false


git config credential.helper store
Add-Content .gitattributes "`n* -text"


if( ${env:GIT_TOKEN} -Ne $Null ) {
  Set-Content -Path "$HOME/.git-credentials" `
              -Value "https://${env:GIT_TOKEN}:x-oauth-basic@github.com`n" `
              -NoNewline
}
