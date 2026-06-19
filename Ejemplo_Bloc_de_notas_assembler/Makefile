# Makefile para ATmega328p (Sparkfun Pro Micro) - Adaptado para VSCode + MSYS2

MCU = atmega328p
F_CPU = 16000000UL
BAUD = 57600
PORT = ch340       # Usar: COM_PORT=COM4 make flash (sin $$)
PROGRAMMER = arduino

CC = C:/avr-toolchain/bin/avr-gcc.exe
OBJCOPY = C:/avr-toolchain/bin/avr-objcopy.exe
OBJDUMP = C:/avr-toolchain/bin/avr-objdump.exe
AVRDUDE = C:/avrdude/avrdude.exe

CFLAGS = -Wall -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU)
LDFLAGS = -mmcu=$(MCU)

ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TARGET := $(notdir $(patsubst %/,%,${ROOT}))

SRC = $(ROOT)$(TARGET).S
OBJ = $(ROOT)$(TARGET).o

all: $(TARGET).hex $(TARGET).map $(TARGET).lst

$(TARGET).elf: $(OBJ)
	$(CC) $(CFLAGS) -Wl,-Map=$(TARGET).map -o $@ $^

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -x assembler-with-cpp -c $< -o $@

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(TARGET).lst: $(TARGET).elf
	$(OBJDUMP) -d -S $< > $@

flash: $(TARGET).hex
	$(AVRDUDE) -v -p $(MCU) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -D -U flash:w:$(TARGET).hex:i

clean:
	rm -f *.elf *.hex *.o *.map *.lst