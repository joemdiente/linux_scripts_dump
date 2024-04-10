import sys
import spidev
spi = spidev.SpiDev()

#rsync -av ./read_write.py root@192.168.137.150:~/ && ssh root@192.168.137.150 'python3 read_write.py'
rd=0
wd=1
byte_enable=0b0011

#SPI Settings
byte_count = 4
mode = 0b00
max_speed_hz = 25000000

def ksz8851_int_reg_byte(cmd,reg,lsb,msb):
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
        buffer[2] = lsb
        buffer[3] = msb
    print ("Reg:",hex(buffer[0]),hex(buffer[1]), hex(buffer[2]))

    rx = spi.xfer(buffer)
    for i in range (0,byte_count):
        print ("Byte ", i, ":", hex(rx[i]))
    
    #Convert RX to Word
    #3 is MSB; 2 is LSB
    word = (rx[3] << 8) + rx[2]
    print (hex(word))

    return(word)
    #Output is LSB
    spi.close()


######Program Start######
#Read
print ("Read")
ksz8851_int_reg_byte(rd,0xD4,0x00,0x00)

#Write
print ("Write")
# ksz8851_int_reg_byte(wd,0xD4,0x81,0x0f) #PME bits and EDM, and auto wake up

print ("Write")
# ksz8851_int_reg_byte(wd,0xD4,0xBC,0x0f) #Clear wake-up event indication without EDM

#Verify
print ("Verify")
# ksz8851_int_reg_byte(rd,0xD4,0x00,0x00)

print ("Done")

