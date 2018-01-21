TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc



; (insert constant definitions here)

.data
header			BYTE	"Elementary Arithmetic		by Harshvardhan Singh",0
_instructions   BYTE	"Enter 2 numbers, and I'll show you the sum difference, product, quotient, and remainder.",0
str1			BYTE    "Enter first number ",0
str2			BYTE    "Enter second number ",0
_sum			DWORD	 ?
first_num		DWORD	 ?
second_num		DWORD	 ?
_char			DWORD	 " + "
_equal			DWORD	 " = "
_minus			DWORD	 " - "
_multiply		DWORD	 " * "
_division		DWORD	 " / "

; (insert variable definitions here)

.code
main PROC

mov		edx, OFFSET	header
call	WriteString
call	crlf
call	crlf
;mov		edx, OFFSET	First_num
;call	ReadInt
mov		edx, OFFSET _instructions
call	WriteString
call	crlf
call	crlf

mov		edx, OFFSET str1
call	WriteString
call	ReadInt
mov		first_num, eax

mov		edx, OFFSET str2
call	WriteString
call	ReadInt
mov		second_num, eax
call	crlf

;					Code for Addition
mov eax,first_num 
add eax,second_num
mov ebx, first_num
mov _sum, eax
mov eax,first_num
call WriteDec
mov edx, OFFSET _char
;mov edx, _char
Call WriteString
mov eax,second_num
call WriteDec
 mov edx, OFFSET _equal
call WriteString
mov eax,_sum
call WriteDec

;					Code for subtraction
mov eax,first_num 
sub eax,second_num
mov ebx, first_num
mov _sum, eax
mov eax,first_num
call WriteDec
mov edx, OFFSET _minus
;mov edx, _char
Call WriteString
mov eax,second_num
call WriteDec
 mov edx, OFFSET _equal
call WriteString
mov eax,_sum
call WriteDec


;					Code for Multiplication
mov eax,first_num 
imul eax,second_num
mov ebx, first_num
mov _sum, eax
mov eax,first_num
call WriteDec
mov edx, OFFSET _multiply
;mov edx, _char
Call WriteString
mov eax,second_num
call WriteDec
 mov edx, OFFSET _equal
call WriteString
mov eax,_sum
call WriteDec; (insert executable instructions here)

;					Code for division
mov eax,first_num 
idiv eax,second_num
mov ebx, first_num
mov _sum, eax
mov eax,first_num
call WriteDec
mov edx, OFFSET _minus
;mov edx, _division
Call WriteString
mov eax,second_num
call WriteDec
 mov edx, OFFSET _equal
call WriteString
mov eax,_sum
call WriteDec
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
