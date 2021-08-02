cd ${APPVEYOR_GIT_FOLDER}/build/tools/hexdump



& ${env:CXX} hexdump.c -o hexdump.exe

$env:PATH = "$(Get-Location);" + $env:PATH



cd ${env:APPVEYOR_BUILD_FOLDER}
