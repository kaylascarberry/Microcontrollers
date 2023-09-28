;Lab4 Part G: This Program contains multiple functions that can be controlled
;by the dip switches at the input.
;Table 14, Kayla Scarberry and Ezekiel Zizo
    
 #include <P18F4620.inc>;Header Files
    
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
 MOVLW 0x00		;
 MOVWF TRISC		; TRISC = 0x00
 MOVWF TRISE		; TRISE = 0x00
 MOVLW 0X07 
 MOVWF TRISD		;TRISD = 0x07

MAIN_LOOP:
    BTFSC   PORTD,2	;If PORTD, bit 2 = 0 then go to next instruction
    GOTO    PORTD2EQ1	;Go to sub-instruction PORTD2EQ1
    GOTO    PORTD2EQ0	;Go to sub-instruction PORTD2EQ0

;Sub instructions determined by the input
PORTD2EQ1:
    GOTO TASK_BCD	;Go to TASK_BCD
    
PORTD2EQ0:
    BTFSC   PORTD,1	;If PORTD, bit 1 = 0, then go to next instruction
    GOTO    PORTD21EQ01 ;Go to sub-instruction PORTD21EQ01
    GOTO    PORTD21EQ00 ;Go to sub0instruction PORTD21EQ00
    
PORTD21EQ01:
    BTFSC   PORTD,0	;If PORTD, bit 0 = 0, then go to next instruction
    GOTO    TASK_XOR	;Go to TASK_XOR
    GOTO    TASK_AND	;Go to Task_AND
    
PORTD21EQ00:
    BTFSC   PORTD,0	;If PORTD, bit 0 = 0, then go to next instruction
    GOTO    TASK_ADD	;Go to TASK_ADD
    GOTO    TASK_COMP	;Go to TASK_COMP
 
;Task instructions to run the function indicated by the dip switches
    
TASK_COMP:;When instruction is set to 000, go to SUB_COMP
    BCF	    PORTD,6	
    BCF	    PORTD,5	
    BCF	    PORTD,3
    CALL    SUB_COMP
    GOTO    MAIN_LOOP
    
TASK_ADD: ;When instruction is set to 001, go to SUB_ADD
    BCF	    PORTD, 6 ;
    BCF	    PORTD, 5 ;
    BSF	    PORTD, 3 ;
    CALL    SUB_ADD
    GOTO    MAIN_LOOP
    
TASK_AND: ;When instruction is set to 010, go to SUB_AND
    BCF     PORTD, 6 ;
    BSF     PORTD, 5 ;
    BCF     PORTD, 3 ;
    CALL    SUB_AND
    GOTO    MAIN_LOOP

TASK_XOR: ;When instruction is 011, go to SUB_XOR
    BCF     PORTD, 6 ;
    BSF     PORTD, 5 ;
    BSF     PORTD, 3 ;
    CALL    SUB_XOR
    GOTO    MAIN_LOOP

TASK_BCD:;When instruction is 100, go to SUB_BCD
    BSF     PORTD, 6 ;
    BCF     PORTD, 5 ;
    BCF     PORTD, 3 ;
    CALL    SUB_BCD
    GOTO    MAIN_LOOP    

SUB_COMP: ;Sub instruction to find the complent of the input from Port A
    MOVF PORTA,W	;Move contents of PORTA A to register W
    ANDLW 0x0F		;Clear 4 Significant bits
    MOVWF InA		;Move W into variable InA
    COMF  InA, W	;Complement W with InA
    ANDLW 0x0F		;masking 4 msbs to 0
    MOVWF Result	;Move W into variable Results
    MOVFF Result,PORTC	;Move contents of Results into PORTC

    BZ TEST1		;If Zero Flag is 1, Jump to TEST
    BCF PORTE, 0	;Change Bit 0 to 0 without changing other bits

    
TEST1:
    BSF PORTE,0		;Check for Z Flag
    RETURN
    
SUB_ADD: ;Sub instruction to find the sum of inputs from PortA and PORTB
    MOVF PORTA,W	;Move contents of PORTA A to register W
    ANDLW 0x0F		;Clear 4 Significant bits
    MOVWF InA		;Move W into variable InA
    MOVWF Result	;Move W into variable Results
    
    MOVF PORTB,W	;Move contents of PORTB to register W
    ANDLW 0x0F		;Clear 4 Significant bits
    MOVWF InB
    ADDWF Result,W
    MOVWF PORTC		;Move contents of W into PORTC
    BZ TEST2		;If Zero Flag is 1, Jump to TEST
    BCF PORTE, 0	;Change Bit 0 to 0 without changing other bits

    
TEST2:	
    BSF PORTE,0		;Check for Z Flag
    RETURN
    
SUB_AND: ; Sub instruction to AND the inputs from PORTA and PORTB
    MOVF PORTA,W	;Move contents of PORTA A to register W
    ANDLW 0x0F		;Clear 4 Significant bits
    MOVWF InA		;Move W into variable InA
    MOVWF Result	;Move W into variable Results

    BZ TEST3		;If Zero Flag is 1, Jump to TEST
    BCF PORTE, 0	;Change Bit 0 to 0 without changing other bits
   
    MOVF PORTB,W	;Move contents of PORTB to register W
    MOVWF InB
    
    ANDWF Result,W
    MOVWF PORTC		;Move contents of W into PORTC
    
      
TEST3:			;Check for Z Flag
    BSF PORTE,0
    RETURN
   
SUB_XOR: ;Sub instructions to XOR PORTA and PORTB
    MOVF PORTA,W	;Move contents of PORTA A to register W
    ANDLW 0x0F		;Clear 4 Significant bits
    MOVWF InA		;Move W into variable InA
    MOVWF Result	;Move W into variable Results
   
    MOVF PORTB,W	;Move contents of PORTB to register W
    MOVWF InB
    
    XORWF Result,W
    MOVWF PORTC		;Move contents of W into PORTC
    
    BCF PORTE, 0	;Change bit 0 to 0 without changing the other bits
    BNZ TEST4		;If Zero Flag is 1, jump to TEST4
    BSF PORTE,0
    RETURN
    
TEST4:			;Check for Z Flag  
    RETURN
    
SUB_BCD: ;Sub instructions to Find the BCD representation of the input
    MOVF PORTA, W	;Move contents of PORTA A to register W
    ANDLW 0x0F		;Clear 4 significant bits
    MOVWF InA		;Move W into InA
    
    MOVLW 0x09		;Move 0x09 into register W
    CPFSGT InA, 1	;Compare InA with W
    GOTO LESS
    GOTO GREATER
    
    LESS: ;if InA is less than 0x09, perform this set of instructions
    MOVF InA, W
    MOVWF Result
    ANDLW 0x0F
    MOVFF Result, PORTC
        
    GREATER: ;if InA is greater than 0x09, perform this set of instructions
    MOVLW 0x06
    ADDWF InA, W
    MOVWF Result
    MOVFF Result, PORTC
    GOTO Test5    

    Test5:		;Check for Z Flag
    BSF PORTE,0
    RETURN
    
 END    
    
