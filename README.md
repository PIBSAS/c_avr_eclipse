# Usar Eclipse Sin AVR Plugin, con AVR toolchain actual, AVR Dude Actual, con make actual, extra sin Eclipse.

# Requisitos:
## Webs:
- AVR Toolchain: [De Microchips](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers)
- AVR Dude:[GitHub Zip usado: avrdude-v8.0-windows-mingw-x64](https://github.com/avrdudes/avrdude/releases)
- MSYS2: [Bajar .exe y seguir las instrucciones de la web](https://www.msys2.org/)
- Eclipse C/C++: [Elegir Eclipse IDE for C/C++ Developers](https://www.eclipse.org/downloads/packages/)

## Variables de entorno.

- Menu ``Window -> Preferences -> C/C++ -> Build -> Environment``.
- Boton Add..
  - Name: ``PATH``
  - Value: ``C:\avr-toolchain\bin;C:\avrdude\;C:\msys64\usr\bin``

Obviamente, descomprimiste AVR Toolchain y la renombras a avr-toolchain y la pegas en C. Lo mismo para avrdude, en el casi de msys64 es donde por defecto te pide instalarse, en usr/bin esta make.exe. Agregarlos también a la variable de entorno en Windows, incluir también eclipse, que también es solo descomprimir, mover a C:/eclipse y hacer un shorcut en el escritorio.

Botones Apply y Apply & Close según corresponda.


# Crear Menu para flashear:

- Ir a Menu ``Run-> External Tools -> External Tools Configuration``. Clic en ``Program`` solo para seleccionar, luego Primer icono, ``New configuration``(Justo arriba de la palabra Program).

  - Name: ``Flash con AVR Dude`` o Flash como quieras
  - En pestaña Main:
  - Location: ``C:\avrdude\avrdude.exe`` usando el botón ``Browse File System...``
  - Working Directory: ``${workspace_loc:${project_name}}``

  - Esto es para automatizaar, sin importar cual es tu workspace o el nombre de tu  proyecto, va a funcionar, obvio si tu proyecto lo pones en la carpeta de workspace que le indicaste a eclipse en el primer lanzamiento. Por defecto, tu ``usuario/eclipse_workspace/tuProyecto``.

  - Arguments: 

    ````
    -p m32u4 -c avr109 -P COM${COM_PORT}  -b 57600 -D -U flash:w:${project_name}.hex:i
    ````

Pero borra ``${COM_PORT}`` y colocate justo después de la palabra COM, Presiona el Botón ``Variables``, luego ``Edit Variables``, en la ventana presiona ``New``:

- Name: ``COM_PORT``
- Value: ``10``
- Description: ``Serial Port``
- Apply & Close

Selecciona en la ventana Select Variable ``COM_PORT`` que ahora estará y dale a OK, esto dejara la lineal de comando tal cual la presentamos arriba. Dale a Ok.


# Hacer Templates para Makefile y C:

- Menu ``Window -> Preferences -> C/C++ -> Code Style -> Code Templates -> Files -> Text``, Botón ``New``, poner lo siguiente:
  - Name: ``makefile`` Type: ``Makefile``
  - Description: ``Makefile template para ATmega32U4``
  - Pattern:

  ````
  # Makefile para ATmega32U4 (Adafruit Pro Micro)
  
  MCU = atmega32u4
  F_CPU = 16000000UL
  BAUD = 57600
  PORT = $${COM_PORT}        # Usa la variable de entorno COM_PORT
  
  CC = avr-gcc
  OBJCOPY = avr-objcopy
  AVRDUDE = avrdude
  
  CFLAGS = -Wall -Os -mmcu=$${MCU} -DF_CPU=$${F_CPU}
  LDFLAGS = -mmcu=$${MCU}
  
  # Detecta automáticamente el nombre del proyecto según el nombre de la carpeta actual
  ROOT := $$(dir $$(abspath $$(lastword $$(MAKEFILE_LIST))))
  TARGET := $$(notdir $$(patsubst %/,%,$${ROOT}))
  
  SRC = $${ROOT}$${TARGET}.c
  OBJ = $${ROOT}$${TARGET}.o
  
  all: $${ROOT}$${TARGET}.hex
  
  $${ROOT}$${TARGET}.elf: $${OBJ}
  	$${CC} $${CFLAGS} -o $$@ $$^
  
  $${OBJ}: $${SRC}
  	$${CC} $${CFLAGS} -c $$< -o $$@
  
  $${ROOT}$${TARGET}.hex: $${ROOT}$${TARGET}.elf
  	$${OBJCOPY} -O ihex -R .eeprom $$< $$@
  
  flash: $${ROOT}$${TARGET}.hex
  	$${AVRDUDE} -v -p $${MCU} -c avr109 -P $${PORT} -b $${BAUD} -D -U flash:w:$${ROOT}$${TARGET}.hex:i
  
  clean:
  	del /Q *.elf *.hex *.o 2>nul || rm -f *.elf *.hex *.o
  ````

Luego presionar los botones:
- Apply, Apply & Close.


Regresar al mismo menu pero elegir `C Source File -> Default C source template`, presionar Edit.

- Description: dejar así.
- Pattern:
    ````
    #include <avr/io.h>
    // Aquí puedes agregar cualquier otra librería que necesites
    
    int main(void) {
        // Configuración del microcontrolador (pines, interrupciones, etc.)
    
        while (1) {
            // Lógica principal del programa
        }
    
        return 0;
    }
    ````
Ok. aca pueden agregar más includes, esto es lo mínimo que cualquier programa tendrá.


# Como empezar, tras todo eso?.

Cerras y abris Eclipse.
- Le das a ``Create a new C or C++ project`` o a ``Create project`` es indistinto te llevan al mismo menu.

- En la ventana elegi ``Make -> Make File Project -> Next``:
  - Project name: ``loqueseteocurra``, presionas Finish.

- File -> New -> Source File
  - Source file:``loqueseteocurra.c``

Es decir debe tener el mismo nombre que tu proyecto/SourceFolder, ya que la automatización que metimos te ayuda en eso. Sino deberías configurar cada proyecto de forma diferente.

- Template: Como esta!, Para eso la modificamos!.

## Ahora el Makefile:

- File -> New -> File from Template
 - File name: ``Makefile``

Automáticamente el campo de texto en Use template cambiara a ``makefile``, presionas ``Finish``. ese archivo esta automatizado, no hace falta tocarlo, si no requerís agregar ``CFLAGS`` o ``LDFLAGS`` u otra cosa que mi ignorancia no sepa.


El martillo construye, para construir y subir, enchufar el Atmega32U4, clic en el archivo ``.c``, en el menu superior vas a ver un menu desplegable con un icono con una C y el nombre del archivo. Desplegas y elegís ``Flash con AVR Dude`` o lo que le hayas puesto al hacer el paso de ``Program External Tools``.

Ahora, con un botón conectado a RST y GND del Adafruit ProMicro(ATmega32U4 16Mhz) lo presionas y acto seguido, pulsas el botón play al lado del martillo, el que tiene algo con rojo supongo una caja de herramientas, ese es el botón de Build&Flash con AVR Dude.

# Si no ves algo asi:
  ````
  Reading 202 bytes for flash from input file trending.hex
  Writing 202 bytes to flash
  Writing | ################################################## | 100% 0.02s
  Reading | ################################################## | 100% 0.00s
  202 bytes of flash verified
  
  Avrdude done.  Thank you.
  ````
La placa no entro en modo bootloader, reintentar.


# MODO ÑOÑO: Bloc de Notas y Terminal.

- Clic Nueva Carpeta
Le pones el nombre del `archivo.c`, no importa donde lo hagas. Entras y abris la Terminal desde ahi Clic derecho Abrir Terminal.
  
  ````
  notepad Makefile
  ````
Pulsas Si

## Pegas el contenido:

  ````
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
  ````

Guardamos y cerramos.

Como lo guarda con `.txt` por defecto, lo renombramos:
- ``mv Makefile.txt Makefile``

# Creamos el .c(aca no vamos a renombrar porque tiene extension):

  ````
  notepad blink.c
  ````
Escribimos:

  ````
  #include <avr/io.h>
  #include <util/delay.h>
  
  int main(void) {
      DDRD |= (1 << PD5); // Pin 9 en Pro Micro
      while (1) {
          PORTD ^= (1 << PD5);
          _delay_ms(500);
      }
  }
  ````

Guardamos y cerramos

# Compilamos:

  ````
  make
  ````
Flasheamos(debemos apretar una vez el botón de reset sino falla):

  ````
  make flash
  ````

Listo, a estudiar!.
