#include <avr/io.h>
#include <util/delay.h>

int main(void) {
    DDRD |= (1 << PD5); // Pin 9 en Pro Micro
    while (1) {
        PORTD ^= (1 << PD5);
        _delay_ms(5000);
    }
}
