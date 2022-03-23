#! /usr/bin/env bash

# Color Codes of Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
Nc='\033[0m'              # No Color

# banner
clear
printf "\n\n\n${Green}Hacking Tools and Wordlist Installer written by,\n\n\n"
printf "\033[30;6;47m" # banner bg and fg color

cat << "EOF"
  _____    _                _      _ _____ _                 _          
 |_  (_)__| |_  __ _ _ _   /_\  __| |_   _| |_  __ _ _ _  __| |__ _ _ _ 
  / /| (_-| ' \/ _` | ' \ / _ \/ _` | | | | ' \/ _` | ' \/ _` / _` | '_|
 /___|_/__|_||_\__,_|_||_/_/ \_\__,_| |_| |_||_\__,_|_||_\__,_\__,_|_|  
EOF
printf "\n\n\n${Cyan}https://twitter.com/ZishanAdThandar${Nc}\n\n"
sleep 2 #banner break  
                              
# one liner bash if loop to check root user
[ "$EUID" -ne 0 ] && printf "\n\033[30;5;41mPlease run as root.${Nc}\n" && exit

# function for wordlists from github
function wsgit { 
[ -d "/opt/wordlist/$1" ] && printf "\n${Yellow}$1 already installed${Nc}\n"
[ ! -d "/opt/wordlist/$1" ] && git clone $2 /opt/wordlist/$1 && printf "${Purple}$1 downloaded successfully\n${Nc}"
}
# function for wordlists with wget
function wswget { 
[ -f "/opt/wordlist/$1" ] && printf "\n${Yellow}$1 already downloaded${Nc}\n"
[ ! -f "/opt/wordlist/$1" ] && wget $2 -O /opt/wordlist/$1 && printf "${Purple}$1 downloaded\n${Nc}"
}
# Making wordlist folder if not exist
[ ! -d "/opt/wordlist" ] && mkdir /opt/wordlist
cd /opt/wordlist
printf "we are in $(pwd) folder.\n\n/opt/wordlist/ Folder Contains:\n"
ls
# Array for wordlists
declare -A wsgitarray=( [PayloadsAllTheThings]="https://github.com/swisskyrepo/PayloadsAllTheThings" [SecLists]="https://github.com/danielmiessler/SecLists" [fuzzdb]="https://github.com/fuzzdb-project/fuzzdb" [node-dirbuster]="https://github.com/daviddias/node-dirbuster" [api_wordlist]="https://github.com/chrislockard/api_wordlist")
declare -A wsgetarray=( [all.txt]="https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt" [markdownxss.txt]="https://raw.githubusercontent.com/cujanovic/Markdown-XSS-Payloads/master/Markdown-XSS-Payloads.txt")

# for loop to git clone wordlists
for i in "${!wsgitarray[@]}"
do
  wsgit $i ${wsgitarray[$i]}
done
# for loop to wget wordlists
for i in "${!wsgetarray[@]}"
do
  wswget $i ${wsgetarray[$i]}
done

# Rockyou unzipping
[ -f "/opt/wordlist/rockyou.txt" ] && printf "\n${Yellow}rockyou.txt already downloaded${Nc}\n"
[ ! -f "/opt/wordlist/rockyou.txt" ] && tar -xf /opt/wordlist/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /opt/wordlist/ && printf "${Purple}unzipped rockyou.txt${Nc}\n"


# Assetnote API wordlist (creates logical block error, because of large files)
# [ -d "/opt/wordlist/assetnote" ] && printf "\n${Yellow}Assetnote API wordlist already installed${Nc}\n"
#[ ! -d "/opt/wordlist/assetnote" ] && mkdir /opt/wordlist/assetnote && wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH -np /opt/wordlist/assetnote/ && printf "${Purple}Assetnote API wordlist downloaded successfully\n${Nc}" && mv /opt/wordlist/data/* /opt/wordlist/assetnote && rm -rf /opt/wordlist/data

printf "\n${Cyan}Stage 1 Finished!\nWordlists Downloaded.${Nc}\n\n"
sleep 3 #stage 1 break

declare -a aptarray=("aircrack-ng" "audacity" "axiom" "beef" "binwalk" "bully" "cewl" "crunch" "dirb" "dnsenum" "dnsrecon" "exiftool" "fluxion" "forensics-all" "git" "gobuster" "hashcat" "hcxdumptool" "httrack" "hydra"  "john" "masscan" "macchanger" "ndiff" "nodejs" "nikto" "nmap" "npm" "openvpn" "pixiewps" "proxychains" "python2" "python3" "python-pip" "python3-pip" "reaver" "stegcracker" "steghide" "sqlmap" "tmux" "tor" "uget" "wafw00f" "wapiti" "whatweb" "wifite" "wireshark")

#Function to check if installed and install it
function aptinstall {
dpkg -l "$1" | grep -q ^ii && return 1
apt-get -y install "$1"
return 0
}
#Installing from array
for i in "${aptarray[@]}"
do
  aptinstall $i
done
#functions to check missing tools
function missapt {
if ! command -v $1 &> /dev/null
then
	printf "${Red}Install $1 manually.\n${Nc}"
fi
}
#Recommending missing tools from array
for i in "${aptarray[@]}"
do
  missapt $i
done

printf "\n${Cyan}Stage 2 Finished!\nApt Installation Finished.\nCheck for missing tools and manually install.${Nc}\n"
sleep 2 #stage 2 break

# metasploit installation
if ! command -v msfconsole &> /dev/null
then
  curl -s https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
  rm msfinstall
fi


# installing and setting up Golang
[ -d "/usr/local/go" ] && printf "\n${Yellow}GoLang already downloaded${Nc}\n"
[ ! -d "/usr/local/go" ] && cd /tmp && wget https://go.dev/dl/go1.17.4.linux-amd64.tar.gz && tar -C /usr/local/ -xzf go1.17.4.linux-amd64.tar.gz && cd /usr/local/ && echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bashrc && echo "export GOROOT=/usr/local/go" >> ~/.bashrc && echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> /home/*/.bashrc && echo "export GOROOT=/usr/local/go" >> /home/*/.bashrc && source ~/.bashrc && source /home/*/.bashrc

# Installing GoLang tools
printf "\n${Cyan}Installing Go Tools for user \033[30;5;41mROOT${Nc}${Cyan} (Current User).${Nc}\n\n"
sleep 1
function goinstall {
[ -f "$HOME/go/bin/$1" ] && printf "$1 already installed.\n"
[ ! -f "$HOME/go/bin/$1" ] &&  go install -v $2@latest && printf "$1 installed successfully.\n"
}
declare -A goinstallarray=( [assetfinder]="github.com/tomnomnom/assetfinder" [dalfox]="github.com/hahwul/dalfox" [gf]="github.com/tomnomnom/gf" [qsreplace]="github.com/tomnomnom/qsreplace" [waybackurls]="github.com/tomnomnom/waybackurls" )

for i in "${!goinstallarray[@]}"
do
  goinstall $i ${goinstallarray[$i]}
done

# setting gf patterns by 1ndianl33t
[ -d "$HOME/.gf" ] && printf "gf patterns by 1ndianl33t already installed.\n"
[ ! -d "$HOME/.gf" ] && git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf && printf "gf patterns by 1ndianl33t installed succesfully.\n"

[ -f "$HOME/.gf/base64.json" ] && printf "gf patterns by tomnomnom already installed.\n"
[ ! -f "$HOME/.gf/base64.json" ] && git clone https://github.com/tomnomnom/gf /tmp/gf && mv /tmp/gf/examples/* ~/.gf/ && printf "gf patterns by tomnomnom installed succesfully.\n"

#At the end Installing python3 tools
printf "\n${Cyan}Installing Python Tools for user ROOT.${Nc}\n"
sleep 1

python3 -m pip install sublist3r 
python3 -m pip install pwntools 

#installing waybackurls python
#[ -f "/usr/bin/waybackurls" ] && printf "\n${Yellow}waybackurls already downloaded${Nc}\n"
#[ ! -f "/usr/bin/waybackurls" ] && wget https://gist.githubusercontent.com/ZishanAdThandar/442a1681673db9f65a8164965f2438ae/raw/93f0bc596abace2fe56d612e17325691532ecd53/waybackurls -O /usr/bin/waybackurls && printf "${Purple}waybackurls downloaded\n${Nc}" && chmod +x /usr/bin/waybackurls

printf "\n${Cyan}Stage 3 Finished!\nOne by One Installation Finished.\n\033[30;5;41mRUN THIS SCRIPT FOUR TO FIVE TIMES. \nCheck for missing tools in output and manually install.${Nc}\n\n"

