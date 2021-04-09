/*******************************************************
Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
Question                : 3
*******************************************************/

#include <mega32a.h>
#include <delay.h>

    int i ,num = 1 ;
    bit x ;
void main(void)
{


/*  Calculation

F = 1.000000 MHZ  ==> T = 1/f 

T = 1 / 1000000 ==> T = 1ms

so we can use Only Delay_ms  

and each delay_ms(1) == 1ms
*/

DDRB = 0xFF ;  // PORT B AS OUTPUT 
DDRA.0 = 0  ;  // PIN A as Input

while(1)
{

    while(PINA.0 == 1)
            {
                delay_ms(1);
            }


    while (1)
          {
                for(i=0 ; i<500 ; i++)
                {
                    delay_ms(1);
                }
                
                PORTB = num ;
                
                if(x==0)num = num*2 ;
                else num = num/2    ;
                
                if(num == 128) x = 1 ;
                if(num ==  1 ) x = 0 ;

          }
}

}