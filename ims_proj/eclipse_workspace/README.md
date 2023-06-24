#ims_proj GUI

**Setup:**
SAMA5D4 Xplained Pro 
    -Buildroot config (sama5d4_xplained_graphics_defconfig) + 
        *JSON_FOR_MODERN_CPP*
        *PARTED*
        All config with *PYTHON_JSON*
        *PYTHON_REQUESTS*
    -SDK Location:
        -/opt/
TM5000 Touchscreen Panel

**Tools used:**
Eclipse CDT IDE
Ensemble Graphics Toolkit
    -./autogen.sh
    -./configure --prefix=/opt/arm-buildroot-linux-gnueabihf_sdk-buildroot --exec-prefix=/opt/arm-buildroot-linux-gnueabihf_sdk-buildroot
    -./make && ./make install
Microchip Graphics Composer

**Testing:**
1. snipe_test_docker/start_snipe_it.sh.
    -run deploy_test_snipe_it.sh if not yet deployed.
2. open eclipse workspace
3. configure host: 192.168.137.1 target 192.168.137.101
    -At first run, ensure ssh and scp works. 
        -Public Key Authentication:
            -copy host's publickey to target ~/.ssh/known_hosts (through vi terminal)
            -edit target /etc/ssh/sshd_config:
                *PubkeyAuthentication yes*
                *PermitEmptyPasswords yes*
                *PasswordAuthentication no*
                *PermitRootLogin yes*
4. Buid and run.
    -should already connect to target and stop egt-demo then run program.

##Helpful Links
https://linux4sam.github.io/egt-docs/
https://github.com/linux4sam/egt-samples-contribution
https://linux4sam.github.io/egt-docs/mgc.html