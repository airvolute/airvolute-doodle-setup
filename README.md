# drone_doodle_setup

Currently there are three files:

1. code to run: initial_setup.sh
2. banner: Airvolute logo
3. set static ip: setting_static_ip.sh

## How to use

Run:
```
sudo ./initial_setup.sh
```

1. First you need to enter your psw because of sudo command
2. Enter IP of a drone from following subnet 10.223.0.0/16
3. Enter IP address of the mesh radio in the drone

In the code you need to change interface_name in initial_setup.sh. However that is just one time change for all the drones.

# Important

1. After executing the script, the radio setup is implemented. However, it is not immediately visible in the Web GUI. The changes become visible in the GUI only after turning the radio off and then on again.

2. Future Fix: To change the frequency of the radio, it is necessary to manually locate the value in /etc/config/simpleconfig and then include it in the radio_communication_setup script.