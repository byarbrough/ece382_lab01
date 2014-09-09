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
ops:	.byte	0x14, 0x11, 0x12, 0x55

fOp:	.equ	r5	;register for the first number
sOp:	.equ	r6	;register for the second number
tsk:	.equ	r7	;register for the instruction
point:	.equ	r8	;register for pointer
mem:	.equ	r9	;register for memory location

;--------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------

		mov.b	#ops, point	;point first op at string of numbers
		mov		#0x200, mem	;starting locaiton for memroy

cleared	mov.b	@point+, fOp ;fOp = value at point
again	mov.b	@point+, tsk ;tsk = the next number

chkEnd	cmp.b	#0x55, tsk	;check for end command
		jz		end			;terminate program

chkClr	cmp.b	#0x44, tsk	;check for clear command
		jz		clear
;if not ended or clear, do arithmitic

		mov.b	@point+, sOp	;load the second operand into register

chkAdd	cmp.b	#0x11, tsk	;compare the opperand
		jnz		chkSub		;jump if not add
		add.b	fOp, sOp	;numbers are added
		jmp		store		;store sum

chkSub	sub.b	fOp, sOp
		jmp 	store		;store difference


end		jmp		end	;infinite loop

;submethods
clear	jmp		cleared	;resume program

store	mov.b	sOp, mem	;store result in memory
		inc		mem
		jmp		again	;resume program with opcode

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
