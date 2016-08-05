$addtodomain=$true

$setadminpassword=$true

$programsremove = @("mcafee", "avast")

$programsadd = @("googlechrome", "winrar", "spark" , "spark", "flashplayerplugin", "firefox", "adobeair", "cutepdf" ,"javaruntime", "teamviewer -version 10.0.47484", "ultravnc" ,"winscp", "adobereader")

$passwordadministradorlocal=""

$domain = "example.local"

$passworddomain = "" | ConvertTo-SecureString -asPlainText -Force

$usernamedomain = "example\administrador"

$chocolateycache="c:\chocolateycache"


foreach($programremove in $programsremove){
Get-WmiObject -Class Win32_Product | where {$_.Vendor -like "*$programremove*"} | ForEach-Object {$_.Uninstall()}
}


iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

mkdir $chocolateycache

foreach($programadd in $programsadd){
choco install -c $chocolateycache -y $programadd
}

if ($setadminpassword){
net user administrador $passwordadministradorlocal
net user administrador /active:yes
}

if ($addtodomain){
$credential = New-Object System.Management.Automation.PSCredential($usernamedomain,$passworddomain)
Add-Computer -DomainName $domain -Credential $credential
}

shutdown /r /t 0
