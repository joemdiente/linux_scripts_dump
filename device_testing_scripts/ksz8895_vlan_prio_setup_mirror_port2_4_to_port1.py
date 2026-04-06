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
# KSZ8895 Port Mirroring
#

print(" Mirror Port 2 and 4 to Port 1")
# Remove old configuration on all ports
ksz8895_reg_write_verify(0x11, [0x1F]) 
ksz8895_reg_write_verify(0x21, [0x1F]) 
ksz8895_reg_write_verify(0x31, [0x1F]) 
ksz8895_reg_write_verify(0x41, [0x1F]) 
ksz8895_reg_write_verify(0x51, [0x1F]) 

# Port 1 Control 1 Enable Sniffer Port
ksz8895_reg_write_verify(0x11, [0x9F]) 
# Port 2 Control 1 Enable Receive Sniff
ksz8895_reg_write_verify(0x21, [0x5F])
# Port 4 Control 1 Enable Receive Sniff
ksz8895_reg_write_verify(0x41, [0x5F])

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