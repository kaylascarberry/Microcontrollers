//Lab2 Part 1. This Program will allow Turn off or On 3 LED's set by a Dip Switch
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

void main()                     //Main Function
{
    char in;
    TRISA = 0x07;               //Port A is input (1)
    TRISD = 0x00;               //Port D is Output to LEDS
    ADCON1 = 0x0F;              //Convert all channels from analog to digital
    
    while (1)                   //While loop
    {
        in = PORTA;             //Check input of Port A
        in = in & 0x07;         //Masking of the unwanted bits
        PORTD = in;             //Copy input of Port A, to output Port D
    }
}