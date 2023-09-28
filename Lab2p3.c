//Lab2 Part 3. This Program will automatically color cycle an RGB LED
//Table 14, Kayla Scarberry and Ezekiel Zizo

#include <stdio.h>                  //header files
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>

#define delay_value 17000           //Global declaration

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config BOREN = OFF

//prototyping of delay 1 second function
void Delay_One_Sec()
{
    for(int I=0; I < delay_value; I++);
}

void main()                         //Start of main function
{
TRISB=0x00;                         // Output Port B
ADCON1=0x07;                        // Convert analog channels to digital

while(1)                            //while true, creating an infinite loop
{
    for(char i=0; i < 8; i++)
    {
        PORTB = i;
        
        Delay_One_Sec(); //Delay 1 second between each case
    }
}    
}



