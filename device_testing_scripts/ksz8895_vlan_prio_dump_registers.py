import spidev
import sys

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

def display_hexmate_block():
    # Fetch all 256 registers in one block read
    try:
        data = ksz8895_reg_read(0, 256)
    except Exception as e:
        print(f"Error reading hardware: {e}")
        return

    # Print Column Header
    print("\n     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F")
    print("      " + "-- " * 16)

    # Iterate through the list in chunks of 16
    for row_start in range(0, 256, 16):
        # Print Row Address
        sys.stdout.write(f"{row_start:02X} | ")
        
        # Get the 16 bytes for this row
        row_data = data[row_start : row_start + 16]
        
        for byte in row_data:
            sys.stdout.write(f"{byte:02X} ")
            
        sys.stdout.write("\n")
    print()

if __name__ == "__main__":
    display_hexmate_block()
