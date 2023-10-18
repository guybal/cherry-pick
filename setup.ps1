Write-Host Git init
git init --initial-branch=main
Write-Host Add old files
git add . 
git commit -m "init"
Write-Host Create Test branch from main
git checkout -b test
Write-host Create Dev branch from test
git checkout -b dev
Write-host Branches:
git branch --all
