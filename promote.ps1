Write-Host "==========="
Write-Host "Promote a git tag to next environment/branch"
Write-Host "==========="
$gitTags = cmd /c "git tag" 2`>`&1
$gitTagToPromote=($gitTags -split '\s+') | Out-Gridview -Title "Select a commit to cherrypick" -OutputMode Single
Write-Host Create Merge branch and cherrypick
$timestamp=(Get-Date -UFormat %s -Millisecond 0)
$gitTargetBranch=("test main" -split '\s+') | Out-Gridview -Title "Select a commit to cherrypick" -OutputMode Single
$temporaryMergeRequestBranchName="promotion-to-$gitTargetBranch-$timestamp"
$gitCommitToCherryPick = cmd /c "git rev-list -n 1 tags/$gitTagToPromote" 2`>`&1
git checkout $gitTargetBranch
git checkout -b "$temporaryMergeRequestBranchName" $gitTargetBranch
Write-Host Temp Merge Branch: "$temporaryMergeRequestBranchName"
Write-Host Cherry-Pick Commit: "$gitCommitToCherryPick"
git cherry-pick --strategy=recursive -X theirs "$gitCommitToCherryPick"
#git cherry-pick "$gitCommitToCherryPick"
###################
# gitlab:
#uncomment with gitlab: git push -u origin "$temporaryMergeRequestBranchName"
#uncomment with gitlab: $Response = Invoke-WebRequest -URI http://gitlab.harel-office.com/DevOps/eyalaz/tap-gitops-cherrypick/-/merge_requests/new?merge_request%5B$temporaryMergeRequestBranchName%5D=$gitTargetBranch
###################
# without gitlab:
git checkout $gitTargetBranch 
git merge "$temporaryMergeRequestBranchName"
git branch -D "$temporaryMergeRequestBranchName"
