#!/bin/bash

# subnet="10.223.0"
# ip_file="used_ips.txt"

USERNAME="root"
PASSWORD=""

connection_name="DoodleLabNet"
interface_name="eno1"

REMOTE_FILE_PATH="/opt/factoryreset.sh"   
LINE_TO_ADD1="cp /opt/banner /etc/banner" 
LINE_TO_ADD2="exit 0"

#-------------------User input---------------------------------

read -p "Do you want to see output and all the info? (y/n): " choice

read -p "Enter the drone IP: " CURRENT_DRONEIP
echo

read -p "Enter the Doodle lab radio IP: " CURRENT_MESHIP
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
ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes "$USERNAME@$CURRENT_MESHIP" exit
if [ $? -eq 0 ]; then
    echo "SSH connection to $USERNAME@$CURRENT_MESHIP was successful."
    ip_addresses+=("$ip")
else
    echo "SSH connection to $USERNAME@$CURRENT_MESHIP failed."
fi
sshpass -p "" scp "banner" "$USERNAME@$CURRENT_MESHIP:/opt"

# ssh "$USERNAME@$CURRENT_MESHIP" "sed -i '\$d' $REMOTE_FILE_PATH"
# ssh "$USERNAME@$CURRENT_MESHIP" "echo '$LINE_TO_ADD1' >> $REMOTE_FILE_PATH"
# ssh "$USERNAME@$CURRENT_MESHIP" "echo '$LINE_TO_ADD2' >> $REMOTE_FILE_PATH"

ssh "$USERNAME@$CURRENT_MESHIP" 'bash -s' < radio_communication_setup.sh
# done

# if [ "$choice" == "y" ]; then
#   echo "This is the list of mesh radios: $ip_addresses"
# fi

# Save the updated used IPs to the file
# printf "%s\n" "${used_ips[@]}" > "$ip_file"