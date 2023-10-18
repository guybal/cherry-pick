Write-Host "==========="
Write-Host "Simulate build by update to Docker Image revision in delivery.yml"
Write-Host "==========="
git checkout dev

$selectedApplicationPath=(Get-ChildItem -Path .\ -Filter *.yml -Recurse -File -Name) | Out-Gridview -Title "Select your choice" -OutputMode Single
$selectedApplication=(Split-Path "$selectedApplicationPath" -Parent)
$selectedApplication=Split-Path $selectedApplication -leaf

Write-Host "Generating Random SHA256"  | out-null
-join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_}) | Out-File temp.txt
$newHash = Get-FileHash -Algorithm SHA256 -Path temp.txt | Select-Object Hash | ForEach-Object {$_.Hash}
Write-Host "The new hash is $newHash" | out-null
Remove-Item temp.txt
(Get-Content "$selectedApplicationPath") -replace "@sha.+","@sha256:$newHash"| Set-Content "$selectedApplicationPath"

git add $selectedApplicationPath
git commit -m "new build of $selectedApplication"
$timestamp=(Get-Date -UFormat %s -Millisecond 0)
$tagName="$selectedApplication-$timestamp"
git tag $tagName
#uncomment with gitlab: git push 
#uncomment with gitlab: git push origin "$tagName"
