#!/bin/bash

wget -O /home/pi/kiosk.sh https://github.com/marcfreiheit/zorc-foundry-displays/edit/master/startup.sh

cat > /lib/systemd/system/kiosk.service <<EOF
[Unit]
Description=Chromium Kiosk
Wants=graphical.target
After=graphical.target

[Service]
Environment=DISPLAY=:0.0
Environment=XAUTHORITY=/home/pi/.Xauthority
Type=simple
ExecStart=/bin/bash /home/pi/kiosk.sh
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
