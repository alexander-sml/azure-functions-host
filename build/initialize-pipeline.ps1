$buildReason = $env:BUILD_REASON
$sourceBranch = $env:BUILD_SOURCEBRANCH
$bypassPackaging = $true
$includeSuffix = $false
Write-Host "SourceBranch: $sourceBranch, Build reason: $buildReason"

if($sourceBranch.endsWith('release/2.0') -and ($buildReason -ne "PullRequest"))
{
  $bypassPackaging = $false
}
elseif($buildReason -eq "PullRequest")
{
  $response = Invoke-RestMethod api.github.com/repos/$env:BUILD_REPOSITORY_ID/pulls/$env:SYSTEM_PULLREQUEST_PULLREQUESTNUMBER
  $title = $response.title.ToLowerInvariant()
  if ($title.Contains("[pack]")) {
    $bypassPackaging = $false
  }
}

Write-Host "BypassPackaging: $bypassPackaging, IncludeSuffix: $includeSuffix"

# Write to output
"##vso[task.setvariable variable=IncludeSuffix;isOutput=true]$includeSuffix"
"##vso[task.setvariable variable=BypassPackaging;isOutput=true]$bypassPackaging"