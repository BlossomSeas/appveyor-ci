echo ""



$filetypes = (
  ("*${env:Project}*.exe"),
  ("*${env:Project}*.exe.manifest"),
  ("*${env:Project}*.pdb"),
  ("*${env:Project}*.dll")
)



###########################################



foreach ($filetype in $filetypes) {
  $artifacts = Get-ChildItem -Recurse -Filter $filetype


  foreach ($artifact in $artifacts) {
    Push-AppveyorArtifact $artifact.FullName -FileName (Split-Path $artifact.FullName -NoQualifier)
  }
}



###########################################



echo "`n"
