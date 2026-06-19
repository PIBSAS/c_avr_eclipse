.global main

main:
    ldi r16, 0b00100000
    out 0x04, r16        ; DDRB5 = salida

loop:
    in r17, 0x05         ; leer PORTB
    ldi r18, 0b00100000
    eor r17, r18         ; toggle PB5
    out 0x05, r17

    rcall delay
    rjmp loop

delay:
    ldi r18, 200
1:
    ldi r19, 200
2:
    ldi r20, 200
3:
    dec r20
    brne 3b
    dec r19
    brne 2b
    dec r18
    brne 1b
    ret