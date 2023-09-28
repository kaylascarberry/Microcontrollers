//Lab2 Part 4. This Program will automatically color cycle two RGB Leds in an alternating pattern
//Table 14, Kayla Scarberry and Ezekiel Zizo

#include <stdio.h>              //Header Files
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>

#define delay_value 17000       //Global Declaration

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config BOREN = OFF

//prototyping of delay 1 second function
void Delay_One_Sec()
{
    for(int I=0; I < delay_value; I++);
}

void main()                     //Start of Main function
{
TRISB=0x00;                     // Output Port B
TRISC=0x00;                     // Output Port C
ADCON1=0x06;                    // Convert analog channels to digital
TRISA=0xFF;                     // Port A recieving input from dip switches

while(1)                        //while true, creating an infinite loop
{
    for(char i=0; i < 8; i++)
    {
        PORTB = i;
        PORTC = i - 7;
        
        Delay_One_Sec(); //Delay 1 second between each case
    }
}


    
}
