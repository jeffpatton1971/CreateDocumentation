[cmdletbinding()]
param (
 [Parameter(Mandatory = $true)]
 [string]$ProjectPath,
 [Parameter(Mandatory = $true)]
 [string]$Configuration,
 [Parameter(Mandatory = $true)]
 [string]$DotNetVersion,
 [Parameter(Mandatory = $true)]
 [string]$AssemblyName,
 [Parameter(Mandatory = $true)]
 [string]$DocumentationPath
)
$ErrorActionPreference = 'Stop';
$Error.Clear();
try
{
 #
 # Enter the project folder
 #
 if ($VerbosePreference -eq 'Continue')
 {
  Set-Location -Path $ProjectPath -Verbose;
 }
 else
 {
  Set-Location -Path $ProjectPath -Verbose;
 }
 #
 # Test for DefaultDocumentation Tool
 #
 $DotnetTools = dotnet tool list --global;
 $DefaultDocumentationArray = ($DotnetTools | Select-String 'defaultdocumentation').ToString() -split '\s+';
 $DefaultDocumentation = New-Object PSObject -Property @{
  PackageId = $DefaultDocumentationArray[0]
  Version   = $DefaultDocumentationArray[1]
  Commands  = $DefaultDocumentationArray[2]
 }
 if ($DefaultDocumentation)
 {
  Write-Verbose "Info: DefaultDocumentation Version $($DefaultDocumentation.Version) Found";
 }
 else
 {
  throw "Please dotnet tool install DefaultDocumentation.Console -g";
 }
 #
 # Create Documentation
 #
 if ($VerbosePreference -eq 'Continue')
 {
  defaultdocumentation -a "$($ProjectPath)\bin\$($Configuration)\$($DotnetVersion)\$($AssemblyName).dll" -o $DocumentationPath --loglevel info;
 }
 else
 {
  defaultdocumentation -a "$($ProjectPath)\bin\$($Configuration)\$($DotnetVersion)\$($AssemblyName).dll" -o $DocumentationPath;
 }
}
catch
{
 throw $_;
}