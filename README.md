This script will do the heavy lifting and build an ElectrumX node for Lynx on Debian 11. This single script is all you need for a Lynx ElectrumX server. When complete, you will have a full Lynx node (with the built-in miner turned off) and an ElectrumX server automatically configured and running. In addition, Certbot will automatically renew your SSL certificates every ~70 days.

**For complete instructions on how to use this script, [please consult the documentation](https://docs.getlynx.io/electrumx/build-instructions).**

Many thanks to [Mad Cat Mining](https://mcmpool.eu) for assistance with the recent updates to the Electrum installer portion of this build.

	wget -O - https://electrumx.getlynx.io/ | bash -s electrum.domain.com
	
This script only supports Debian 11.
