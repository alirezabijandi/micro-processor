/*******************************************************
Project :  slave
Version : 
Date    : 3/28/2021
Author  : 
Company : 

*******************************************************/

#include <mega16.h>


void main(void)
{
DDRC = 0XFF ;
DDRA = 0X00 ;

while (1)
      {
        PORTC = PINA ;
      }
}
