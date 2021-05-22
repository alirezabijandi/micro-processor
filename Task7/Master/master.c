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
#include <stdio.h>
#include <delay.h>


#define   ROW1   PORTC.0
#define   ROW2   PORTC.1
#define   ROW3   PORTC.2
#define   ROW4   PORTC.3
#define   C1     PINC.4        
#define   C2     PINC.5
#define   C3     PINC.6

#define   RED     PORTD.6
#define   GREEN   PORTD.7

int x , pos_x , pos_y , i , j , log_id ;
bit press,new_id,new_pass,break_mode,error,id_chk  ;
unsigned char c[20] ;

long int id[10],pass[10];
long int check ;


int year , mounth , day , hour , minute ;


void show()
{
    if(press == 1)
    {
        press = 0 ;
        
        if(x == 200)
        {
            if(new_id == 1)
            {
             new_id = 0 ;
             new_pass = 1 ;
             lcd_clear() ;
             lcd_gotoxy(0,0);
            lcd_puts("Enter Pass to SIGNUP ");
            lcd_gotoxy(1,1);
            lcd_puts("  Then Press <#> ");

            lcd_gotoxy(0,3);
            lcd_puts("==> ");

                pos_x = 4 ;
                pos_y = 3 ;
            }
            else if(new_pass == 1)
            {
             i++  ;
             new_pass = 0 ;
             lcd_clear();
             break_mode = 1;
            }
            else if(id_chk == 1) // id check
            { 
            error = 1 ;
               for(j = 0 ; j < i ; j++ )
                {
                    if(check == id[j])
                    {
                        id_chk = 0 ;
                        check = 0 ;
                         
                        lcd_clear() ;
                        lcd_gotoxy(0,0);
                        lcd_puts("Enter Pass to login");
                        lcd_gotoxy(1,1);
                        lcd_puts("  Then Press <#> ");

                        lcd_gotoxy(0,3);
                        lcd_puts("==> ");

                            pos_x = 4 ;
                            pos_y = 3 ;
                            error = 0 ;
                        GREEN = 1 ;
                        delay_ms(500);
                        GREEN = 0 ; 
                        
                        log_id = j ;
                    }
                } 
                
                if(error == 1)
                {
                        lcd_clear() ;
                        lcd_gotoxy(3,0);
                        lcd_puts("USER NOT FOUND");
                        lcd_gotoxy(1,2);
                        lcd_puts("  ERROR    ERROR"); 
                        RED = 1 ;

                }
            }
            else if(id_chk == 0) // pass check
            { 
            error = 1 ;

                    if(check == pass[log_id])
                    {
                        id_chk = 0 ;
                        check = 0 ;
                         
                        lcd_clear() ;
                        lcd_gotoxy(0,0);
                        lcd_puts("LOGED IN Succesfully");
                        break_mode = 1 ;
                        error = 0 ; 
                        
                        GREEN = 1 ;
                        delay_ms(500);
                        GREEN = 0 ;
                    }
                
                if(error == 1)
                {
                        lcd_clear() ;
                        lcd_gotoxy(3,0);
                        lcd_puts("PASS INCORRECT");
                        lcd_gotoxy(1,2);
                        lcd_puts("  ERROR    ERROR");
                        RED = 1 ;
                        
                }
              }
            
                
        }
        else if(x == 100)
        {
            break_mode = 1;
        }
        else
        {                  
            lcd_gotoxy(pos_x,pos_y);
            sprintf(c,"%d",x); 
            lcd_puts(c);
            pos_x++;
            
            if(new_id == 1)
            {         
            
                id[i] *= 10 ;
                id[i] += x ; 
            }
            else if(new_pass == 1)
            {         
            
                pass[i] *= 10 ;
                pass[i] += x ; 
            }
            else
            {
                check *= 10 ;
                check += x ;  
            }
        }        
    }
    
}

   void keyboard()
        {

        ROW1 = 0 ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        if(C1==0) x = 1  ,press = 1  ;   
        if(C2==0) x = 2  ,press = 1   ;
        if(C3==0) x = 3  ,press = 1   ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        ROW1 = 1 ;
show();            
        ROW2 = 0 ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        if(C1==0) x = 4   ,press = 1  ;
        if(C2==0) x = 5   ,press = 1  ;
        if(C3==0) x = 6   ,press = 1  ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        ROW2 = 1 ; 
show();        
        ROW3 = 0 ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        if(C1==0) x = 7   ,press = 1  ;
        if(C2==0) x = 8   ,press = 1  ;
        if(C3==0) x = 9   ,press = 1  ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        ROW3 = 1 ;
show();       
        ROW4 = 0 ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        if(C1==0) x = 100  ,press = 1   ;
        if(C2==0) x = 0    ,press = 1 ;
        if(C3==0) x = 200  ,press = 1   ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        ROW4 = 1 ;
show();
        }


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

DDRC = 0X0F ;
DDRD = 0XC0 ;


lcd_init(20);

lcd_gotoxy(1,0);
lcd_puts("Enter ID to SIGN UP ");
lcd_gotoxy(1,1);
lcd_puts("  Then Press <#> ");

lcd_gotoxy(0,3);
lcd_puts("==> ");

    pos_x = 4 ;
    pos_y = 3 ;
    new_id = 1 ;
while (1)
      {
        keyboard();
        
        if(break_mode == 1)
        {
        break_mode = 0 ;
        break ;
        } 
        
      } 

start : 

lcd_gotoxy(1,0);
lcd_puts("Enter ID to log in ");
lcd_gotoxy(1,1);
lcd_puts("  Then Press <#> ");

lcd_gotoxy(0,3);
lcd_puts("==> ");      
    pos_x = 4 ;
    pos_y = 3 ;
    id_chk = 1 ;      
 
while (1)
      {
        keyboard();
        
        if(break_mode == 1)
        {
        break_mode = 0 ;
        break ;
        } 
        
      }

delay_ms(500);      
lcd_clear();


while(1)
{
        lcd_clear();
        if(log_id == 0)
        {
            lcd_gotoxy(0,0);
            lcd_puts("LOGED IN AS : ADMIN");
                lcd_gotoxy(0,1);
            lcd_puts("1- ADD USER");
                lcd_gotoxy(0,2);
            lcd_puts("2- SET TIME / DATE ");
                lcd_gotoxy(0,3);
            lcd_puts("3- LOG OUT");
        }
        else
        {
            lcd_gotoxy(0,0);
            lcd_puts("LOGED IN AS : USER");

                lcd_gotoxy(0,1);
            lcd_puts("1- CHECK DATE/TIME");
                lcd_gotoxy(0,2);
            lcd_puts("2- TEMPERATURE ");
                lcd_gotoxy(0,3);
            lcd_puts("3- STEP MOTOR");
        }
        while(1)
        {
        ROW1 = 0 ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        if(C1==0) x = 1  ,press = 1  ;   
        if(C2==0) x = 2  ,press = 1   ;
        if(C3==0) x = 3  ,press = 1   ;
        delay_ms(50);   // in normal we use 2ms but proteus can not detect
        ROW1 = 1 ;
        
        if(press == 1)
        {
          break ;
        }
        }
        
press = 0 ;
delay_ms(500);
        if(log_id == 0 && x == 1)
        {  
            lcd_clear();
            lcd_gotoxy(1,0);
            lcd_puts("Enter ID to SIGN UP ");
            lcd_gotoxy(1,1);
            lcd_puts("  Then Press <#> ");

            lcd_gotoxy(0,3);
            lcd_puts("==> ");

                pos_x = 4 ;
                pos_y = 3 ;
                new_id =1 ;
           
           while(1)
           {
                keyboard();
                
                        if(break_mode == 1)
                    {
                    break_mode = 0 ;
                    break ;
                    } 
           }    
           
                   goto start ;
        } 

        if(log_id == 0 && x == 2)
        {
        lcd_clear();
        new_id = 0 ;
        new_pass = 0 ;
        lcd_gotoxy(0,0);
        lcd_puts("To SET press <*> ");        
        lcd_gotoxy(0,1);
        lcd_puts("Enter Year : ");
        lcd_gotoxy(0,3);
        lcd_puts("==> ");
        
            while(1)
            {
                keyboard();
                if(break_mode == 1)
                {
                break_mode = 0 ;
                break ;
                }             
            }
            year = check ;
            check = 0 ;            
            lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("To SET press <*> ");
        lcd_gotoxy(0,1);
        lcd_puts("Enter mount : ");
        lcd_gotoxy(0,3);
        lcd_puts("==> ");
        
            while(1)
            {
                keyboard();
                if(break_mode == 1)
                {
                break_mode = 0 ;
                break ;
                }             
            }
            mounth = check ;
            check = 0 ;            
            lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("To SET press <*> ");            
            lcd_gotoxy(0,1);
            lcd_puts("Enter day : ");
            lcd_gotoxy(0,3);
            lcd_puts("==> ");
        
            while(1)
            {
                keyboard();
                if(break_mode == 1)
                {
                break_mode = 0 ;
                break ;
                }             
            }
            day = check ;
            check = 0 ;            
            lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("To SET press <*> ");            
            lcd_gotoxy(0,1);
            lcd_puts("Enter hour : ");
            lcd_gotoxy(0,3);
            lcd_puts("==> ");
        
            while(1)
            {
                keyboard();
                if(break_mode == 1)
                {
                break_mode = 0 ;
                break ;
                }             
            }
            hour = check ;
            check = 0 ;            
            lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("To SET press <*> ");            
            lcd_gotoxy(0,1);
            lcd_puts("Enter minute : ");
            lcd_gotoxy(0,3);
            lcd_puts("==> ");
        
            while(1)
            {
                keyboard();
                if(break_mode == 1)
                {
                break_mode = 0 ;
                break ;
                }             
            }
            minute = check ;
            check = 0 ;            
        }
        
        if(log_id == 0 && x == 3)
        {
            lcd_clear();
            goto start ;
        }

        if(log_id == 1 && x == 1)
        {
            lcd_clear();
            
            lcd_gotoxy(0,0);
            lcd_puts( "     << DATE >>    ");

                lcd_gotoxy(0,1);
            sprintf(c,"      %d / %d / %d ",year , mounth , day);
            lcd_puts(c);
                lcd_gotoxy(0,2);
            lcd_puts( "     << TIME >>    ");
                lcd_gotoxy(0,3);
            sprintf(c,"       %d : %d     ",hour , minute);
            lcd_puts(c);
            
            delay_ms(5000);
            press = 0 ;
        }
        
        if(log_id == 1 && x == 2)
        {
            puts("TEMP");
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Temp =");
            lcd_gotoxy(5,0);
            gets(c,15);
            lcd_puts(c);
            
            delay_ms(2000);
            
            
            
        }
        
        if(log_id == 1 && x == 3)
        {
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("  enter step motor  ");
            lcd_gotoxy(0,1);
            lcd_puts("steps between(2-4-8)");
            
                    while(1)
                    {         
                    ROW1 = 0 ;
                    delay_ms(50);   // in normal we use 2ms but proteus can not detect
                    if(C2==0) x = 2  ,press = 1   ;
                    delay_ms(50);   // in normal we use 2ms but proteus can not detect
                    ROW1 = 1 ;
                    ROW2 = 0 ;
                    delay_ms(50);   // in normal we use 2ms but proteus can not detect
                    if(C1==0) x = 4   ,press = 1  ;
                    delay_ms(50);   // in normal we use 2ms but proteus can not detect
                    ROW2 = 1 ; 
                    ROW3 = 0 ;
                    delay_ms(50);   // in normal we use 2ms but proteus can not detect
                    if(C2==0) x = 8   ,press = 1  ;
                    delay_ms(50);   // in normal we use 2ms but proteus can not detect
                    ROW3 = 1 ;


                        if(press == 1)
                        { 
                        press = 0 ;
                          break ;
                        }
                    } 
             sprintf(c,"step %d",x);
                    
             puts(c);
             lcd_gotoxy(3,3);
             lcd_puts(c);
             
             delay_ms(5000);                              
            
            
        }
}

           
}
