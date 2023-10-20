
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
ADCON1 = 0x0B;
ADCON2 = 0xA9;
};

void Set_ADCON0 (char AN_pin)
{
	ADCON0 = AN_pin * 4 + 1;
};

void get_full_ADC(void)
{
int result;
int T;
    ADCON0bits.GO=1;            //Start conversion
    while(ADCON0bits.DONE==1);  //Wait for conversion to be completed
    result = (ADRESH * 0x100) + ADRESL; //Combine result of upper & lower bytes
    
    //T = (result - 1035) / (-5.5); //temperature in Celsius 
    //T = T *(9/5) + 32; //convert temp to farhenheit
    
    //int LED_7seg[10] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};
    
    //const int Upper = T / 10; 
    //const int Lower = T % 10;
    
    //PORTB = LED_7seg[Upper];
    //PORTD = LED_7seg[Lower];
    
};

void Temp_Conversion()
{
Set_ADCON0(0);
const int result = get_full_ADC();
float T;

T = (result - 1035) / (-5.5); //temperature in Celsius
T = T *(9/5) + 32; //convert temp to farhenheit

return;
};

void Display_Temp(double T)
{
   double T = Temp_Conversion(temp);
   char LED_7seg[8] == {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};
   
   int Upper = T/10;  
   int Lower = T%10;     
    
   PORTB = LED_7seg[Upper];
   PORTD = LED_7seg[Lower];
    
};

void main(void)
{
Init_ADC();
Set_ADCON0(ADCON0);
get_full_ADC();
//Temp_Conversion();
//Display_Temp();

return;
};






