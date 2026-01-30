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

def test_code():
    # Read registers, 0x00 chip id 0, 0x01 chip id 1, two values
    print("Test read to ksz8895....")
    val = ksz8895_reg_read(0x00, 1)
    print_list_in_hex(val)

    # Write registers, Port x Control 3-4 (0xX3) Default Tag[15:8] can be used as scratch pad.
    test_value = [ random.randrange(0, 255), random.randrange(0,255)]
    print("test_value:")
    print_list_in_hex(test_value)

    print("Test write to ksz8895....")
    ksz8895_reg_write(0x13, test_value)
    
    print("Test write read back....")
    val = ksz8895_reg_read(0x13, 2)
    print_list_in_hex(val)

    # Reset Port x Control 3-4
    print("Reset written registers....")
    test_value = [0x00, 0x01]
    ksz8895_reg_write(0x13, test_value)
    print_list_in_hex(ksz8895_reg_read(0x13, 2))

    print("Test Done....")

######## Start of Main Application #####
#
# KSZ8895 802.1p-based priority test
#

print(" Mirror Port 5 to Port 1")
# Port 1 Control 1 Enable Sniffer Port
ksz8895_reg_write_verify(0x11, [0x9F]) 
# Port 5 Control 1 Enable Transmit Sniff
ksz8895_reg_write_verify(0x51, [0x3F])

print("Port 2 and 4 802.1p enable = 1")
ksz8895_reg_write_verify(0x20, [0x20]) 
ksz8895_reg_write_verify(0x40, [0x20]) 

print("Port 2 and 4 4 Queue Split Enable = 1")
# Port 2 and 4 Control 9 4 Queue Split Enable
ksz8895_reg_write_verify(0xC1, [0x02])
ksz8895_reg_write_verify(0xE1, [0x02])

print("Port 5 Two Queue Split Enable = 0, 802.1p enable = 1")
# Port 5 Control 0 802.1p enable
ksz8895_reg_write_verify(0x50, [0x20]) 

print("Port 5 4 Queue Split Enable = 1")
# Port 5 Control 9 4 Queue Split Enable
ksz8895_reg_write_verify(0xF1, [0x02])

print(" Port 5 Queue 3 Strict Priority")
# Port 5 Control 10
ksz8895_reg_write_verify(0xF2, [0x00])

# ksz8895_reg_write_verify(0xC2, [0x00])
# ksz8895_reg_write_verify(0xE2, [0x00])
# print("Read Prio_2Q Register")
# print(f"Reg 0x82 value: 0d{ksz8895_reg_read(0x82,1)}")

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