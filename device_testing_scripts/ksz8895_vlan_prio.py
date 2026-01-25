import spidev

# Initialize SPI
spi = spidev.SpiDev()

# Open bus 0, device (CS) 3 -> /dev/spidev0.3 (EDS2 Connector)
spi.open(0, 3)

# Settings
spi.max_speed_hz = 1000000  # 1 MHz
spi.mode = 0b00             # SPI Mode 0 (CPOL=0, CPHA=0)
spi.bits_per_word = 8       # Standard 8-bit communication

# Read registers, 0x03 (read), 0x00 chip id 0, 0x01 chip id 1, two values
to_send = [0x03, 0x00, 0x01, 0x00, 0x00]

# Perform full-duplex transfer
# response will be a list of the same length as to_send
response = spi.xfer2(to_send)

# Print response in hex format
print("Received (Hex):", [hex(x) for x in response])