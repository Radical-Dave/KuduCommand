Set-StrictMode -Version Latest
#Requires -RunAsAdministrator
# Get Functions
$src = Join-Path $PSScriptRoot "src"
$private = @()
if(Test-Path(Join-Path $src Private)) {
    $private = @(Get-ChildItem -Path (Join-Path $src Private) -Include *.ps1 -File -Recurse)
}
$public = @(Get-ChildItem -Path (Join-Path $src Public) -Include *.ps1 -File -Recurse)
# Dot source to scope
# Private must be sourced first - usage in public functions during load
($private + $public) | ForEach-Object {
    try {
        . $_.FullName
    }
    catch {
        Write-Warning $_.Exception.Message
    }
}