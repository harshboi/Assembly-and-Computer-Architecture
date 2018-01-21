TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc



; (insert constant definitions here)

.data
header			BYTE	"Elementary Arithmetic		by Harshvardhan Singh",0
_instructions   BYTE	"Enter 2 numbers, and I'll show you the sum difference, product, quotient, and remainder.",0
first_num		DWORD	 ?
second_num		DWORD	 ?

; (insert variable definitions here)

.code
main PROC

mov		edx, OFFSET	header
call	WriteString
call	crlf
mov		edx, OFFSET	First_num
call	ReadInt
mov		edx, OFFSET _instructions
call	crlf

mov		edx, OFFSET "Enter first number "
mov		first_num, eax
call crlf

mov		edx, OFFSET "Enter second number "
call	ReadInt
mov		second_num, eax
call	crlf


; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
