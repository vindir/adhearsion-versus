# Welcome to Adhearsion Testing!

## Start Your Engines
Begin by setting up the telephony engines that will be tested. The included .env files for foreman are set up with the assumption that Telephony Dev Box will be used.

## Start Adhearsion
Start up Adhearsion for the telephony engine that is to be tested.

```
#Start up with FreeSwitch
foreman start --env freeswitch.env

#Start up with Asterisk
foreman start --env asterisk.env
```

# Set up SIPP

Once the desired Asterisk or FreeSwitch VM is up and running, log in and set up SIPP.

```
wget <SIPPDOWNLoADLINK>
sudo apt-get install libpcap-dev
./configure --with-pcap
make
sudo cp sipp /usr/local/bin/
```

## Run through the desired SIPP profiles
SIPP profiles for various tests are included in sipp/ to begin testing quickly. Sample run commands for the included tests can be found in sipp/runlist.txt

## Side Notes ##
```canreinvite = no``` should be set in asterisk to allow for the listener scenario to work properly

