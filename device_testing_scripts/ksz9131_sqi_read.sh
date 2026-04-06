#!/bin/bash

# Check if both arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <INTERFACE> <PHY_ADDR>"
    echo "Example: $0 eth0 1"
    exit 1
fi

# Check if phytool is installed
if ! command -v phytool &> /dev/null; then
    echo "Error: phytool is not installed or not in PATH."
    exit 1
fi

# Assign arguments to variables
INTERFACE=$1
PHY_ADDR=$2

echo "Monitoring SQI values every 1 second. Press [CTRL+C] to stop."
echo "Starting SQI Measurement for Pairs A-D on $INTERFACE (PHY $PHY_ADDR)..."
echo "----------------------------------------------------------------------"

# Define channel letters for output
CHANNELS=("A" "B" "C" "D")

while true; do
    # Move cursor to the top-left corner
    printf "\033[H\033[J"
    echo "SQI Monitor - Interface: $INTERFACE | PHY: $PHY_ADDR"
    echo "Last Updated: $(date +"%H:%M:%S")"
    echo "----------------------------------------------------------------------"
    printf "%-10s | %-10s | %-10s | %-10s\n" "Channel" "Raw Hex" "Worst" "Actual"
    echo "----------------------------------------------------------------------"

    # Loop through indexes 0 to 3
    for i in {0..3}; do
        LETTER=${CHANNELS[$i]}
        
        # Calculate Data for DCQ Control Register:
        # Bit 15: Enable Capture (0x8000)
        # Bits 1:0: Channel selection (0=A, 1=B, 2=C, 3=D)
        CTRL_DATA=$(printf "0x%04X" $((0x8000 | i)))
        
        echo "Configuring Channel $LETTER..."

        # 1. Enable DCQ read capture in DCQ CONTROL REGISTER
        phytool write "$INTERFACE/$PHY_ADDR/0x0D" 0x0001 # Address; # DEVAD = 1
        phytool write "$INTERFACE/$PHY_ADDR/0x0E" 0x00E6 # DCQ Control Register (1.230)
        phytool write "$INTERFACE/$PHY_ADDR/0x0D" 0x4001 # Data, No Post Increment; # DEVAD = 1
        phytool write "$INTERFACE/$PHY_ADDR/0x0E" "$CTRL_DATA" # Set DCQ Read Capture; Set Channel i.

        # 2. Start measurement in DCQ CONFIGURATION REGISTER (Data 0x146D)
        phytool write "$INTERFACE/$PHY_ADDR/0x0D" 0x0001 # Address; # DEVAD = 1
        phytool write "$INTERFACE/$PHY_ADDR/0x0E" 0x00E7 # DCQ Configuration Register (1.231)
        phytool write "$INTERFACE/$PHY_ADDR/0x0D" 0x4001 # Data, No Post Increment; # DEVAD = 1
        phytool write "$INTERFACE/$PHY_ADDR/0x0E" 0x146D # No scaling of MSE value

        # 3. Read out result from DCQ SQI REGISTER
        phytool write "$INTERFACE/$PHY_ADDR/0x0D" 0x0001 # Address; # DEVAD = 1
        phytool write "$INTERFACE/$PHY_ADDR/0x0E" 0x00E4 # DCQ SQI Register (1.228)
        phytool write "$INTERFACE/$PHY_ADDR/0x0D" 0x8001 # Data, post increment on reads and writes; # DEVAD = 1    
        RAW_SQI_VALUE=$(phytool read "$INTERFACE/$PHY_ADDR/0x0E") # Store DCQ SQI Register Value in "SQI_VALUE"
        # Bits 7:5 (Worst Case): Shift right 5, then mask with 7 (bin 111)
        WORST=$(( ($RAW_SQI_VALUE >> 5) & 0x07 ))
        
        # Bits 3:1 (Actual Value): Shift right 1, then mask with 7 (bin 111)
        ACTUAL=$(( ($RAW_SQI_VALUE >> 1) & 0x07))
        # Print row
        printf "Pair %-5s | %-10s | %-10s | %-10s\n" "$LETTER" "$RAW_SQI_VALUE" "$WORST" "$ACTUAL"
    done
    
    echo "----------------------------------------------------------------------"
    echo "Press [CTRL+C] to exit."
        
    # Wait for 1 second before the next poll
    sleep 1
done

echo "Measurement Complete."