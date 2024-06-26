#!/bin/sh

cp /opt/banner /etc/banner

currentValue=$(uci get system.@system[0].submodel)
restOfValue=$currentValue
restOfValue=${currentValue#*-}       # removes 'RM-'
restOfValue=$(echo "$currentValue" | sed -e 's/^[^-]*-[0-9]*//')
newFrequency="RM-2455"
newFreq="${newFrequency}${restOfValue}"

echo $currentValue
echo $restOfValue
echo $newFreq

#------Simpleconfig
# uci set simpleconfig.@general[0]=general
# uci set simpleconfig.@general[0].profilemode='general_profile'
# uci set simpleconfig.@general[0].general_wifimode='mesh'
# uci set simpleconfig.@general[0].mesh_id='simpleconfig'
# uci set simpleconfig.@general[0].password='DoodleSmartRadio'
# uci set simpleconfig.@general[0].distance='4000'
# uci set simpleconfig.@general[0].dhcp='client_enabled'
# uci set simpleconfig.@general[0].default_gui='0'
# uci set simpleconfig.@general[0].bandwidth='10'
# uci set simpleconfig.@general[0].channel='51'
# uci set simpleconfig.@general[0].freq_band=$newFreq   #'RM-2455-2KM-XW toto je nove .200.cislo'  #'RM-2455v3-2L-X'  RM-915v3-1L-X

#------System
uci set system.@system[0].submodel=$newFreq

#------wireless
uci set wireless.radio0.channel='51'
uci set wireless.radio0.chanbw='26'

#------save and apply
uci commit

/etc/init.d/socat restart
/etc/init.d/network restart
