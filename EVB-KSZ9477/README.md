These are scripts I have created when testing EVB-KSZ9477.
Transfer scripts via busybox TFTP:

Run:
    #tftp -g -r FILE HOST [PORT]
        -g = Get
        -r = File from Remote
        FILE = filename or directory
        HOST = IP address or Hostname
        PORT = TFTP Server Port
        
Example:
    tftp -g -r ksz9477_hsr.sh 192.168.137.1