#
#  This script setups your target board for PublicKeyAuthentication using DROPBEAR client and server
#  It should be placed where ./target/ folder is located.
#  Host setup:
#  install dropbear
#   This script is for dropbear client and Dropbear Server
#

echo "This script should be run where "target/" folder can be found"

# Generate dropbear key (contains private and public key)
dropbearkey -t rsa -s 4096 -f ./test_rsa_dropbear_key

# Get dropbear public key from ./test_rsa_drop_key and store it to ./target/root/.ssh/authorized_keys
mkdir ./target/root/.ssh/
echo "Get public key only"
echo "Install key to target"
# CDifficult to automate
dropbearkey -y -f ./test_rsa_dropbear_key 
echo " "
echo " "
echo "Copy and Paste line from \"ssh-rsa\" up to \"test@test\" Install key to target"
echo "Press enter and the CTRL^D"
echo " "
echo " "
cat >> ./target/root/.ssh/authorized_keys 

# Disallow root login using password (pubkey authentication only)
mkdir ./target/etc/default/
echo "DROPBEAR_ARGS=\"-s\"" > ./target/etc/default/dropbear

echo "Done configuring buildroot project"
echo " "
echo " " 
echo "Note:==========================="
echo "Run the command to the target device: "
echo "   $ chown root:root /root /root/.ssh /root/.ssh/authorized_keys"
echo "   $ /etc/init.d/S50dropbear restart"
echo " "
echo "Connect to the target device using the command: "
echo "  $ dbclient -i ./test_rsa_dropbear_key root@192.168.137.98"

echo "Done"