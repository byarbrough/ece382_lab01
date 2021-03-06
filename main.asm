;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
; Name: C2C Brian Yarbrough
; Section: ECE 382, T5
; MCU: MSP430G2553
; Lab 01: A Simple Calculator
; Description: This program reads byte instructions entered into ROM under the "ops" lable.
;		Addition is triggered by 0x11
;		Subtraction is triggered by 0x22
;		Multiplication is triggered by 0x33
;		Clearing is triggered by 0x44
;		End is triggered by 0x55
;			The numbers are entered as [operand], [instruction], [operand]
;			ie. 0x16, 0x11, 0xA5 --> 0x16 + 0xA5 = 0xBB (0xBB will be stored in RAM)
;		
; Date Due: 16 Sep 14
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;Enter calculator instructions here
ops:	.byte	0x22, 0x11, 0x22, 0x22, 0x33, 0x33, 0x08, 0x44, 0x08, 0x22, 0x09, 0x44, 0xff, 0x11, 0xff, 0x44, 0xcc, 0x33, 0x02, 0x33, 0x00, 0x44, 0x33, 0x33, 0x08, 0x55

fOp:	.equ	r5	;register for the first number
sOp:	.equ	r6	;register for the second number
tsk:	.equ	r7	;register for the instruction
res:	.equ	r8	;register for the result
point:	.equ	r9	;register for pointer
mem:	.equ	r10	;register for memory location

;--------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------

		mov		#ops, point	;point first op at string of numbers
		mov		#0x200, mem	;starting locaiton for memroy

cleared	mov.b	@point+, fOp ;fOp = value at point
again	mov.b	@point+, tsk ;tsk = the next number

chkEnd	cmp.b	#0x55, tsk	;check for end command
		jz		end			;terminate program

chkClr	cmp.b	#0x44, tsk	;check for clear command
		jz		clear
;if not ended or clear, do arithmitic

		mov.b	@point+, sOp	;load the second operand into register

chkAdd	cmp.b	#0x11, tsk	;check if operation is add
		jnz		chkSub		;jump if not add
		add.b	fOp, sOp	;numbers are added
		mov.b	sOp, res
		jc		over		;overflow
		jmp		store		;store sum

chkSub	cmp.b	#0x22, tsk	;check if opperation is subtract
		jnz		mult
		cmp.b	sOp, fOp	;check if subtraction will produce a negative
		jl		under
		mov.b	fOp, res	;otherwise, subtract
		sub.b	sOp, res
		jmp 	store		;store difference

mult	clr.b	res			;clear result
nextBit	clrc
		rrc.b	sOp			;load the LSB of the sOP into c
		jc		plus		;if LSB was 1, add it

dunPlus	tst.b	sOp
		jz 		store		;done multiplying
		clrc
		rlc.b	fOp			;multiply fOp by 2
		jc		over		;handle overflow
		tst.b	fOp
		jz		store
			;if either number is zero, finished
		jmp		nextBit

plus	add.b	fOp, res
		jmp		dunPlus

;submethods
clear	mov.b	#0x00, 0(mem);store a zero in memory
		inc 	mem
		jmp		cleared		;resume program with fresh number

store	mov.b	res, 0(mem)	;store result in memory
		inc		mem
		mov.b	res, fOp	;load for next operaiton
		jmp		again		;resume program with opcode

over	mov.b	#255, res	;default to max value
		jmp		store		;resume storage

under	mov.b	#0, res		;default to zero
		jmp		store

end		jmp		end	;infinite loop

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
