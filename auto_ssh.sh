# 
#
#
#   This scripts setups your target board for PublicKeyAuthentication using OpenSSH
#
#
#
#
#

echo "This should be run where "target/" folder can be found"

echo "Clearing pre-existing keys"
rm ./id_rsa*
echo "Clearing pre-setup"
rm -rf ./target/root/.ssh/

# Pre-generate its own ssh keys
ssh-keygen -t rsa -f id_rsa

echo "Creating target .ssh directory"
mkdir ./target/root/.ssh

# This is very important!!
echo "Setting Permission and then copy keys"
chmod 700 ./target/root/.ssh
rsync -avP ./id_rsa* ./target/root/.ssh

echo "Creating target authorized_keys"
touch ./target/root/.ssh/authorized_keys

# This is very important!!
chmod 600 ./target/root/.ssh/authorized_keys

echo "Copying this PC RSA PublicKey to target authorized_keys"
cat ~/.ssh/id_rsa.pub >> target/root/.ssh/authorized_keys

echo "Done"