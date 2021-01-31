Set-StrictMode -Version Latest
#####################################################
#  Get-KuduCommand
#####################################################
<#
.SYNOPSIS
    Run a command line command within an Azure Web App via the Kudu API interface.
.DESCRIPTION
    Sets current working directory
.PARAMETER key
    The API key used to connect to the Kudu service. Use Get-AzureRmWebAppPublishingCredentials
.PARAMETER url
    The URL of the web app with the .scm. addition to reach Kudu.
    For example a web app could by my-web-app.azurewebsites.net,
    the kudu URL would be my-wb-app.scm.azurewebsites.net
.PARAMETER cmd
    The command you'd like to run on the web app server.
.EXAMPLE
    PS C:\> Set-LocationPSScript -Path VAR1 -Cwd "value one"
.EXAMPLE
    PS C:\> "value one" | Set-LocationPSScript "VAR1"
.EXAMPLE
    PS C:\> Set-LocationPSScript -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>
function Get-KuduCommand
{
	[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$key,
    
        [Parameter(Mandatory=$true, Position=1)]
        [string]$url,
    
        [Parameter(Mandatory=$true, Position=2)]
        [alias("command")]
        [string]$cmd
    )
	begin {
		$ErrorActionPreference = 'Stop'
		$VerbosePreference = "Continue"
	}
	process {
        $authToken = "Basic $apiKey"

        $body = @"
        {
            "command": "$command"
        }
"@
        if($PSCmdlet.ShouldProcess($scriptPath)) {
            $results = Invoke-RestMethod -Method POST -Uri "$url/api/command" `
                                -Headers @{"Authorization"=$authToken;"If-Match"="*"} `
                                -Body $body `
                                -ContentType "application/json"

            Write-Output $results
        }
	}
}