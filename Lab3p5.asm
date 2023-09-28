;Lab 3 Part 5
;Kayla Scarberry and Ezekiel Zizo
; THIS FIFTH ASSEMBLY LANGUAGE PROGRAM WILL READ THE VALUES OF
; ALL THE BITS 0-2 OF PORT A AND OUTPUT THEM
; TO THE PINS 0 THROUGH 2 OF PORT C, PORT B, AND PORT E IN  
; CONTINUOUS COLOR CYCLE
    
;Header Files
#include <P18F4620.inc>

;Declarations
 config OSC = INTIO67
 config WDT = OFF
 config LVP = OFF
 config BOREN = OFF
Counter_L equ 0x20
Counter_H equ 0x21
Color_Value equ 0x28
Loop_Count equ 0x29
Delay1  equ 0xFF
Delay2	equ 0xFF

;Absolute Offset of First Start Function
 ORG 0x0000
 
 ;Array 1
a1 = 0x02
a2 = 0x00
a3 = 0x06
a4 = 0x07
a5 = 0x01
a6 = 0x05
a7 = 0x04
a8 = 0x03
 
 ;Array 2
b1 = 0x06
b2 = 0x00
b3 = 0x04
b4 = 0x07
b5 = 0x02
b6 = 0x03
b7 = 0x05
b8 = 0x01

START:
    
;Absolute Offset of Third Start Function
 ORG 0x0000
 
START:
    MOVLW   a1	    ;Copy Contents of a1 into W
    MOVWF   0x40    ;Copy Contents of W into Addresses 40-47
    MOVLW   a2	    
    MOVWF   0x41    
    MOVLW   a3	    
    MOVWF   0x42   
    MOVLW   a4	    
    MOVWF   0x43    
    MOVLW   a5	    
    MOVWF   0x44    
    MOVLW   a6 
    MOVWF   0x45 
    MOVLW   a7 
    MOVWF   0x46 
    MOVLW   a8 
    MOVWF   0x47 
    
    MOVLW   b1	    ;Copy Contents of b1 into W
    MOVWF   0x50    ;Copy Contents of W into Addresses 50-57
    MOVLW   b2 
    MOVWF   0x51 
    MOVLW   b3 
    MOVWF    0x52 
    MOVLW   b4 
    MOVWF   0x53 
    MOVLW   b5 
    MOVWF   0x54 
    MOVLW   b6 
    MOVWF   0x55 
    MOVLW   b7 
    MOVWF   0x56 
    MOVLW   b8 
    MOVWF   0x57 
    
    LFSR    0,0x0040 ;Copy Starting address 40 to FSR0
    LFSR    1,0x0050 ;Copy Starting Address 50 to FSR1
    
    MOVLW 0x0F	    ;Copy 1010_2 to W
    MOVWF ADCON1    ;Copy contents of W to ADCON1
    MOVLW 0x00	    ;Copy 0000_2 to W
    MOVWF TRISC	    ;Copy contents of W to TRISC making it an OUTPUT
    MOVLW 0x00	    ;Copy 0000_2 to W
    MOVWF TRISE	    ;Copy contents of W to TRISE making it an OUTPUT
    MOVLW 0x00	    ;Copy 0000_2 to W
    MOVWF TRISB	    ;Copy contents of W to TRISB making it an OUTPUT
    
WHILE_LOOP:	    ;Start of While Loop
 MOVLW 0x0040	    ;Copy FSR0 Address 40 to W
 MOVWF FSR0L	    ;Copy Contents of W to Low 8 bits of FSR0
 MOVLW 0x0050	    ;Copy FSR0 Address 50 to W
 MOVWF FSR1L	    ;Copy Contents of W to Low 8 bits of FSR1
 MOVLW 0x08	    ;copy value 1000_2 to W
 MOVLW 0x00	    ;Copy value 0000_2 to W
 MOVWF Color_Value  ;Copy Contents of W to Color Value (1000_2)
 MOVWF Loop_Count   ;Copy contents of W to Loop Count (0000)

FOR_LOOP: ;Start of For Loop
 MOVF Color_Value,W ;Copy contents of Color_Value to W
 MOVWF PORTB	    ;Copy Contents of W to PORTB
 MOVF INDF0,W	    ;Copy contents of INDF0 to W
 MOVWF PORTC	    ;Copy Contents of W to PORTC
 MOVF INDF1,W	    ;Copy Contents of INDF1 to W
 MOVWF PORTE	    ;Copy Contents of W to PORTE
 CALL DELAY_ONE_SEC ;Call The Delay 1 Second Function
 INCF Color_Value,F ;Increment Color_Value by 1
 INCF FSR0L	    ;Increment FSR0L by 1
 INCF FSR1L	    ;Increment FSR1L by 1
 DECF Loop_Count,F  ;Decrement Loop_Count by 1
 BNZ FOR_LOOP	    ;When FOR_Loop is 1, continue program
 ;
 GOTO WHILE_LOOP    ;Returns to start of while loop

; add the code for ?DELAY_ONE_SEC? here

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