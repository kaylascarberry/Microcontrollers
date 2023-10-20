#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config BOREN = OFF

//Read the voltage from the LMT84 using the PIC18F4620's ADC Channel 0 connected to AN0 (aka RA0)
void Init_ADC(void)
{
ADCON0 = 0x01; //Select channel AN0 and turn on the ADC subsystem
ADCON1 = 0x0A;
ADCON2 = 0xA9;
}

void Set_ADCON0 (char AN_pin)
{
	ADCON0 = AN_pin * 4 + 1;
}

void main(void)
{
    
};




