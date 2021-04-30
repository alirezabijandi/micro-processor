/*******************************************************
Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>

bit row ;
int i ; 
unsigned char c[20];

void main(void)
{
lcd_init(20);

sprintf(c,"Hello World");

while (1)
      {
            delay_ms(500);

            lcd_clear();
            lcd_gotoxy(i,row);
            lcd_puts(c);
            
            row =! row;
            i+= 2 ;
            if(i>9) i = 0 ;

      }
}
