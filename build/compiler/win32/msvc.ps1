$env:COMPILER_VERSION = ${env:APPVEYOR_BUILD_WORKER_IMAGE}



#####################################



if ( `
  $env:SOLUTION -Like "*.sln" -Or `
  $env:SOLUTION -Like "*.vcxproj" `
) {
  $env:BUILD = ( `
    "msbuild `"${env:SOLUTION}`"" + `
    " /p:Platform=`"${env:PLATFORM}`"" + `
    " /p:Configuration=`"${env:CONFIGURATION}`"" + `
    " /m" `
  )
}


else {
  $env:BUILD = ( `
    "mingw32-make -f `"${env:SOLUTION}`"" + `
    " platform=`"${env:PLATFORM}`"" `
  )
}



#####################################



# 2017, 2019
if (Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe") {
  Invoke-Environment "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
  Invoke-Environment "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat"


  $env:PATH = "C:\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin;" + $env:PATH
  # $env:PATH = "C:\msys64\usr\bin;" + $env:PATH
}


# Warning: $env:PLATFORM = x86, x64, arm



#####################################



$env:CC = "gcc"
$env:CXX = "g++"
