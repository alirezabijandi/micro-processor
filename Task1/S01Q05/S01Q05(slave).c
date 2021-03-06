/*******************************************************

Project : slave 
Version : 
Date    : 3/28/2021

*******************************************************/

#include <mega16.h>
#include <alcd.h>
#include <stdio.h>
#include <delay.h>

 char data , old_data; 
 int x,y ;
void main(void)
{

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 9600 (Double Speed Mode)
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (1<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x0C;


lcd_init(20);


DDRC = 0XFF ;

while (1)
      { 
        old_data = data ;
        data = getchar(); 
        
        if(data != old_data)
        {
            if(x<20)
            {
                x++ ;
            }        
            else
            {
                x = 0 ;
                y++ ;
                if(y==4)
                {
                    y = 0 ;
                    lcd_clear();
                }
            }
            
        lcd_gotoxy(x,y);
        lcd_putchar(data);  

        } 
      }
}
