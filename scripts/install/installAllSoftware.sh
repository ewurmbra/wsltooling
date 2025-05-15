#!/bin/bash

set -euo pipefail

DIR_ME=$(realpath $(dirname $0))
. ${DIR_ME}/.installUtils.sh
setUserName "$(whoami)"

bash ${DIR_ME}/../config/system/prepareXServer.sh ${USERNAME}

echo -e "\n\nInstalling OpenVSCode Server"
bash ${DIR_ME}/installOpenVSCodeServer.sh

echo -e "\n\nInstalling docker & docker-compose apt"
bash ${DIR_ME}/installDocker.sh

echo -e "\n\nInstalling DevTool (dt)"
curl -sSL https://github.intel.com/raw/vpgsw/devtool/master/scripts/linux_install.sh | bash

# clean-up
sudo apt autoremove

bash ${DIR_ME}/../report/listVersions.sh
