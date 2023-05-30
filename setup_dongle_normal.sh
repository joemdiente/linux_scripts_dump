echo "setting up Dell Hub ETH to 192.168.137.5"
sudo ip link set enx0c379676d506 down
sudo ip addr add 192.168.137.5/24 dev enx0c379676d506
sudo ip link set enx0c379676d506 up

echo "setting up UGreen ETH to 192.168.137.6"
sudo ip link set enxf8e43bedf19d down
sudo ip addr add 192.168.137.6/24 dev enxf8e43bedf19d
sudo ip link set enxf8e43bedf19d up

