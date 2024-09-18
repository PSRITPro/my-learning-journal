Set-Location $PSScriptRoot
$transScriptFile- ". \Logs\Trans$cript $(Get-Date -f yyyyMMdd HHmmss).log"
$csvreportfile = ". \Reports\CA_dailyreport PROD $(Get-Date -f yyyyMMdd HHmmss).csv"
Start-Transcript $trans$criptfile
#Define the path of the confifuration file
$configFile = ". \Config. Ison"
#Load configuration from J$ON file
$config = Get-Content -Path $configFile ConvertFrom-Json
#Configuration Variables
$tenantAdminURL =$configtenantAdminür1; $customActionTitle = $config.customActionTitle; $scriptSrc =$config.scritpSrc; ;
$siteCollectionAdmin = $config.siteCollectionAdmin; $clientId = $config.ClientId;
I
$teamSitesMangedPath = $config.teamSitesManagedPath
#Email Parameters
$mailto = $config.smtpToTest; $mallFrom= $config.smtpFrom; $mailServer = $config.smtpServer; $mailSubject = $config.smtpSubject
#$cred Get-Credential
$cred = Import-Clixml -Path '.\creds.xml'
#store all reports $Global:dailyreport
#function to check if custom action exist or not
function check_customaction($siteURL, $cred, $clientId) {
    Write-Host "####################################################"
    $isavailable - $false
    Write-Host "Working for - " $siteURL
    #Connecting to each site collection
    Connect-PnPOnline $Siteuri -Credentials $cred -ClientId $clientId
    Write-Host "Connection successful to - " $siteURL
    $web =Get-PnPSite
    #$web Get-PrnPweb
    $ctx = Get-PnPcontext
    $ctx.Load($web.UserCustomActions)
    Sctx.ExecuteQuery
    #Check if the Custon Action Exists already
    $CustomAction = $web.UserCustomActions | Where-Object {$_.Title -eq $customActionTitle}
    If($null -eq $CustomAction){
        Write-Host "Custon Action not available in - " $siteURL
    }
    Else{
    Write-Host "Custom Action Already Exists in  - " $web.Url -f Yellow
    Write-Host "####################################################"
    $isavailable = Strue
    $applieSites = New-Object System Object
    $applieSites | Add-Member Type soteProperty Name "Site url" -Value $siteur 
    $applieSites | Add-Member type NoteProperty Name "Status" -Value "Already Exist"
    $Global:dalyreport +=$applieSites
    }
    return $isavailable
}
#function to create customaction and propertybag value
function create_costomaction_propertybag($site, $cred, $clientId)(
Write-Host "####################################################"
Write-Host "Adding custon action" -f Green write-Host "working for
Connecting to each site collection
Connect-PPOnline Site Credentials Scred ClientId SclientId
write-Host "Connection successfull to Ssiteur
Sweb Get-PaulSite
Sctx Get-POPContext
Sctx. Load(Swel UserCustomActions)
Sctx. Executekjquery
#Add custon action
Shot on OnePlus SuserCustomAction Title UserCustomActions Add() SantosActiontitle
SUSPESUSTAction Location "ScriptLink