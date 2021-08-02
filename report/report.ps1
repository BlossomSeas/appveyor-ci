$url = "https://github.com/${env:GIT_USER}?tab=repositories"


$wait1 = 150
$wait2 = 100



echo "`n"
echo "Github: ${env:GIT_USER}`n"
echo ""



##################################



while (1) {
  Start-Sleep -m $wait1
  curl -o "C:\list.txt" $url


  if ($? -Eq $False) {
    break
  }



  # ===========================================



  # Users
  foreach ( `
    $repo in Select-String `
             -Path "C:\list.txt" `
             -Pattern "<a href=`"(.+)`" itemprop=`"name codeRepository`"" `
  ) {
    $repo = ( `
              $repo -Split "<a href=`"/${env:GIT_USER}/(.+)`" itemprop=`"name codeRepository`"" `
            )[1]


    Start-Sleep -m $wait2
    curl -o "C:\repo.txt" "https://github.com/${env:USER}/$repo"


    if ( `
      (Get-Content "C:\repo.txt" -Raw) `
      -Match "(\d+) commit(s)? behind" `
      -Eq $True `
    ) {
      echo "$repo  --  $($matches[0])"
    }
  }



  # ================================================



  # Organizations
  #           -Pattern "/hovercard`" href=`"(.+)`" class=`"d-inline-block`">" `
  foreach ( `
    $repo in Select-String `
             -Path "C:\list.txt" `
             -Pattern "data-hovercard-url=`"/${env:GIT_USER}/(.+)/hovercard`"" `
  ) {
    $repo = ( `
              $repo -Split "data-hovercard-url=`"/${env:GIT_USER}/(.+)/hovercard`"" `
            )[1]


    Start-Sleep -m $wait2
    curl -o "C:\repo.txt" "https://github.com/${env:GIT_USER}/$repo"


    if ( `
      (Get-Content "C:\repo.txt" -Raw) `
      -Match "(\d+) commit(s)? behind" `
      -Eq $True `
    ) {
      echo "$repo  --  $($matches[0])"
    }


    elseif ( `
      (Get-Content "C:\repo.txt" -Raw) `
      -Match "<a title=`"https://github.com/(.+)`" role=`"link`"" `
      -Eq $True `
    ) {
      $repo_upstream = $($matches[1])


      [int] $commits1 = ( `
                          (Get-Content "C:\repo.txt" -Raw) `
                          -Split "<span class=`"d-none d-sm-inline`">\n" `
                               + "(\s+)<strong>(.+)</strong>" `
                        )[2]


      Start-Sleep -m $wait2
      curl -o "C:\repo.txt" "https://github.com/$repo_upstream"


      [int] $commits2 = ( `
                          (Get-Content "C:\repo.txt" -Raw) `
                          -Split "<span class=`"d-none d-sm-inline`">\n" `
                               + "(\s+)<strong>(.+)</strong>" `
                        )[2]


      if ($($commits2 - $commits1) -Ge 1) {
        echo "$repo  --  $($commits2 - $commits1) commits behind"
      }
    }
  }



  # ================================================



  if ( `
    (Get-Content "C:\list.txt" -Raw) `
    -Match "https://github.com/${env:GIT_USER}\?after=(.+)`">Next" `
    -Eq $False `
  ) {
    break
  }


  $url = "https://github.com/${env:GIT_USER}?after=$($matches[1])"
}



##################################



echo "`n"
