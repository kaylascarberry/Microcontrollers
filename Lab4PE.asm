;Lab4 Part D
;Table 14, Kayla Scarberry and Ezekiel Zizo
    
 #include <P18F4620.inc>	;Header Files
    
 config OSC = INTIO67
 config WDT = OFF
 config LVP = OFF
 config BOREN = OFF
 
InA equ 0x20		;Global Declarations
InB equ 0x21
Result equ 0x22

 ORG 0x0000		;Absolute offset of the first start function

START:
 MOVLW 0x0F		;
 MOVWF ADCON1		; ADCON1 = 0x0F
 MOVLW 0xFF		;
 MOVWF TRISA		; TRISA = 0xFF
 MOVWF TRISB		; TRISB = 0xFF
 MOVWF TRISD		; TRISD = 0xFF
 MOVLW 0x00		;
 MOVWF TRISC		; TRISC = 0x00
 MOVWF TRISE		; TRISE = 0x00
 
MAIN_LOOP:
    MOVF PORTA,W	;Move contents of PORTA A to register W
    ANDLW 0x0F		;Clear 4 Significant bits
    MOVWF InA		;Move W into variable InA
    ;COMF  InA, W	;Complement W with InA
    ;ANDLW 0x0F		;masking 4 msbs to 0
    MOVWF Result	;Move W into variable Results

    BZ TEST		;If Zero Flag is 1, Jump to TEST
    BCF PORTE, 0	;Change Bit 0 to 0 without changing other bits
   
    MOVF PORTB,W	;Move contents of PORTB to register W
    MOVWF InB
    
    XORWF Result,W
    

    MOVWF PORTC	;Move contents of W into PORTC
    
    GOTO MAIN_LOOP	;Return to main loop
    
TEST:
    BSF PORTE,0

 END