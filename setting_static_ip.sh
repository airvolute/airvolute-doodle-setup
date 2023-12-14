#!/bin/bash

connection_name="$1"
interface_name="$2"
ip_address="$3"
choice="$4"

main_connection_ip() {

# Find and delete
connections=$(nmcli -t -f NAME,TYPE connection show | awk -F: '$2=="802-3-ethernet" {print $1}')

if [ -z "$connections" ]; then
  if [ "$choice" == "y" ]; then
  echo "No Ethernet wired connections found."
  fi
else
  if [ "$choice" == "y" ]; then
  echo "Deleting Ethernet wired connections:"
  fi
  for connection in $connections; do
    if [ "$connection" == "DoodleLabNet" ]; then
      if [ "$choice" == "y" ]; then
      echo "  Deleting: $connection"
      fi
      nmcli connection delete "$connection"
    fi
  done
  if [ "$choice" == "y" ]; then
  echo "Deleted all Ethernet wired connections."
  fi
fi
sleep 3

if nmcli connection show --active | grep -q "$connection_name"; then
  if [ "$choice" == "y" ]; then
  echo "Connection '$connection_name' already exists."
  fi
else
  # Add a new wired connection
  if [ "$choice" == "y" ]; then
  echo "Adding a new wired connection '$connection_name'..."
  fi
  sudo -S <<< 'dronecore' nmcli connection add con-name "$connection_name" ifname "$interface_name" type ethernet ip4 "$ip_address/16"

  if [ $? -eq 0 ]; then
    if [ "$choice" == "y" ]; then
    echo "New connection '$connection_name' added successfully."
    fi
  else
    if [ "$choice" == "y" ]; then
    echo "Failed to add a new connection."
    fi
    exit 1
  fi
fi

if [ "$choice" == "y" ]; then
echo "Bringing up connection '$connection_name'..."
fi
sudo -S <<< 'dronecore' nmcli connection up "$connection_name"

if [ $? -eq 0 ]; then
  echo "Connection '$connection_name' is now up."
else
  echo "Failed to bring up connection '$connection_name'."
fi

}

main_connection_ip
