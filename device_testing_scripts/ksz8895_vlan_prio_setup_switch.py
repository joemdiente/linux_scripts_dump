import spidev
import random

# Initialize SPI
spi = spidev.SpiDev()

# Open bus 0, device (CS) 3 -> /dev/spidev0.3 (EDS2 Connector)
spi.open(0, 3)

# Settings
spi.max_speed_hz = 1000000  # 1 MHz
spi.mode = 0b00             # SPI Mode 0 (CPOL=0, CPHA=0)
spi.bits_per_word = 8       # Standard 8-bit communication

def print_list_in_hex(x,y):
    for z in y:
        print(f"[dbg]rd_reg(0x{x:02X}): 0x{z:02X}")

### Switch Read/Write Functions
    # in: reg_start_addr = start address of switch register
    #     count = number of reads
    # out: return value = list
def ksz8895_reg_read(reg_start_addr, count):

    # Register read command (0x03)
    read_xfer = [0x03]

    # append read address
    read_xfer.append(reg_start_addr)

    # append dummy bytes based on read count
    for x in range(count):
        read_xfer.append(0x00)

    # xfer2 keeps CS (Chip Select) asserted throughout the transaction
    # Input must be a list, even for a single byte
    resp = spi.xfer2(read_xfer)

    # Return index 2 up to last, index 0 and 1 are garbage.
    return resp[2:] 

# in: reg_start_addr = start address of switch register
#     value = list of values to write. 
# out: none
def ksz8895_reg_write(reg_start_addr, val):

    # Register write command (0x02)
    write_xfer = [0x02]

    # # Append write address
    write_xfer.append(reg_start_addr)

    # # Append data to write (use extend to prevent list within a list)
    write_xfer.extend(val)

    # xfer2 keeps CS (Chip Select) asserted throughout the transaction
    # Input must be a list, even for a single byte
    spi.xfer2(write_xfer)

    # No return
def ksz8895_reg_write_verify(reg_addr, val):
    ksz8895_reg_write(reg_addr, val)
    print(f"[dbg](0x{reg_addr:02X}) wr: 0x{val[0]:02X} == rd: 0x{ksz8895_reg_read(reg_addr, 1)[0]:02X}")

######## Start of Main Application #####
#
# KSZ8895 802.1p-based priority test
# EVB-KSZ8895 EDS2
# [1]  [3]
# [2]  [4]
#  1 - Host
# 2,4 - Client
#########################################

# Set all ports to four-queue split
ksz8895_reg_write_verify(0xB1, [0x02])
ksz8895_reg_write_verify(0xC1, [0x02])
ksz8895_reg_write_verify(0xD1, [0x02])
ksz8895_reg_write_verify(0xE1, [0x02])
ksz8895_reg_write_verify(0xF1, [0x02])

# Configure Client Ports
print("Port 2 and 4 802.1p enable = 1")
ksz8895_reg_write_verify(0x20, [0x20]) 
ksz8895_reg_write_verify(0x40, [0x20]) 

print("Port 2 and 4 four Queue Split Enable = 1")
ksz8895_reg_write_verify(0xC1, [0x02])
ksz8895_reg_write_verify(0xE1, [0x02])

#Configure Host Port
print("Port 1 802.1p enable = 1")
ksz8895_reg_write_verify(0x10, [0x20]) 

print("Port 1 four Queue Split Enable = 1")
ksz8895_reg_write_verify(0xB1, [0x02])

print(" Port 1 Queue 3 Strict Priority") # Strict Priority
ksz8895_reg_write_verify(0xB2, [0x00])

print(" Port 1 Queue 2 4 packets")
ksz8895_reg_write_verify(0xB2, [0x84]) # Reflect Packet Number; 4

print(" Port 1 Queue 1 2 packets")
ksz8895_reg_write_verify(0xB2, [0x82]) # Reflect Packet Number; 2

print(" Port 1 Queue 0 1 packets") 
ksz8895_reg_write_verify(0xB2, [0x81]) # Reflect Packet Number; 1

print(" Enable Queue-Based Egress Rate Limit")
ksz8895_reg_write_verify(0x87, [0x24])

# Limit low prio queues 0-2
print(" Port 1 Queue 0, 1, 2, 3 Egress Rate Limit") 
ksz8895_reg_write_verify(0xBB, [0x67]) #P1 Q0 192Kbps
ksz8895_reg_write_verify(0xBC, [0x67]) #P1 Q1 192Kbps
ksz8895_reg_write_verify(0xBD, [0x67]) #P1 Q2 192Kbps
ksz8895_reg_write_verify(0xBE, [0x67]) #P1 Q3 192Kbps


# Start switch
print("\n\nRead Start Switch")
ksz8895_reg_write_verify(0x01,[0x01])
start_switch = ksz8895_reg_read(0x1,1)
if start_switch == [0x61]:
    print("Switch has started")
else:
    print("Switch has stopped or on reset")

print("Test done!")
spi.close()