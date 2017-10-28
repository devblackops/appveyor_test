[cmdletbinding()]
param(
    [string[]]$Task = 'default'
)

'BuildHelpers', 'psake' | ForEach-Object {
    if (-not (Get-Module $_ -ListAvailable)) {
        Install-Module $_
    }
    Import-Module $_
}

Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Set-BuildEnvironment -Force

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo -Verbose:$VerbosePreference
exit ( [int]( -not $psake.build_success ) )
