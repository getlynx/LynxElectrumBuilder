This script will do the heavy lifting and build an ElectrumX node for Lynx on Debian 11. There is no need to install Lynx first; this single script is all you need for a Lynx Electrum X server.

It would be best if you only executed this script on a freshly installed instance of Debian 11. Furthermore, we recommend a public VPS vendor (i.e., Linode, Digital Ocean, etc.) so that others can access the public Electrum.

Running this script is a two-step process. First, run it as the root user once, wait for it to complete, and reboot the VPS. Then, log in as the lynx user (the root account gets locked for security reasons). Then, use the command 'sudo su' to access the root account. Then, rerun the script. 

$ wget -O - https://raw.githubusercontent.com/getlynx/LynxElectrumBuilder/main/build.sh | bash -s electrum.mydomain.com

Many thanks to Mad Cat Mining (https://mcmpool.eu) for assistance with the recent updates to the Electrum installer portion of this build. This build script also uses the LynxCI script to complete the installation of Lynx. 

This script only supports Debian 11.
