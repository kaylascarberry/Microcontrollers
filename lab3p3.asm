;Lab 3 Part 3
;Kayla Scarberry and Ezekiel Zizo
; THIS THIRD ASSEMBLY LANGUAGE PROGRAM WILL READ THE VALUES OF
; ALL THE BITS 0-2 OF PORT A AND OUTPUT THEM
; TO THE PINS 0 THROUGH 2 OF PORT B
    
;Header Files
#include <P18F4620.inc>
    
;Global Declarations
 config OSC = INTIO67
 config WDT = OFF
 config LVP = OFF
 config BOREN = OFF
 
 ;Absolute Offset of First Start Function
 ORG 0x0000
 
; CODE STARTS FROM THE NEXT LINE
START:
 MOVLW 0x0F	    ;Copy 1010_2 into W
 MOVWF ADCON1	    ;Copy Contents of W into ADCON1
 MOVLW 0xFF	    ;Copy 1111_2 into W
 MOVWF TRISA	    ;Copy Contents of W into TRISA
 MOVLW 0x00	    ;Copy 0000_2 into W
 MOVWF TRISB	    ;Copy Contents of W into TRISB, making it an OUTPUT
 
;Start of Infinite Main Loop 
MAIN_LOOP: 
 MOVF PORTA, W	    ;Copy Contents of PORTA into W,
 ANDLW 0x07	    ;W AND 0111_2 become W
 MOVWF PORTB	    ;Copy Contents of W to PORTB
 GOTO MAIN_LOOP	    ;Return to Top of Loop
 END