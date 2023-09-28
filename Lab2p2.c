//Lab2 Part 2. This Program will let the user color-mix an RGB LED using a dip switch
//Table 14, Kayla Scarberry and Ezekiel Zizo

#include <stdio.h>              //Header Files
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config BOREN = OFF

void main()                     //Start of main function
{
char in;
TRISB=0x00;                     // Output Port B
ADCON1=0x0F;                    // Convert analog channels to digital
TRISA=0x0F;                     // Port A recieving input from dip switches

while(1)                        //Read the input from the dip switches into PORTA, and output the mixed LED
{
        in = PORTA;
        in = in & 0x07; //Masking of the unwanted bits
        PORTB = in;
}
}
