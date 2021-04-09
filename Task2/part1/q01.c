/*******************************************************
Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32a.h>
#include <delay.h>

    int i ;
void main(void)
{


/*  Calculation

F = 1.000000 MHZ  ==> T = 1/f 

T = 1 / 1000000 ==> T = 1us

so we can use Only Delay_ms  

and each delay_ms(1) == 1ms
*/

DDRA.0 = 1 ;  // PORT A.0 AS OUTPUT 

while (1)
      {
            for(i=0 ; i<500 ; i++)
            {
                delay_ms(1);
            }
            
            PORTA.0 =! PORTA.0 ;
      }
}
