;Lab 3 Part 4
;Kayla Scarberry and Ezekiel Zizo
; THIS FOURTH ASSEMBLY LANGUAGE PROGRAM WILL READ THE VALUES OF
; ALL THE BITS 0-2 OF PORT A AND OUTPUT THEM
; TO THE PINS 0 THROUGH 2 OF PORT B IN  CONTINUOUS COLOR CYCLE
    
;Header Files
#include <P18F4620.inc>
    
;Global Declarations
    config OSC = INTIO67
    config WDT = OFF
    config LVP = OFF
    config BOREN = OFF
Counter_L equ 0x20
Counter_H equ 0x21
Color_Value equ 0x28
Loop_Count equ 0x29
 Delay1 equ 0xFF
Delay2 equ 0XFF
 
;Absolute Offset of First Start Function
 ORG 0x0000
;Absolute Offset of Second Start Function
; CODE STARTS FROM THE NEXT LINE
START:
 ORG 0x0000	    ;Absolute Offset of Second Start Function
 
START:
 MOVLW 0x0F	    ;Copy 1010_2 into W
 MOVWF ADCON1	    ;Copy Contents of W into ADCON1
 MOVLW 0x00	    ;Copy 0000_2 into W
 MOVWF TRISB	    ;Copy Contents of W into TRISB (Making it an Output)

 ;Start of WHILE LOOP
WHILE_LOOP: 
 MOVLW 0x00	    ;Copy 0000_2 into W
 MOVWF Color_Value  ;Copy Contents of W into "Color Value"
 MOVLW 0x08	    ;This is how many colors there are to cycle through. Copy 1000_2 into W
 MOVWF Loop_Count   ;Copy Contents of W into "Loop Count"

 ;Start of FOR LOOP
FOR_LOOP:
 MOVF Color_Value,W ;Copy The Value of "Color Value" into W
 MOVWF PORTB	    ;Copy Contents of W into PORTB
 CALL DELAY_ONE_SEC ;Call the Delay 1 second function
 INCF Color_Value,F ;Examine Contents of "Color Value" and increment by 1
 DECF Loop_Count,F  ;Examine Contents of "Loop Count" and decrement by 1
 BNZ FOR_LOOP	    ;If "For Loop" is 1, then go to "While Loop"
 
 GOTO WHILE_LOOP    ;Restart infinite While Loop

; the routine below is a subroutine and it is called ?DELAY_ONE_SEC?.
DELAY_ONE_SEC: 
    MOVLW Delay1    ;Copy 1111_2 into W
    MOVWF Counter_H ;Copy Contents of W into "Counter High"
LOOP_OUTER:
    NOP		    ;time delay created in program runtime
    MOVLW Delay2    ;Copy 1111_2 into W
    MOVWF Counter_L ;Copy Contents of W into "Counter Low"
LOOP_INNER:
    NOP		    ;time delay created in program runtime
    DECF Counter_L,F;Examine Contents of "Counter Low" and decrement by 1
    BNZ LOOP_INNER  ;If Loop Inner is 1, then continue,
    DECF Counter_H,F;Examine Contents of "Counter High" and decrement by 1
    BNZ LOOP_OUTER  ;If "Loop Outer" is 1, then restart "Loop Outer"
RETURN
; end of subroutine ?DELAY_ONE_SEC?
 END
END