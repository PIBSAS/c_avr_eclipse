# Makefile para ATmega32u4 (Adafruit Pro Micro)

MCU = atmega32u4
F_CPU = 16000000UL
BAUD = 57600
COM_PORT = 10                      # Cambiá esto por el número correcto si varía
PORT = COM${COM_PORT}             # COM10 → COM${COM_PORT}

CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

CFLAGS = -Wall -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU)
LDFLAGS = -mmcu=$(MCU)

# Detecta automáticamente el nombre del proyecto según la carpeta actual
ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TARGET := $(notdir $(patsubst %/,%,$(ROOT)))

SRC = $(TARGET).c
OBJ = $(TARGET).o

all: $(TARGET).hex

$(TARGET).elf: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

flash: $(TARGET).hex
	$(AVRDUDE) -v -p $(MCU) -c avr109 -P $(PORT) -b $(BAUD) -D -U flash:w:$(TARGET).hex:i

clean:
	del /Q *.elf *.hex *.o 2>nul || rm -f *.elf *.hex *.o
