#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#
# dpkg-reconfigure locales # Not needed for Linode, only discount VPS vendors. Used to change region & locale coding. UTF-8 is recommended.
#
# Only run this script as root on a freshly installed Debian 11 target VPS
# In order for Electrum to configure the SSL paths and name, the following value is required. 
# Please be sure to configure your DNS before running this script
host="electrum.logware.us"
electrumSSLPort="50002"
electrumWSSPort="50004"
#
lconf="/home/lynx/.lynx/lynx.conf"
if [ -f "$lconf" ] # This block executes the second time the script is run.
then

rpcuser="$(sed -ne 's|[\t]*rpcuser=[\t]*||p' $lconf)" # Pull the RPC values from the live lynx.conf file.
rpcpassword="$(sed -ne 's|[\t]*rpcpassword=[\t]*||p' $lconf)" # Pull the RPC values from the live lynx.conf file.
rpcport="$(sed -ne 's|[\t]*rpcport=[\t]*||p' $lconf)" # Pull the RPC values from the live lynx.conf file.

echo "
DB_DIRECTORY=/db
DAEMON_URL=http://$rpcuser:$rpcpassword@127.0.0.1:$rpcport/
COIN=Lynx
DB_ENGINE=rocksdb
SSL_CERTFILE=/etc/letsencrypt/live/$host/fullchain.pem
SSL_KEYFILE=/etc/letsencrypt/live/$host/privkey.pem
SERVICES=ssl://:$electrumSSLPort,wss://:$electrumWSSPort,rpc://
REPORT_SERVICES=wss://$host:$electrumWSSPort,ssl://$host:$electrumSSLPort
HOST=
" > /etc/electrumx.conf

sed -i 's/disablebuiltinminer=0/disablebuiltinminer=1/' $lconf
systemctl restart lynxd


insert="iptables -A INPUT -p tcp --dport $electrumSSLPort -j ACCEPT
iptables -A INPUT -p tcp --dport $electrumWSSPort -j ACCEPT"
sed -i "s/22566/22566\n$insert/" /usr/local/bin/lyf.sh # Drop in the Electrum ports into the firewall script.
sed -i "s/22 /5829 /" /usr/local/bin/lyf.sh # change port 22 to 5829 for a specific VPS vendor. Comment this when not needed.

# In order for Certbot to ping the VPS during the verification step, 
# the firewall must be wide open.
iptables -F
sleep 3 # Give the VPS some breathing space.
apt update -y && apt install certbot -y
sleep 3 # Give the VPS some breathing space.
# Non-interactive. Replace the domain name and email value on the next line.
certbot certonly --standalone -n -d $host -m domains@getlynx.io --agree-tos
# Display the path the the created cert files.
certbot certificates
# The SSLs need ownership changed to allow access.
chown -R electrumx:electrumx /etc/letsencrypt
systemctl restart electrumx && journalctl -u electrumx -f -n 500


else # This block executes the first time the script is run.

apt-get update -y && apt-get upgrade -y # Get the OS up-to-date, first thing.
apt-get install htop nano iptables git certbot python3-pip gcc g++ python-dev librocksdb-dev build-essential libsnappy-dev zlib1g-dev libbz2-dev libgflags-dev liblz4-dev libzstd-dev curl -y
apt-get dist-upgrade -y && apt-get auto-remove -y # Update to the latest distro and remove unused packages.
cd && git clone https://github.com/MadCatMining/electrumx-installer.git
cd electrumx-installer/ && ./bootstrap.sh
# Purge a lot of space from the coins file, plus the out of date Lynx entry.
sed -i '/class Verge(Coin):/Q' /usr/local/lib/python3.9/dist-packages/electrumx/lib/coins.py
# Append the new Lynx coins.py file
echo "
# https://docs.getlynx.io/electrumx/electrumx
class Lynx(Coin):
	NAME = \"Lynx\"
	SHORTNAME = \"LYNX\"
	NET = \"mainnet\"
	P2PKH_VERBYTE = bytes.fromhex(\"2d\")
	P2SH_VERBYTES = (bytes.fromhex(\"16\"),)
	WIF_BYTE = bytes.fromhex(\"ad\")
	GENESIS_HASH = ('984b30fc9bb5e5ff424ad7f4ec193053'
			'8a7b14a2d93e58ad7976c23154ea4a76')
	DESERIALIZER = lib_tx.DeserializerSegWit
	TX_COUNT = 1
	TX_COUNT_HEIGHT = 1
	TX_PER_BLOCK = 1
	RPC_PORT = 9332
	PEER_DEFAULT_PORTS = {'t': '$electrumWSSPort', 's': '$electrumSSLPort'}
	PEERS = [
		'electrum.getlynx.io s t',
		'electrum.getlynx.club s t',
		'electrum.logware.io s t',
		'electrum.logware.club s t',
		'electrum.logware.us s t',
	]
	REORG_LIMIT = 5000
" >> /usr/local/lib/python3.9/dist-packages/electrumx/lib/coins.py
wget -O - -q https://getlynx.io/install.sh | bash -s "mainnet" "0.50" "900"


fi
