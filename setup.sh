#!/usr/bin/env bash

echo "adding unstable channel...."
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --update

# create host-variable file
read -p "Enter the hostname: " workstationName

# Create /etc/nixos/host-variables.nix with the provided hostname
cat <<EOF | sudo tee /etc/nixos/host-variables.nix > /dev/null
{
  workstationName = "$workstationName";
}
EOF

echo "Hostname saved to /etc/nixos/host-variables.nix"
