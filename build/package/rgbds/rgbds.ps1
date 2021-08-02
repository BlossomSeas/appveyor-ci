curl -o "C:\rgbds.txt" "https://github.com/gbdev/rgbds/releases"


$BUILD_VERSION = ( `
                   (Get-Content "C:\rgbds.txt" -Raw) `
                   -Split "/gbdev/rgbds/releases/download/(.+)-win64.zip" `
                 )[1]



curl -o "C:\rgbds.zip" "https://github.com/gbdev/rgbds/releases/download/${BUILD_VERSION}-win64.zip"
7z x c:\rgbds.zip -oc:\rgbds


$env:PATH = "c:\rgbds;" + ${env:PATH}
