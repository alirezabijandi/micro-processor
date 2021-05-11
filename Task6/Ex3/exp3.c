/*******************************************************
Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>

unsigned char step[8] = {0x05 , 0x04 , 0x06 ,0x02 , 0x0a , 0x08 , 0x09 ,0x01 } ;
int i, time , z = 1000  ; 
bit SWITCH ,mode , inverse;

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCNT0=0x83;  // TIME  = 1mS
time++ ;



        if(PINC.2 == 0) SWITCH =! SWITCH ;

        if(time == z && SWITCH == 1)
        {

                time = 0 ;
                PORTC.0 =! PORTC.0 ;
                PORTB = step[i] ;
                      
                if(inverse == 0 )
                {
                    
                    if(i < 7)i++ ;
                    else
                    {
                     i = 0 ;
                     
                        if(mode == 0) z-=200 ;
                        else z+= 200 ;
                    
                        if(z == 0) mode = 1,z = 100 ;
                        
                        if(z > 1000) inverse = 1 , z = 1000 , mode = 0  ; 
                    } 
                }  
                else
                {
                    
                    if(i > 0) i-- ;
                    else
                    {
                     i = 7 ;
                     
                        if(mode == 0) z-=200 ;
                        else z+= 200 ;
                        if(z == 0) mode = 1,z = 100 ;
                        
                        if(z > 1000) inverse = 0 , z = 1000 , mode = 0  ; 
                    }        
                }
        
            
        }
        else if(time == z) 
        {
        time = 0 ;
        }
           
     

     
}


void main(void)
{

TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x83;
OCR0=0x00;
TIMSK = 0X01 ;


DDRB = 0X0F;
DDRC.0 = 1 ;
DDRC.1 = 1 ;

#asm("sei")


}
