# Run this file once. It will restart to finish the MacOS update
# If the developer tools are already installed, it does nothing. So it is safe to run it again.

# Get the names from HOSTNAME env, which comes from DNS reverse lookup
sudo scutil --set ComputerName $HOSTNAME
sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $HOSTNAME

# This sets the system clock to UTC, although the System Preferences UI won't show it.
# sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime
# This seems better than the above...
sudo systemsetup -settimezone GMT

# This disables the Wifi Network
networksetup -setairportpower en1 off

# This enables SSH Logins
sudo systemsetup -setremotelogin on

# This enables screen sharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# This system should never sleep
sudo systemsetup -setcomputersleep Never
sudo systemsetup -setharddisksleep Never
sudo systemsetup -setdisplaysleep 15
sudo systemsetup -setrestartpowerfailure on

defaults write -g KeyRepeat -int 5
defaults write -g InitialKeyRepeat -int 15
defaults write -g com.apple.mouse.scaling 2.5

if xcode-select -print-path &> /dev/null
then
   echo "XCode CLI tools already installed"
else
   # This magical file tells softwareupdate that its nonexistent CLI Tools install is out of date
   sudo touch "/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
fi

softwareupdate -l
sudo softwareupdate -ia
sudo softwareupdate --schedule off

sudo chown admin /usr/local
sudo chgrp admin /usr/local

sudo reboot now
