/*******************************************************
Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <delay.h>
#include <stdio.h>
#include <delay.h>

#define RED   PORTC.0 
#define GREEN PORTC.1 


#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

            unsigned char c[20];
            unsigned char step[8] = {0x05 , 0x04 , 0x06 ,0x02 , 0x0a , 0x08 , 0x09 ,0x01 } ;
            int i , j , code , TEMP;
void main(void)
{
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

DDRB = 0XFF ;
DDRC = 0XFF ;


while (1)
      {             
                    RED = 1 ;
                    gets(c,20);
                    
                    if(c[0] == 'T' && c[1] == 'E' && c[2] == 'M' && c[3] == 'P' )
                    {
                      RED = 0 ; 
                      GREEN = 1 ; 

                            ADMUX=(1<<REFS0)|(0<<REFS1); 
                            ADCSRA=(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0); 
                            ADCSRA=(1<<ADEN);
                            ADMUX |=0b000;
                            ADCSRA|=(1<<ADSC); 
                            while(!(ADCSRA & (1<<ADIF))); 
                            ADCSRA|=(1<<ADIF);
                            
                            TEMP = ADCW / 2; 
                            
                            sprintf(c,"%d",TEMP);
                            puts(c); 
                            
                      RED = 1 ;
                      GREEN = 0 ;
                      
                    }
                    if(c[0] == 's' && c[1] == 't' && c[2] == 'e' && c[3] == 'p' )
                    {  
                    GREEN = 1;
                    RED = 0 ;
                    
                        code = c[5] - 48 ;
                        if(code == 2)
                        {    
                            while(j<10)
                                {
                                delay_ms(500);
                                PORTB = step[i];
                                i+= 4;
                                if(i == 8) i = 0 ;
                                j++;
                                }
                                j = 0 ;   
                        }
                        else if (code == 4)
                        {
                            while(j<10)
                                {
                                delay_ms(500);
                                PORTB = step[i];
                                i+= 2;
                                if(i == 8) i = 0 ;
                                j++;
                                }
                                j = 0 ;  
                        }
                        else if(code == 8)
                        {
                                while(j<10)
                                {
                                delay_ms(500);
                                PORTB = step[i];
                                i++;
                                if(i == 8) i = 0 ;
                                j++;
                                }
                                j = 0 ;  
                        } 
                        
                        GREEN = 0 ;
                        RED = 1 ;
                    }

      }
}
