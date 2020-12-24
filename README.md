# dotfiles

macOS dotfiles🍻

## Disable Spotlight Index

```
# https://gist.github.com/csrutil/b2cce932dda8b226f37be2880215aee6
sudo pmset -c sleep 30
sudo pmset -c displaysleep 30
sudo pmset -c disksleep 30
sudo pmset -c hibernatemode 0
sudo pmset -c standby 0
sudo pmset -c autopoweroff 0
sudo pmset -c tcpkeepalive 1

# disable the Spotlight indexes
sudo mdutil -a -i off

# change host name
sudo scutil --set HostName mini
sudo scutil --set ComputerName mini
sudo scutil --set LocalHostName mini

sudo spctl --master-disable
```


## Fonts

https://github.com/googlefonts/Inconsolata
https://github.com/vjpr/monaco-bold
