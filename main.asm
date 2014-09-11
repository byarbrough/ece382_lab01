;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
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
ops:	.byte	0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0xDD, 0x44, 0x08, 0x22, 0x09, 0x44, 0xFF, 0x22, 0xFD, 0x55

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

mult	jmp		end		;bit.b 	#1, sOp		;is the multiplier odd
;		jz		times		;no, is even
;		mov.b	fOp, res
;		dec		sOp			;the first multiplication
;times	cmp.b	sOp
;		jz		doneMult	;jump if done multiplying
;		rla.b
;		jmp		times		;next iteration


end		jmp		end	;infinite loop

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
