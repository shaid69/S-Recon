#!/bin/bash

# Define colors
END="\e[0m"
Red="\e[31m"
Green="\e[32m"
BOLDGREEN="\e[1;32m"
Yellow="\e[0;33m"
Cyan="\e[0;36m"
White="\e[0;37m"

# Check if the script is run as root
if [ $EUID -ne 0 ]; then
    echo -e "${Red}Please run this script as root.${END}"
    exit 1
fi

# Banner for the script
echo -e "
${Red}
/====================================================\
||      ____        ____                            ||
||     / ___|      |  _ \ ___  ___ ___  _ __        ||
||     \___ \ _____| |_) / _ \/ __/ _ \| '_ \       ||
||      ___) |_____|  _ <  __/ (_| (_) | | | |      ||
||     |____/      |_| \_\___|\___\___/|_| |_|      ||
\====================================================/
                                                  Created by Shaid Mahamud
                                                                                 
${END}"

# Create a directory for S-Recon and navigate into it
mkdir -p S-Recon
cd S-Recon || exit 1

# Function to install requirements
install_requirements() {
    echo -e "${Yellow}Checking and installing required packages...${END}"

    # Check and install Go if not installed
    if ! command -v go &> /dev/null; then
        echo -e "${Cyan}Go is not installed. Installing Go...${END}"
        wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz &> /dev/null
        tar -xvf go1.22.3.linux-amd64.tar.gz -C /usr/local/ &> /dev/null
        export GOPATH=$HOME/go
        export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
        source /etc/profile
    else
        echo -e "${Cyan}Go is already installed.${END}"
    fi

    # Install required system packages
    apt update &> /dev/null
    apt install -y build-essential git ruby-full python3 python3-pip &> /dev/null

    # Install Rust if not installed
    if ! command -v rustc &> /dev/null; then
        echo -e "${Cyan}Rust is not installed. Installing Rust...${END}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh &> /dev/null
    fi
}

# Function to install tools
install_tools() {
    echo -e "${Yellow}Installing tools...${END}"

    declare -A tools=(
        ["httpx"]="github.com/projectdiscovery/httpx/cmd/httpx@latest"
        ["httprobe"]="github.com/tomnomnom/httprobe@latest"
        ["amass"]="github.com/OWASP/Amass/v3/...@master"
        ["gobuster"]="github.com/OJ/gobuster/v3@latest"
        ["nuclei"]="github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
        ["subfinder"]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        ["assetfinder"]="github.com/tomnomnom/assetfinder@latest"
        ["ffuf"]="github.com/ffuf/ffuf@latest"
        ["gf"]="github.com/tomnomnom/gf@latest"
        ["meg"]="github.com/tomnomnom/meg@latest"
        ["waybackurls"]="github.com/tomnomnom/waybackurls@latest"
        ["subzy"]="github.com/LukaSikic/subzy@latest"
        ["asnmap"]="github.com/projectdiscovery/asnmap/cmd/asnmap@latest"
        ["jsleak"]="github.com/channyein1337/jsleak@latest"
        ["mapcidr"]="github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest"
        ["dnsx"]="github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
        ["gospider"]="github.com/jaeles-project/gospider@latest"
        ["wpscan"]="github.com/wpscanteam/wpscan"
        ["crlfuzz"]="github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest"
        ["dontgo403"]="github.com/devploit/dontgo403"
        ["katana"]="github.com/projectdiscovery/katana/cmd/katana@latest"
        ["uncover"]="github.com/projectdiscovery/uncover/cmd/uncover@latest"
        ["dalfox"]="github.com/hahwul/dalfox/v2@latest"
        ["GoLinkFinder"]="github.com/0xsha/GoLinkFinder@latest"
        ["hakrawler"]="github.com/hakluke/hakrawler@latest"
        ["csprecon"]="github.com/edoardottt/csprecon/cmd/csprecon@latest"
        ["gotator"]="github.com/Josue87/gotator@latest"
        ["osmedeus"]="github.com/j3ssie/osmedeus@latest"
        ["shuffledns"]="github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest"
        ["socialhunter"]="github.com/utkusen/socialhunter@latest"
        ["getJS"]="github.com/003random/getJS@latest"
    )

    for tool in "${!tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${Cyan}Installing $tool...${END}"
            go install ${tools[$tool]} &> /dev/null
            sudo cp $HOME/go/bin/$tool /usr/local/bin
            echo -e "${Green}$tool has been installed.${END}"
        else
            echo -e "${BOLDGREEN}$tool is already installed.${END}"
        fi
    done
}

# Function to install Python tools
install_python_tools() {
    echo -e "${Yellow}Installing Python tools...${END}"

    declare -A python_tools=(
        ["knockpy"]="https://github.com/guelfoweb/knock.git"
        ["XSStrike"]="https://github.com/s0md3v/XSStrike"
        ["Logsensor"]="https://github.com/Mr-Robert0/Logsensor.git"
        ["Altdns"]="https://github.com/infosec-au/altdns.git"
        ["xnLinkFinder"]="https://github.com/xnl-h4ck3r/xnLinkFinder.git"
        ["ParamSpider"]="https://github.com/devanshbatham/ParamSpider"
        ["NoSQLMap"]="https://github.com/codingo/NoSQLMap.git"
        ["chameleon"]="https://raw.githubusercontent.com/iustin24/chameleon/master/install.sh"
        ["GraphQLmap"]="https://github.com/swisskyrepo/GraphQLmap"
        ["WhatWeb"]="https://github.com/urbanadventurer/WhatWeb.git"
        ["http-request-smuggling"]="https://github.com/anshumanpattnaik/http-request-smuggling.git"
        ["commix"]="https://github.com/commixproject/commix.git"
        ["jwt_tool"]="https://github.com/ticarpi/jwt_tool"
        ["Arjun"]="https://github.com/s0md3v/Arjun"
        ["Gitleaks"]="https://github.com/zricethezav/gitleaks.git"
    )

    for tool in "${!python_tools[@]}"; do
        if [[ "$tool" == "chameleon" ]]; then
            echo -e "${Cyan}Installing $tool...${END}"
            curl -sL ${python_tools[$tool]} | bash
        else
            if [[ "$tool" == "WhatWeb" ]]; then
                echo -e "${Cyan}Installing $tool...${END}"
                git clone ${python_tools[$tool]}
                cd WhatWeb || exit
                gem install bundler
                bundle update
                bundle install
                echo -e "${Green}$tool has been installed.${END}"
                cd - || exit
            else
                if [[ "$tool" == "commix" ]]; then
                    echo -e "${Cyan}Installing $tool...${END}"
                    git clone ${python_tools[$tool]} commix
                    cd commix || exit
                    echo -e "${Green}$tool has been installed.${END}"
                    cd - || exit
                else
                    echo -e "${Cyan}Installing $tool...${END}"
                    git clone ${python_tools[$tool]}
                    cd $tool || exit
                    if [ -f "requirements.txt" ]; then
                        pip3 install -r requirements.txt
                    else
                        python3 setup.py install
                    fi
                    echo -e "${Green}$tool has been installed.${END}"
                    cd - || exit
                fi
            fi
        fi
    done
}

# Run functions
install_requirements
install_tools
install_python_tools

echo -e "${BOLDGREEN}All tools and requirements have been installed successfully!${END}"
