# Lynx Electrum Builder
This script will do the heavy lifting and build an ElectrumX node for Lynx on Debian 11. There is no need to install Lynx first; this single script is all you need for a Lynx Electrum X server.

It would be best if you only executed this script on a freshly installed instance of Debian 11. Furthermore, we recommend a public VPS vendor (i.e., Linode, Digital Ocean, etc.) so that others can access the public Electrum.

Many thanks to Mad Cat Mining (https://mcmpool.eu) for assistance with the recent updates to the Electrum installer portion of this build. This build script also uses the LynxCI script to complete the installation of Lynx. 

Installation notes: As the root user, execute this script once. Then, after the VPS reboots, rerun the script to complete the configuration of Electrum. The Electrum log will display when it is complete, showing the syncing process.

Line 9 requires the intended hostname for your public Electrum. Be sure to update this value and adjust your DNS accordingly. The DNS must be correct, so the built-in SSL certificate registration process completes without error.

This script only supports Debian 11.
