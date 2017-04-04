# dotfiles

##useful commands to remember

how to connect to wifi network
```
nmcli general status
nmcli device wifi list
nmcli device wifi rescan
nmcli device wifi connect <SSID/BSSID> password <PASSWORD>
```

how to change volume lvl's
```
amixer sset Master Playback Volume 75% &> /dev/null
amixer set Master unmute
```

how to find system resource hogs
```
systemd-analyze blame
```


