#!/bin/bash

CURRENT_USER=$(whoami)

function usage () {
  echo "Invalid arguments"

  if [ "$1" = "username" ]; then
    echo "Username missing."
  fi
  if [ "$1" = "password" ]; then
    echo "Password missing."
  fi
  if [ "$1" = "furnaces"]; then
    echo "Furnaces missing"
  fi

  echo "\nusage: $0 <foundry_cloud-username> <foundry_cloud-password> <foundry_cloud-furnaces>"
  exit 2
}

function prompt_for() {
  local prompt=$1
  local default=$2
  local output_variable=$3

  echo $prompt
  read -p "[$default]: " answer
  case $answer in
    "") eval $output_variable=\"$default\" ;;
    *) eval $output_variable=\"$answer\" ;;
  esac
}

prompt_for "FoundryCloud Username" "" FC_USERNAME
prompt_for "FoundryCould Password" "" FC_PASSWORD
prompt_for "Furnaces to be displayed" "" FC_FURNACES

[[ -z "$FC_USERNAME" ]] && usage 'username'
[[ -z "$FC_PASSWORD" ]] && usage 'password'
[[ -z "$FC_FURNACES" ]] && usage 'furnaces'

wget -O /home/$CURRENT_USER/kiosk.sh https://raw.githubusercontent.com/marcfreiheit/zorc-foundry-displays/master/startup.sh

sudo tee /lib/systemd/system/kiosk.service > /dev/null <<EOF
[Unit]
Description=Chromium Kiosk
Wants=graphical.target
After=graphical.target

[Service]
Environment=DISPLAY=:0.0
Environment=XAUTHORITY=/home/$CURRENT_USER/.Xauthority
Type=simple
ExecStart=/bin/bash /home/$CURRENT_USER/kiosk.sh $FC_USERNAME $FC_PASSWORD $FC_FURNACES
Restart=on-abort
User=$CURRENT_USER
Group=$CURRENT_USER

[Install]
WantedBy=graphical.target
EOF

sudo systemctl enable kiosk.service
sudo systemctl start kiosk.service

echo "Do you want to restart in order to boot into kiosk mode?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo reboot; break;;
        No ) exit 0;;
    esac
done
