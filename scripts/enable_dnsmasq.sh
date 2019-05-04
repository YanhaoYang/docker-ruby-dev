#!/bin/zsh

# ----------------------
# installing dnsmasq and enable daemon
# ----------------------
brew install dnsmasq
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons

# ----------------------
# adding resolver for dev domain
# ----------------------
[ -d /etc/resolver ] || sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'

# ----------------------
# configuring dnsmasq
# ----------------------
sudo mkdir -p $(brew --prefix)/etc/
cat > $(brew --prefix)/etc/dnsmasq.conf <<-EOF
listen-address=127.0.0.1
address=/.test/127.0.0.1
# keep nameserver order of resolv.conf
strict-order
EOF

# ----------------------
# launching dnsmasq
# ----------------------
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

# sudo launchctl stop homebrew.mxcl.dnsmasq
# sudo launchctl start homebrew.mxcl.dnsmasq
