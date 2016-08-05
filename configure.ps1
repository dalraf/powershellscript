# Executar a adição ao domínio, coloque $false caso não deseje a execução
$addtodomain=$true

# Setar password e ativa o usuário administrador, coloque $false caso não deseje a execução
$setadminpassword=$true

# Lista de fabricantes de programas que devem ser removidos, exemplo "kaspersky" "microsoft"
$programsremove = @("mcafee", "avast")

# Lista de fabricantes de programas que devem ser instalados de acordo com a galeria do chocolateycache
# https://chocolatey.org/packages
$programsadd = @("googlechrome", "winrar", "spark" , "spark", "flashplayerplugin", "firefox", "adobeair", "cutepdf" ,"javaruntime", "teamviewer -version 10.0.47484", "ultravnc" ,"winscp", "adobereader")

# Diretório de cache do chocolatey aonde seram baixados os executáveis de instalação
# Esse diretório pode ser copiado para outra cpu após uma instalação para acelerar a instalação.
$chocolateycache="c:\chocolateycache"

# Password do administador local da cpu
$passwordadministradorlocal=""

# Domínio AD qualificado aonde a cpu será instalada
$domain = "example.local"

# Usuario com permissão para adicionar no domínio
$usernamedomain = "example\administrador"

# Password do usuário com permissão para adicionar no domínio
$passworddomain = "" | ConvertTo-SecureString -asPlainText -Force





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
