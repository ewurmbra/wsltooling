Param (
[Parameter(Mandatory=$True)][ValidateNotNull()][string]$wslName,
[Parameter(Mandatory=$True)][ValidateNotNull()][string]$wslInstallationPath,
[Parameter(Mandatory=$True)][ValidateNotNull()][string]$username,
[Parameter(Mandatory=$True)][ValidateNotNull()][string]$installAllSoftware
)

# create staging directory if it does not exists
if (-Not (Test-Path -Path .\staging)) { $dir = mkdir .\staging }

wsl --install --distribution Ubuntu

wsl -d $wslName -u root bash -ic echo "
#!/bin/sh
export HTTP_PROXY="http://your.proxy:port"
export HTTPS_PROXY="$HTTP_PROXY"
export http_proxy="http://your.proxy:port"
export https_proxy="$http_proxy"
" 
wsl -d $wslName -u root bash -ic echo "" 

# Update the system
wsl -d $wslName -u root bash -ic "apt update; apt upgrade -y"

# # create your user and add it to sudoers
# wsl -d $wslName -u root bash -ic "./scripts/config/system/createUser.sh $username ubuntu"

# ensure WSL Distro is restarted when first used with user account
wsl -t $wslName

if ($installAllSoftware -ieq $true) {
    wsl -d $wslName -u root bash -ic "./scripts/config/system/sudoNoPasswd.sh $username"
    wsl -d $wslName -u root bash -ic ./scripts/install/installBasePackages.sh
    wsl -d $wslName -u $username bash -ic ./scripts/install/installAllSoftware.sh
    wsl -d $wslName -u root bash -ic "./scripts/config/system/sudoWithPasswd.sh $username"
}
