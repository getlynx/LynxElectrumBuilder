This script will do the heavy lifting and build an ElectrumX node for Lynx on Debian 11. This single script is all you need for a Lynx Electrum X server. When complete, you will have a full Lynx node (with the built-in miner turned off) and an Electrum server automatically configured and running. In addition, Certbot will automatically renew your SSL certificates every ~70 days.

It would be best if you only executed this script on a freshly installed instance of Debian 11. Furthermore, we recommend a public VPS vendor (i.e., Linode, Digital Ocean, etc.) so that others can access the public Electrum.

Running this script is a five-step process:
1. Adjust your DNS for the hostname. Doing so will allow Certbot to generate your SSL certificate quickly.
2. Run it as the root user once, wait for it to complete, and reboot the VPS.
3. Log in as the lynx user (the root account gets locked for security reasons).
4. Use the command 'sudo su' to access the root account.
5. Rerun the script.

	wget -O - https://raw.githubusercontent.com/getlynx/LynxElectrumBuilder/main/build.sh | bash -s electrum.mydomain.com

Many thanks to Mad Cat Mining (https://mcmpool.eu) for assistance with the recent updates to the Electrum installer portion of this build. This build script also uses the LynxCI script to complete the installation of Lynx. 

This script only supports Debian 11.
