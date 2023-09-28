//Lab2 Part 5. This Program will automatically color cycle three RGB Leds in alternating patterns
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

//Declaration of arrays
char array1[8] = {2, 0, 6, 7, 1, 5, 4, 3};
char array2[8] = {6, 0, 4, 7, 2, 3, 5, 1};

//prototyping of delay 1 second function
void Delay_One_Sec()
{
    for(int I=0; I < delay_value; I++);
}

void main()                     //Start of main function
{
TRISB=0x00;                     // Output Port B
TRISC=0x00;                     // Output Port C
TRISE=0x00;                     //Output Port E
ADCON1=0x06;                    // Convert analog channels to digital
TRISA=0xFF;                     // Port A recieving input from dip switches

while(1)                        //while true, creating an infinite loop
{
    for(char i=0; i < 8; i++)
    {
        PORTB = i;
        PORTC = array1[i];
        PORTE = array2[i];
        
        Delay_One_Sec(); //Delay 1 second between each case
    }
}


    
}

