#!/bin/bash

# Foundry Cloud Credentials
FC_USERNAME="MAN-Display"
FC_PASSWORD="123456"


#
FC_PROTOCOL="http://"
FC_HOST="192.168.100.12:8000"
FC_LOGIN_PATH="/login"
FC_LOGIN_URL="$FC_PROTOCOL$FC_HOST$FC_LOGIN_PATH"

FC_REQUEST_HTTP_METHOD="-X POST"
FC_REQUEST_PAYLOAD="-d '{\"username\": \"$FC_USERNAME\",\"password\": \"$FC_PASSWORD\"}'"

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

function usage () {
  echo "Invalid arguments"

  if [ "$1" = "username" ]; then
    echo "Username missing."
  fi
  if [ "$1" = "password" ]; then
    echo "Password missing."
  fi


  echo "\nusage: $0 <foundry_cloud-username> <foundry_cloud-password>"
  exit 2
}

# Validating Data
[[ -z "$FC_USERNAME" ]] && usage 'username'
[[ -z "$FC_PASSWORD" ]] && usage 'password'


echo 'Logging in to MAN Foundry Cloud.'

echo "curl"
sleep 15
CREDENTIALS=$(curl -s -d "{\"username\": \"$FC_USERNAME\",\"password\": \"$FC_PASSWORD\"}" \
     -H "Content-Type: application/json" -H "Accept: application/json" \
     $FC_REQUEST_HEADERS $FC_REQUEST_HTTP_METHOD $FC_LOGIN_URL)

ACCESS_TOKEN=$(echo $CREDENTIALS | python3 -c "import sys, json; print(json.load(sys.stdin)['access'])" 2>&1)
REFRESH_TOKEN=$(echo $CREDENTIALS | python3 -c "import sys, json; print(json.load(sys.stdin)['refresh'])" 2>&1)

echo $ACCESS_TOKEN
echo $REFRESH_TOKEN

FC_MONITORING_HOST="192.168.100.12:800"
FC_MONITORING_URL_PARAMETERS="fullscreen=true&location=2&user=$FC_USERNAME&pass=$FC_PASSWORD&accessToken=$ACCESS_TOKEN&refreshToken=$REFRESH_TOKEN"
FC_MONITORING_PATH="/dashboard?$FC_MONITORING_URL_PARAMETERS"
FC_MONITORING_URL=$FC_PROTOCOL$FC_MONITORING_HOST$FC_MONITORING_PATH

echo $FC_MONITORING_URL

xset s noblank
xset s off
xset -dpms

export DISPLAY=:0
unclutter -idle 0.5 -root &
/usr/bin/chromium-browser --noerrdialogs --disable-infobars --kiosk $FC_MONITORING_URL &
