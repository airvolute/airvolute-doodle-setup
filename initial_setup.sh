#!/bin/bash

# subnet="10.223.0"
# ip_file="used_ips.txt"

cd "$(dirname "$0")"

USERNAME="root"
PASSWORD=""

connection_name="DoodleLabNet"
interface_name="eth1" #"eth1" "eno1"

REMOTE_FILE_PATH="/opt/factoryreset.sh"   
LINE_TO_ADD1="cp /opt/banner /etc/banner" 
LINE_TO_ADD2="exit 0"

chmod +x setting_static_ip.sh
chmod +x radio_communication_setup.sh

#-------------------User input---------------------------------
if [ -z "$1" ]; then
    read -p "Do you want to see output and all the info? (y/n): " choice
else
    choice=$1
fi

if [ -z "$2" ]; then
    read -p "Enter the drone IP: " CURRENT_DRONEIP
else
    CURRENT_DRONEIP=$2
fi

if [ -z "$3" ]; then
    read -p "Enter the Doodle lab radio IP: " CURRENT_MESHIP
else
    CURRENT_MESHIP=$3
fi

echo "Drone IP: $CURRENT_DRONEIP"
echo "Doodle Lab Radio IP: $CURRENT_MESHIP"
echo

#-------------------Set main IP--------------------------------
if [ "$choice" == "y" ]; then
  ./setting_static_ip.sh $connection_name $interface_name $CURRENT_DRONEIP $choice
else
  ./setting_static_ip.sh $connection_name $interface_name $CURRENT_DRONEIP $choice >/dev/null
fi

#----------------Doodle lab radio-----------------------

# ip_addresses_search=$(arp | grep -v "(incomplete)" | grep -oP '10\.223\.\d+\.\d+')
# ip_addresses_search=($CURRENT_MESHIP)

# for ip in $ip_addresses_search; do

# Prevent the script  from hanging on connection prompt 
ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o BatchMode=yes "$USERNAME@$CURRENT_MESHIP" exit

if ssh "$USERNAME@$CURRENT_MESHIP" 'test -f /opt/banner'; then
    echo "The banner file already exists on the remote device. Exiting script."
    # exit 1
else
    scp "banner" "$USERNAME@$CURRENT_MESHIP:/opt"
    ssh "$USERNAME@$CURRENT_MESHIP" "sed -i '\$d' $REMOTE_FILE_PATH"
    ssh "$USERNAME@$CURRENT_MESHIP" "echo '$LINE_TO_ADD1' >> $REMOTE_FILE_PATH"
    ssh "$USERNAME@$CURRENT_MESHIP" "echo '$LINE_TO_ADD2' >> $REMOTE_FILE_PATH"
fi

ssh "$USERNAME@$CURRENT_MESHIP" 'ash -s' < radio_communication_setup.sh
#-------using sshpass
# ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes "$USERNAME@$CURRENT_MESHIP" exit
# if [ $? -eq 0 ]; then
#     echo "SSH connection to $USERNAME@$CURRENT_MESHIP was successful."
#     ip_addresses+=("$ip")
# else
#     echo "SSH connection to $USERNAME@$CURRENT_MESHIP failed."
# fi

# # Check if the 'banner' file exists on the remote device
# if sshpass -p "$PASSWORD" ssh "$USERNAME@$CURRENT_MESHIP" 'test -f /opt/banner'; then
#     echo "The banner file already exists on the remote device. Exiting script."
#     # exit 1
# else
#     sshpass -p "" scp "banner" "$USERNAME@$CURRENT_MESHIP:/opt"
#     ssh "$USERNAME@$CURRENT_MESHIP" "sed -i '\$d' $REMOTE_FILE_PATH"
#     ssh "$USERNAME@$CURRENT_MESHIP" "echo '$LINE_TO_ADD1' >> $REMOTE_FILE_PATH"
#     ssh "$USERNAME@$CURRENT_MESHIP" "echo '$LINE_TO_ADD2' >> $REMOTE_FILE_PATH"
# fi
#-----------
# ssh "$USERNAME@$CURRENT_MESHIP" 'ash -s' < radio_communication_setup.sh
# done

# if [ "$choice" == "y" ]; then
#   echo "This is the list of mesh radios: $ip_addresses"
# fi

# Save the updated used IPs to the file
# printf "%s\n" "${used_ips[@]}" > "$ip_file"
