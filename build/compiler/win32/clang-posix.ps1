curl -o "C:\gcc.txt" "https://github.com/brechtsanders/winlibs_mingw/releases/latest"



$BUILD_VERSION = ( `
                   (Get-Content "C:\gcc.txt" -Raw) `
                   -Split "/brechtsanders/winlibs_mingw/releases/download/(.+)/winlibs" `
                 )[1]



if ($env:PLATFORM -Match "x86" -Eq $True) {
  $BUILD_FILE = "winlibs-i686"
}

else {
  $BUILD_FILE = "winlibs-x86_64"
}



$BUILD_FILE += ( `
                 ( `
                   (Get-Content "C:\gcc.txt" -Raw) `
                   -Split ("<a href=`"/brechtsanders/winlibs_mingw/releases/download/" `
                           + "${BUILD_VERSION}/${BUILD_FILE}(.+).7z`" rel=`"nofollow`"") `
                 )[1] -Split ".7z" `
               )[0]



#####################################



$GCC_VERSION = ($BUILD_VERSION -Split "-")[0]
$CLANG_VERSION = ( `
                   ($BUILD_VERSION -Split "-")[1] `
                   -Split "-" `
                 )[0]



$env:COMPILER_VERSION = "GCC version ${GCC_VERSION}"
$env:PATH = "c:\mingw\bin;" + $env:PATH



#####################################



ren c:\mingw c:\mingw5



curl -o "C:\mingw.7z" ("https://github.com/brechtsanders/winlibs_mingw/releases/download/" `
                       + "${BUILD_VERSION}/${BUILD_FILE}.7z")
7z x c:\mingw.7z -oc:\



if ($env:PLATFORM -Match "x86" -Eq $True) {
  ren c:\mingw32 c:\mingw
}

else {
  ren c:\mingw64 c:\mingw
}



#####################################



$env:BUILD = "mingw32-make -f `"${env:SOLUTION}`" platform=`"${env:PLATFORM}`""



$env:CC = "gcc"
$env:CXX = "g++"
