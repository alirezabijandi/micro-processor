/*******************************************************


Project : master paralel
Version : 
Date    : 3/28/2021
Author  : 
Company : 
Comments: 
*******************************************************/

#include <mega16.h>
#include <delay.h>


unsigned char data[200] =   {
                            '0','1','0','1','1','0','0','0','0','0',
                            '0','1','0','0','0','1','0','1','1','1',
                            '0','0','0','1','1','1','0','1','0','1',
                            '0','1','0','0','0','1','0','1','1','1',
                            '0','0','1','0','0','1','0','1','0','0',
                            '1','1','1','0','1','0','0','1','0','0',
                            '1','0','1','1','0','1','0','1','0','0',
                            '1','1','1','0','0','1','0','1','1','1',
                            '1','0','1','0','1','1','0','1','0','1',
                            '1','1','0','0','1','1','0','0','1','0',
                            '1','0','1','1','0','0','0','0','0','1',
                            '1','1','0','0','1','1','0','0','0','1',
                            '1','0','0','0','1','0','0','0','1','0',
                            '1','1','0','0','1','1','0','0','1','1',
                            '1','0','1','1','0','1','0','0','1','0',
                            '1','1','1','1','0','0','0','0','0','1',
                            '1','0','0','0','1','1','0','0','0','0',
                            '1','1','0','1','0','1','0','0','1','1',
                            '1','0','1','1','0','0','0','0','1','0',
                            '1','1','1','0','1','1','0','0','1','1', 
                           
                            }; 
int i = 0 ;
void main(void)
{
        DDRC = 0xff ; // as output


while (1)
      {            
            if(data[i] == '0')PORTC.0 = 0;   
            else PORTC.0 = 1 ; 

            if(data[i+1] == '0')PORTC.1 = 0;   
            else PORTC.1 = 1 ; 

            if(data[i+2] == '0')PORTC.2 = 0;   
            else PORTC.2 = 1 ; 

            if(data[i+3] == '0')PORTC.3 = 0;   
            else PORTC.3 = 1 ; 

            if(data[i+4] == '0')PORTC.4 = 0;   
            else PORTC.4 = 1 ; 

            if(data[i+5] == '0')PORTC.5 = 0;   
            else PORTC.5 = 1 ; 

            if(data[i+6] == '0')PORTC.6 = 0;   
            else PORTC.6 = 1 ; 

            if(data[i+7] == '0')PORTC.7 = 0;   
            else PORTC.7 = 1 ;   
            
            
            delay_ms(100); 


            if(i<192)
            {
            i = i+8 ;
            }
            else
            {
            break;
            }

            
            
      }
}
