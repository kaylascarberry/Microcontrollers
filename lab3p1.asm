;Lab 3 Part 1
;Kayla Scarberry and Ezekiel Zizo
; THIS FIRST ASSEMBLY LANGUAGE PROGRAM WILL FLASH LEDS
; CONNECTED TO THE PINS 0 THROUGH 3 OF PORT B
    
;Header Files
#include<P18F4620.inc>
    
;Global Declarations
config OSC = INTIO67
config WDT = OFF
config LVP = OFF
config BOREN = OFF
    
; Constant declarations
Delay1 equ 0xFF
Delay2 equ 0XFF
Counter_L equ 0x20
Counter_H equ 0x21
 
;Absolute Offset of First Start Function
ORG 0x0000
 
; CODE STARTS FROM THE NEXT LINE
START:
 MOVLW 0x0F	    ;Copy 1111_2 into W (W = 1111)
 MOVWF ADCON1	    ;Copy Contents of W into the Analog/Digital Convertern(ADCON1 = 1111)
 MOVLW 0x00	    ;Copy 0000_2 into W
 MOVWF TRISD	    ;Copy Contents of W into TRISD (TRISD = 0000).
 
MAIN_LOOP:	    ;Start of a loop
MOVLW 0x05	    ;Copy  0101_2 into W
MOVWF PORTD	    ;Copy Contents of W into PORTD

 CALL DELAY_ONE_SEC ;Call the Delay 1 second function
MOVLW 0x0A	    ;Copy 1010_2 into W
MOVWF PORTD	    ;Copy Contents of W into TRISD
 CALL DELAY_ONE_SEC ;Call the Delay 1 second function
 GOTO MAIN_LOOP	    ;Return to top of loop
 
; the routine below is a subroutine and it is called ?DELAY_ONE_SEC?.
DELAY_ONE_SEC: 
MOVLW Delay1	    ;Copy 1111_2 into W
MOVWF Counter_H	    ;Copy Contents of W into "Counter High"
LOOP_OUTER:
NOP		    ;time delay created in program runtime
MOVLW Delay2	    ;Copy 1111_2 into W
MOVWF Counter_L	    ;Copy Contents of W into "Counter Low"
LOOP_INNER:
NOP		    ;time delay created in program runtime
DECF Counter_L,F    ;Examine Contents of "Counter Low" and decrement by 1
BNZ LOOP_INNER	    ;If Loop Inner is 1, then continue,
DECF Counter_H,F    ;Examine Contents of "Counter High" and decrement by 1
BNZ LOOP_OUTER	;If "Loop Outer" is 1, then restart "Loop Outer"
RETURN
; end of subroutine ?DELAY_ONE_SEC?
 END


