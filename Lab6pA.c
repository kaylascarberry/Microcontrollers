//This program will 
//Lab 6, Table 14, Kayla Scarberry & Ezekiel Zizo

//Header files
#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>
#include <usart.h>

//Global declarations
#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config BOREN = OFF

#define DP PORTDbits.RD7

int LED_7seg[10] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};

//Function to delay 1 second
void Delay_One_Sec()
{
    for(int I=0; I < 17000; I++);
}

//function to initialize UART
void init_UART()
{
 OpenUSART (USART_TX_INT_OFF & USART_RX_INT_OFF &
USART_ASYNCH_MODE & USART_EIGHT_BIT & USART_CONT_RX &
USART_BRGH_HIGH, 25);
 OSCCON = 0x60;
}

//Function to print to TeraTerm
void putch (char c)
{
 while (!TRMT);
 TXREG = c;
}

//Reads the value of the input voltage
unsigned int get_full_ADC(void)
{
    int result;
    ADCON0bits.GO=1;                        //Start conversion
    while(ADCON0bits.DONE==1);              //Wait for conversion to be completed
    result = (ADRESH * 0x100) + ADRESL;     //Combine result of upper & lower bytes
    
    return result;
};

void Set_ADCON0 (char channel)
{
	ADCON0 = channel * 4 + 1;
};

void Init_ADC(void)
{
ADCON0 = 0x01;                              //Select channel AN0 and turn on the ADC subsystem
ADCON1 = 0x1E;
ADCON2 = 0xA9;

};

//Outputs the lower bits on a dual 7 segment display
void Lower_display(char output)
{
    PORTD = LED_7seg[output];
}

//Outputs the upper bits on a dual 7 segment display
void Upper_display(char output)
{
    PORTB = LED_7seg[output];
}


//Start of Main Functions
void main(void)
{
    init_UART();                            //Calls init_UART function
    Init_ADC();                             //Calls Init_ADC function
    
    TRISA = 0x0F;                           //Initialize PORTA as an input
    TRISB = 0x00;                           //Initialize PortB as an output
    TRISC = 0X00;                           //Initialize PORTC as an output
    TRISD = 0x00;                           //Initialize PortD as an output
    TRISE = 0X00;                           //Initialize PORTE as an output
    
    for (int i=0; i<10; i++)                //Loop to pass values for upper display and lower display
    {
        Lower_display(i);
        Upper_display(i);
        Delay_One_Sec();
    }
    
    while(1)                                //Calls Set_ADCON0 function
    {
        Set_ADCON0(0);
    int num_step =  get_full_ADC();                //Read value of VREF and convert to 8 bits
    float voltage_mv = num_step * 4.0;             //Formulas to find voltage in mV
    float V_float = voltage_mv / 100.0;
    int V = (int) V_float;
    int Upper = V / 10;                     //Find the value of the 10's place of the temp reading
    int Lower = V % 10;                     //Find the value of the 1's place of the temp reading
    Upper_display(Lower);                   //Display 10's place to the 2nd dual 7 segment display
    Lower_display(Upper);                   //Displau 1's place to the 1st dual 7 segment display
    DP == 1;
 
    printf("V(TeraTerm) = %d.%d V\r\n", Upper, Lower);     //Output values to TeraTerm
    Delay_One_Sec();
 
    }
    
    return;
 }
