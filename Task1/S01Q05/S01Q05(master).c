/*******************************************************
Project : 
Version : 
Date    : 3/28/2021
Author  : 
Company : 
Comments: 
*******************************************************/

#include <mega16.h>
#include <stdio.h>
#include <delay.h>

int i = 0 ;
unsigned char data[200]= {"abcdefghijklmnopqrstuvwxyz***ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 ~!@#$%^&*()_+?"}  ;
char s[1];
void main(void)
{


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600 (Double Speed Mode)
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (1<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x0C;



while (1)
      {
        s[0] = data[i];
        puts(s);
        
        delay_ms(100);
        if(i<200)
        {
        i++;
        }
        else
        {
            break ;
        }
      }
}
