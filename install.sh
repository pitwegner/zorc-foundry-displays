#!/bin/bash

FC_USERNAME=$1
FC_PASSWORD=$2
FC_FURNACES=$3

wget -O /home/pi/kiosk.sh https://raw.githubusercontent.com/marcfreiheit/zorc-foundry-displays/master/startup.sh

sudo tee /lib/systemd/system/kiosk.service > /dev/null <<EOF
[Unit]
Description=Chromium Kiosk
Wants=graphical.target
After=graphical.target

[Service]
Environment=DISPLAY=:0.0
Environment=XAUTHORITY=/home/pi/.Xauthority
Type=simple
ExecStart=/bin/bash /home/pi/kiosk.sh $FC_USERNAME $FC_PASSWORD $FC_FURNACES
Restart=on-abort
User=pi
Group=pi

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
