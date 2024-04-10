import sys
import spidev
spi = spidev.SpiDev()

#rsync -av ./read.py root@192.168.137.150:~/ && ssh root@192.168.137.150 'python3 read.py'
rd=0
wd=1
byte_enable=0b0011

#SPI Settings
byte_count = 4
mode = 0b00
max_speed_hz = 25000000

def ksz8851_int_reg_byte(cmd,reg,wr_data):
    buffer = [0x00,0x00,0x00,0x00]

    spi.open(1,0)
    spi.max_speed_hz = max_speed_hz
    spi.mode = mode

    buffer[0] |= cmd << 6
    buffer[0] |= (byte_enable << 2) 
    buffer[0] |= (reg >> 6)
    buffer[1] |= (reg << 2)

    if cmd == 0:
        buffer[2] = 0x00
    elif cmd == 1:
        buffer[2] = wr_data
    print ("Reg:",hex(buffer[0]),hex(buffer[1]), hex(buffer[2]))

    rx = spi.xfer(buffer)
    for i in range (0,byte_count):
        print ("Byte ", i, ":", hex(rx[i]))
    
    #Convert RX to Word
    word = (rx[3] << 8) + rx[2]
    print (hex(word))

    return(word)
    #Output is LSB
    spi.close()

######Program Start######

#Read
print ("Read")
print("return value: ", hex(ksz8851_int_reg_byte(rd,0xC0,0x00)))

print ("Done")

