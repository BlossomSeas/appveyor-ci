$global:GIT_SCRIPT_HEAD = git ls-remote "https://github.com/${env:GIT_SCRIPT}/appveyor-git.git" HEAD `
                          | awk '{ print $1 }'



iex( (New-Object System.Net.WebClient).DownloadString("https://github.com/${env:GIT_SCRIPT}/appveyor-git/raw/${GIT_SCRIPT_HEAD}/script/init.ps1") )
