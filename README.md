# Installation Guide

## Download Image

Download an image of Raspbian outside of China if you want to finish this tutorial in less than 3 hours.

## Flashing Raspian to an SD card (macos)

Identify the disk (not the partition) of your SD card, e.g. `disk4`, not `disk4s1`.

```shell
diskutil list
```

Unmount your SD card by using the disk identifier, to prepare it for copying data:

```shell
diskutil unmountDisk /dev/disk<disk# from diskutil>
```

Copy the data to your SD card:

```shell
sudo dd bs=1m if=image.img of=/dev/rdisk<disk# from diskutil> conv=sync
```

This will take a few minutes, depending on the image file size. You can check the progress by sending a SIGINFO signal (press Ctrl+T).

After the `dd` command finishes, eject the card:

```shell
sudo diskutil eject /dev/rdisk<disk# from diskutil>
```

## Setup

### Install Required Packages

```bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install xdotool unclutter sed -y
```

### Setup WiFi connection to Hidden Network

```bash
echo "\n\nnetwork={
    scan_ssid=1
    ssid="ssid"
    psk="pw"
    key_mgmt=WPA-PSK
}" >> /etc/wpa_supplicant/wpa_supplicant.conf
```

### Change Hostname

echo "raspberrypi-p19-f56" > /etc/hostname

### Download and Install the Setup script from that repo here

```bash
wget -O - https://raw.githubusercontent.com/marcfreiheit/zorc-foundry-displays/master/install.sh | bash
```

### Misc

- Enable SSH access
