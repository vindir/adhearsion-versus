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

In order to run the tests located in sipp/ sipp should be built from source or the TDB loadtesting VM should be started up.  The basic steps for installing SIPP are as below:

```
wget <SIPPDOWNLoADLINK>
sudo apt-get install libpcap-dev
./configure --with-pcap
make
sudo cp sipp /usr/local/bin/
```

## Run through the desired SIPP profiles
SIPP profiles for various tests are included in sipp/ to begin testing quickly. Sample run commands for the included tests can be found in MANUAL_TEST_COMMANDS

## Side Notes ##
```canreinvite = no``` should be set in asterisk to allow for the listener scenario to work properly

If not running the sipp tests from the VM under test, make certain to update the two .csv files and the sipp comands in MANUAL_TEST_COMMANDS appropriately for your environment
