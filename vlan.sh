#!/bin/sh
# Example in creating VLAN using IPRoute2
#
# Written by: Joemel John A. Diente <joemdiente@gmail.com>
# 

#Variables
ret=0
temp_file="vlan_info.temp"
embedded=0

#===No Argument
if [ "$#" -eq 0 ];
    then
        echo "Status: No arguments"
        exit 1
fi

#===Help
if [ "$1" = "help" ];
    then
        echo " Usage: "
        echo "      init = Loads 802.1Q Module, shows if module was loaded, creates a temp_file. "
        echo "      add    = create a vlan based on interface(arg2), and then sets VLAN ID(arg3)."
        echo "          eg. ./vlan.sh add eth0 10"
        echo "      remove = removes all created VLANs."
        echo "      deinit = cleans up then unloads module."
        echo ""
        echo " Description:"
        echo "      script tracks created VLANs stored in a file called $temp_file."
        echo ""
        echo " For Debugging Purposes:"
        echo "      clean  = removes temporary file. For first use, make sure to run clean."
        echo "      test   = prints out \"test page\". "
        exit 1
fi

#===Debugging Purposes Only
if [ "$1" = "clean" ];
    then 
        rm -f $temp_file
        ret=$?
        if [ $ret -eq 0 ];
            then
                echo "Status: $temp_file was deleted successfully"
        else
            echo "Warning: RM failed. Check $temp_file under $(pwd)"
        fi
    exit 1
fi

if [ "$1" = "test" ];
    then
        echo "==========test_page=========="
        echo ""
        if test -f "$temp_file";
            then
                echo "TEMP_FILE_INFO: $temp_file file exists"
                echo "===Start of $temp_file contents==="
                cat $temp_file
                echo "===End of $temp_file contents==="
            else
                echo "TEMP_FILE_INFO: $temp_file file does not exists"
        fi
        echo ""
        echo "==========test_page=========="
    exit 1
fi

#===Main
#Initialize
if [ "$1" = "init" ];
    then
        #Load 802.1Q VLAN Kernel Module
        echo "Status: loading 802.1q module"
        if [ $embedded -eq 1 ]
            then
                modprobe 8021q
        else
            sudo modprobe 8021q   
        fi

        #Check if Module was loaded
        lsmod | grep -q 8021q
        if [ $? -eq 0 ];
            then 
                echo "Status: Module was loaded"
        fi

        #Create temporary file
        touch $temp_file
        chmod 700 $temp_file
        if [ $? -eq 0 ];
            then
                echo "Status: $temp_file created"
        fi

        #List Interfaces Names from /sys/class/net
        echo ""
        echo "Interfaces Names:"
        echo "$(ls /sys/class/net)"
        echo "Hint: Use \"add <interface> <vlan_id>\""
    exit 1
fi

#Add
if [ "$1" = "add" ];
    then 
        #Check if temp_file exists
        test -f "$temp_file";
        if [ $? -ne 0 ];
            then
                echo "Error: $temp_file doesn't exists!"
                echo "You should run init first."
            exit 1
        fi
            
        #Check Arguments
        if [ -z "$2" ];
            then
                echo "Specify interface"
            exit 1
        fi

        if [ -z "$3" ];
            then
                echo "Specify VLAN ID"
            exit 1  
        fi

        # Check if interface is present
        if ip -br l | grep -qw "$2";
            then
                echo "Link is Present."
                echo "Creating VLAN.."
                
                #Proceed with creating VLAN
                if [ $embedded -eq 1 ]
                    then
                        ip link add link "$2" name vlan."$3" type vlan id "$3"
                else
                    sudo ip link add link "$2" name vlan."$3" type vlan id "$3"
                fi
                ret=$?

                if [ $ret -eq 0 ]        
                    then
                        echo "Status: Success vlan.$3 was created."

                        #Store removal script
                        echo "sudo ip link set dev vlan."$3" down" >> $temp_file
                        echo "sudo ip link delete vlan."$3"" >> $temp_file
                        echo "echo "Status: vlan.$3 removed."" >> $temp_file
                    exit 1
                else 
                    echo "Status: Failed creating VLAN!"
                    exit 1
                fi
        else    
            echo "Link is NOT Present"
            exit 1
        fi
    exit 1
fi

#Remove
if [ "$1" = "remove" ];
    then 
        #Check if temp_file exists
        if test -f "$temp_file";
            then
                #Check if temp_file has contents
                if [ -s $temp_file ];
                    then
                    #Run VLAN Cleanup
                    sudo sh $temp_file
                else
                    echo "No script in $temp_file. You should run program first."
                fi
            exit 1
        else
            echo "Error: $temp_file doesn't exists! You should run init first."
            exit 1
        fi
    exit 1
fi
#===End of Main

#===Any Other Argument
echo "Invalid Argument"
exit 1