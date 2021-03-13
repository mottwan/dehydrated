#!/bin/bash

####################################################################
#                                                                  #
# github project:  https://github.com/dehydrated-io/dehydrated.git #
#                                                                  #
####################################################################


read -p "Enter your domain from duckdns.org: " domainname
read -p 'Enter your subdomain: ' subdomain
read -p "Enter domain token: " domaintoken

echo "Your full domain is: '${subdomain}.${domainname}.duckdns.org' "
echo "The ${subdomain} directory is being creating ..."
mkdir "${subdomain}"/
cd "${subdomain}"/

echo "Adding the '${subdomain}.${domainname}.duckdns.org' in ${subdomain}/domain.txt file"
echo "${subdomain}.${domainname}.duckdns.org" > domain.txt
echo "Creating the ${subdomain}/config file"


cat <<EOF > config
# Which challenge should be used? Currently http-01 and dns-01 are supported
CHALLENGETYPE="dns-01"

# Script to execute the DNS challenge and run after cert generation
HOOK="${BASEDIR}/hook.sh"
EOF

# echo
# echo "Adding the following content $(cat ./config) in config file"
# echo
echo "The 'hook.sh' file is being creating"
# echo
cat <<EOF > hook.sh
#!/usr/bin/env bash
set -e
set -u
set -o pipefail

domain="${domainname}"
token="${domaintoken}"

case "$1" in
   "deploy_challenge")
       curl "https://www.duckdns.org/update?domains=$domain&token=$token&txt=$4"
       echo
       ;;
   "clean_challenge")
       curl "https://www.duckdns.org/update?domains=$domain&token=$token&txt=removed&clear=true"
       echo
       ;;
   "deploy_cert")
       echo "deploy cert"
       # sudo systemctl restart home-assistant@homeassistant.service
       ;;
   "unchanged_cert")
       ;;
   "startup_hook")
       ;;
   "exit_hook")
       ;;
   *)
       echo Unknown hook "${1}"
       exit 0
       ;;
sac
EOF

# echo
# echo "Adding the following content $(cat hook.sh) in ${subdomain}/hook.sh file"
# echo
ls -la "../${subdomain}/"
chmod 755 hook.sh
cp ../backup/dehydrated ./
./dehydrated --register  --accept-terms
./dehydrated -c

# Create a crontab
# crontab -e
# 0 1 1 * * /home/homeassistant/dehydrated/dehydrated -c
