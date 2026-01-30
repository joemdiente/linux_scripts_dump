import spidev
import random

# switch [dbg] messages
DEBUG = 0

# Initialize SPI
spi = spidev.SpiDev()

# Open bus 0, device (CS) 3 -> /dev/spidev0.3 (EDS2 Connector)
spi.open(0, 3)

# Settings
spi.max_speed_hz = 1000000  # 1 MHz
spi.mode = 0b00             # SPI Mode 0 (CPOL=0, CPHA=0)
spi.bits_per_word = 8       # Standard 8-bit communication

def print_list_in_hex(x,y):
    if DEBUG:
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

# in: reg_start_addr = start address of switch register
#     value = list of values to write. 
# out: none
# will show additional debug message, user will verify through console.
def ksz8895_reg_write_verify(reg_addr, val):
    ksz8895_reg_write(reg_addr, val)
    if DEBUG:
        print(f"[dbg](0x{reg_addr:02X}) wr: 0x{val[0]:02X} == rd: 0x{ksz8895_reg_read(reg_addr, 1)[0]:02X}")

#
# KSZ8895 Switch MIB Counters
# Defines
#
RX_LOPRIO_BYTE = 0x00
RX_HIPRIO_BYTE = 0x01
TX_LOPRIO_BYTE = 0x14
TX_HIPRIO_BYTE = 0x15

PORT5_TX_DROP_PACKETS = 0x104
PORT2_RX_DROP_PACKETS = 0x106
PORT4_RX_DROP_PACKETS = 0x108

# in: port_no = read port_no mib counter
# out: mib counter count
# if mib_counter >= 0x100, port_no will not work.
def ksz8895_reg_mib_read(port_no, mib_counter):

    mib_counter_hi = (mib_counter >> 8) & 0x3 # Bit 9-8 of Indirect Access
    mib_counter_lo = mib_counter & 0xFF # Bit 7-0 of Indirect Access
    port_offset = 0x00

    if (mib_counter_hi == 0x00):    # Reading Per Port MIB Counters
        if DEBUG:
            print("[dbg] reading per port mib counters")
        PORT_2_MIB_BASE_ADDR = 0x20
        PORT_4_MIB_BASE_ADDR = 0x60
        PORT_5_MIB_BASE_ADDR = 0x80

        match port_no:
            case 2:
                port_offset = PORT_2_MIB_BASE_ADDR
            case 4:
                port_offset = PORT_4_MIB_BASE_ADDR
            case 5:
                port_offset = PORT_5_MIB_BASE_ADDR
            case _:
                print("port no mib read unimplemented")
                return -1
    
        ksz8895_reg_write_verify(0x6E, [0x1C])
        ksz8895_reg_write_verify(0x6F, [port_offset + mib_counter_lo])

        while True:
            val = ksz8895_reg_read(0x75,4)
            if DEBUG:
                print(f"[dbg] val0: {val[0]}")
                print(f"[dbg] val1: {val[1]}")
                print(f"[dbg] val2: {val[2]}")
                print(f"[dbg] val3: {val[3]}")

            byte_val = val[0] # Convert list to byte.
            bit31_val = (byte_val >> 7) & 1
            bit30_val = (byte_val >> 6) & 1 
            if not (bit31_val == 1 and bit30_val == 0):
                return ( (val[0] << 24) | (val[1] << 16) | (val[2] << 8) | (val[3])) & ~0xC0000000 # Remove bit 31 and bit 30
            
    else:   # mib_counter_hi > 0x00; Reading All Ports Dropped Packet MIB Counters
        if DEBUG:
            print("[dbg] reading all port dropped packets mib counters")

        ksz8895_reg_write_verify(0x6E, [0x1D])
        ksz8895_reg_write_verify(0x6F, [mib_counter_lo])
        val = ksz8895_reg_read(0x77,2)
        if DEBUG:
            print(f"[dbg] val0: {val[0]}")
            print(f"[dbg] val1: {val[1]}")
        return (val[0] << 8) | (val[1]) & ~0x0000 # 16-bit only

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
# KSZ8895 Read MIB Counters
#

print("\nRead Port 2 MIB Counters")
print(f" RX LoPrio: {ksz8895_reg_mib_read(2, RX_LOPRIO_BYTE)}")
print(f" RX HiPrio: {ksz8895_reg_mib_read(2, RX_HIPRIO_BYTE)}")
print(f" RX Drop Packets due to lack of resources: {ksz8895_reg_mib_read(2, PORT2_RX_DROP_PACKETS)}")

print("\nRead Port 4 MIB Counters")
print(f" RX LoPrio: {ksz8895_reg_mib_read(4, RX_LOPRIO_BYTE)}")
print(f" RX HiPrio: {ksz8895_reg_mib_read(4, RX_HIPRIO_BYTE)}")
print(f" RX Drop Packets due to lack of resources: {ksz8895_reg_mib_read(4, PORT4_RX_DROP_PACKETS)}")

print("\nRead Port 5 MIB Counters")
print(f" TX LoPrio: {ksz8895_reg_mib_read(5, TX_LOPRIO_BYTE)}")
print(f" TX HiPrio: {ksz8895_reg_mib_read(5, TX_HIPRIO_BYTE)}")
print(f" TX Drop Packets due to lack of resources: {ksz8895_reg_mib_read(5, PORT5_TX_DROP_PACKETS)}")

## TODO verify switch Drop packets.

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