#!/bin/sh

cp /opt/banner /etc/banner

#------Simpleconfig
# uci set simpleconfig.@general[0]=general
# uci set simpleconfig.@general[0].profilemode='general_profile'
# uci set simpleconfig.@general[0].general_wifimode='mesh'
# uci set simpleconfig.@general[0].mesh_id='simpleconfig'
# uci set simpleconfig.@general[0].password='DoodleSmartRadio'
# uci set simpleconfig.@general[0].distance='4000'
# uci set simpleconfig.@general[0].dhcp='client_enabled'
# uci set simpleconfig.@general[0].default_gui='0'
uci set simpleconfig.@general[0].bandwidth='10'
uci set simpleconfig.@general[0].channel='51'
uci set simpleconfig.@general[0].freq_band='RM-2455-2KM-XW'  #'RM-2455v3-2L-X'

#------System
uci set system.@system[0].submodel='RM-2455-2KM-XW'

#------wireless
uci set wireless.radio0.channel='51'
uci set wireless.radio0.chanbw='10'

#------save and apply
uci commit

/etc/init.d/socat restart
/etc/init.d/network restart
