# MinGW-w64 9.0.0 requires Windows Vista (GetTickCount64)

$BUILD_VERSION = "11.1.0-12.0.0-8.0.2-r1"



if (${env:PLATFORM} -Match "x86" -Eq $True) {
  $BUILD_FILE = "winlibs-i686-posix-dwarf-gcc-11.1.0-mingw-w64-8.0.2-r1"
}

else {
  $BUILD_FILE = "winlibs-x86_64-winlibs-x86_64-posix-seh-gcc-11.1.0-mingw-w64-8.0.2-r1"
}



#####################################



$GCC_VERSION = ($BUILD_VERSION -Split "-")[0]



$env:COMPILER_VERSION = "GCC version ${GCC_VERSION}"
$env:PATH = "c:\mingw\bin;" + ${env:PATH}



#####################################



ren c:\mingw c:\mingw5



curl -o "C:\mingw.7z" ("https://github.com/brechtsanders/winlibs_mingw/releases/download/" `
                       + "${BUILD_VERSION}/${BUILD_FILE}.7z")

7z x c:\mingw.7z -oc:\ | Out-Null



if (${env:PLATFORM} -Match "x86" -Eq $True) {
  ren c:\mingw32 c:\mingw
}

else {
  ren c:\mingw64 c:\mingw
}



#####################################



$env:BUILD = "mingw32-make -f `"${env:SOLUTION}`" platform=`"${env:PLATFORM}`""



$env:CC = "gcc"
$env:CXX = "g++"
