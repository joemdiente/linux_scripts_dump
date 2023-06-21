#
# Transfer .py and .cfg to target 192.168.137.101 root dir
#
scp -r ./*.py root@192.168.137.101:/root
scp -r ./*.cfg root@192.168.137.101:/root