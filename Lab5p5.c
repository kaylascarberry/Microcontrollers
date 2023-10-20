//This program will output the reading from a temperature sensor in degrees Fahrenheit
//and will display different LED colors depending on the temperature range. This program
//will also use a photo sensor and output the colors of an LED based on the light reading
//Lab 5, Table 14, Kayla Scarberry & Ezekiel Zizo

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

#define D1_RED PORTCbits.RC0
#define D1_GREEN PORTCbits.RC1
#define D1_BLUE PORTCbits.RC2

#define D2_RED PORTEbits.RE0
#define D2_GREEN PORTEbits.RE1
#define D2_BLUE PORTEbits.RE2

#define D3_GREEN PORTCbits.RC3
#define D3_BLUE PORTCbits.RC4

//array of 7 segment display values
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

//Read the voltage from the LMT84 using the PIC18F4620's ADC Channel 0 connected to AN0 (aka RA0)
void Init_ADC(void)
{
ADCON0 = 0x01;                              //Select channel AN0 and turn on the ADC subsystem
ADCON1 = 0x1B;
ADCON2 = 0xA9;

};

//Finds the voltage reading of the temperature sensor
void Set_ADCON0 (char AN_pin)
{
	ADCON0 = AN_pin * 4 + 1;
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

//Reads the voltage value of the temperature sensor and passes the result
unsigned int get_full_ADC(void)
{
    int result;
    ADCON0bits.GO=1;                        //Start conversion
    while(ADCON0bits.DONE==1);              //Wait for conversion to be completed
    result = (ADRESH * 0x100) + ADRESL;     //Combine result of upper & lower bytes
    
    return result;
};

//Color Mixing Values for each LED
void SET_D1_OFF()
{
    D1_RED = 0;
    D1_GREEN = 0;
    D1_BLUE = 0;
}

void SET_D1_RED()
{
D1_RED = 1;
D1_GREEN = 0;
D1_BLUE = 0;
} 

void SET_D1_GREEN()
{
D1_RED = 0;
D1_GREEN = 1;
D1_BLUE = 0;
} 

void SET_D1_YELLOW()
{
D1_RED = 1;
D1_GREEN = 1;
D1_BLUE = 0;
} 

void SET_D1_BLUE()
{
D1_RED = 0;
D1_GREEN = 0;
D1_BLUE = 1;
} 

void SET_D1_PURPLE()
{
D1_RED = 1;
D1_GREEN = 0;
D1_BLUE = 1;
} 

void SET_D1_CYAN()
{
D1_RED = 0;
D1_GREEN = 1;
D1_BLUE = 1;
} 

void SET_D1_WHITE()
{
D1_RED = 1;
D1_GREEN = 1;
D1_BLUE = 1;
}

void SET_D2_OFF()                                          
{
D2_RED = 0;                                            
D2_GREEN = 0;                                          
D2_BLUE = 0;                                           
}
void SET_D2_RED()                                          
{
D2_RED = 1;                                            
D2_GREEN = 0;                                          
D2_BLUE = 0;                                           
}
void SET_D2_GREEN()                                    
{
D2_RED = 0;                                            
D2_GREEN = 1;                                          
D2_BLUE = 0;                                           
}

void SET_D2_YELLOW()                                   
{
D2_RED = 1;                                            
D2_GREEN = 1;                                          
D2_BLUE = 0;                                           
}
void SET_D2_BLUE()                                     
{
D2_RED = 0;                                            
D2_GREEN = 0;                                          
D2_BLUE = 1;                                           
}
void SET_D2_PURPLE()                                       
{
D2_RED = 1;                                           
D2_GREEN = 0;                                         
D2_BLUE = 1;                                          
}
void SET_D2_CYAN()                                    
{
D2_RED = 0;                                           
D2_GREEN = 1;                                         
D2_BLUE = 1;                                          
}
void SET_D2_WHITE()                                   
{
D2_RED = 1;                                           
D2_GREEN = 1;                                         
D2_BLUE = 1;                                          
}

void SET_D3_OFF()                                     
{
    D3_GREEN = 0;                                          
    D3_BLUE = 0;                                           
}

void SET_D3_GREEN()                                        
{
    D3_GREEN = 1;                                          
    D3_BLUE = 0;                                           
}
void SET_D3_BLUE()                                         
{
    D3_GREEN = 0;                                          
    D3_BLUE = 1;                                           
}
void SET_D3_CYAN()                                         
{
    D3_GREEN = 1;                                          
    D3_BLUE = 1;                                           
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

while(1)
{
    Set_ADCON0(0);                          //Calls Set_ADCON0 function
    int num_step = get_full_ADC();          //Calls get_full_ADC function and sets the return value equal to num_step
    float voltage_mv = num_step * 4.0;      //Formulas to find voltage in mV
    float TC = (1035 - voltage_mv) / (5.5); //Converts voltage (mV) to degrees celsius
    float TF = TC * 1.80 + 32;              //Converts degrees Celsius to Fahrenheit
    int F = (int) TF;                       //converts decimal value of temp. in F to whole integer values
    int Upper = F / 10;                     //Find the value of the 10's place of the temp reading
    int Lower = F % 10;                     //Find the value of the 1's place of the temp reading  
    
    Upper_display(Upper);                   //Display 10's place to the 2nd dual 7 segment display
    Lower_display(Lower);                   //Displau 1's place to the 1st dual 7 segment display
    
    printf("T(F) = %d\r\n", F);             //Output values to TeraTerm
    printf("V(mv) = %f\r\n", voltage_mv);
    
    if(F < 10) SET_D2_OFF();                //If Statements that control the output of the LED 2                     
    else if (F >= 70) SET_D2_WHITE();              
    else (PORTE = F/10);
   
            
    if (F < 40)                             //If statements that control the output of LED 1                 
        {
        SET_D1_OFF();
       }
    else if (F >= 40 && F <= 49)
         {
            SET_D1_RED();
        }
        else if (F >= 50 && F <=59)
        {
            SET_D1_GREEN();
        }
        else if (F >= 60 && F <=69)
        {
            SET_D1_YELLOW();
        }
        else if (F >= 70 && F <=71)
        {
            SET_D1_BLUE();
        }
        else if (F >= 72 && F <=73)
        {
            SET_D1_CYAN();
        }
        else if (F >= 73)
        {
            SET_D1_WHITE();
        } 
    
        Set_ADCON0(2);                            
        int num_step = get_full_ADC();                     
        float voltage_mv1 = (num_step *4.0) / 1000;         
        if (voltage_mv1 < 2.6)             //If statements that control the output of LED 3                             
        {
            SET_D3_OFF();                                 
        }
        else if (voltage_mv1 >= 2.6 && voltage_mv1 < 3.0)  
        {
            SET_D3_BLUE();                                
        }
        else if (voltage_mv1 >= 3.0 && voltage_mv1 < 3.3)  
        {
            SET_D3_CYAN();                                
        }
        else SET_D3_GREEN();                                
        
        printf ("Light Voltage = %f V \r\n", voltage_mv1);   // print out the light voltage ADC value on TeraTerm
        //printf ("Temperature = %d F \r\n\n", tempF);       // print out the tempF ADC value on TeraTerm
        Delay_One_Sec();
}
return;
};
