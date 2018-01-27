TITLE Program Template     (template.asm)

; Author:			   Harshvardhan Singh
; Course / Project ID: CS 271                 Date: 1/26/2018
; Description: Program 2

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

program_name		BYTE	"			Program to calculate Fibonacci numbers",0
title				BYTE	"Student",0
my_name				BYTE	"Programmed by Harshvardhan Singh",0
question			BYTE	"What's your name? "
user_name			BYTE	21 DUP(?)
sentence1			BYTE	"Enter the number of Fibonacci terms to be displayed ",0
sentence2			BYTE	"Give the number as na integer in the range [1 .. 46]. ",0
sentence3			BYTE	"How many terms do you want? ",0
error				BYTE	"Out of range. Enter a number in [1 .. 46] ",0
Final_message		BYTE	"Results certified by Leonardo Pisano.",0
previous			DWORD	?
current				DWORD	?
input				DWORD	?
counter				DWORD	?
spaces				BYTE	"     ",0
bye					BYTE	"Live Long and Prosper ",0


; (insert variable definitions here)

.code
main PROC

	mov edx, OFFSET program_name
	call WriteString
	call crlf
	mov edx, OFFSET my_name
	call WriteString
	call crlf
	mov edx, OFFSET question
	CALL WriteString
	mov edx, OFFSET user_name
	mov ecx,32
	CALL ReadString						; Takes in the string name
	mov edx, OFFSET sentence1
	call WriteString
	call crlf
	mov edx, OFFSET sentence2
	CALL WriteString
	CALL readInt                        ; Takes in input
	cmp eax,46
	jg _incorrect
	mov input,eax
	back:
		mov ecx,input
		mov counter,0
		mov previous,1			;Holds the previous value
		mov eax,0				;Holds the final value

	L1:
		mov ebx,eax			; holds the previous value to be added in the next step
		add eax,previous	; eax has the new value
		mov previous,ebx	; holds the previous value
		mov current,eax		; holds the new value
		CALL WriteDec
		call _spaces
		_placeholder:
			inc counter
		mov edx, 0
		mov eax,counter		; Preparing for division
		mov ebx,5
		div ebx
		cmp edx,0
		je _newLine
		iL1:
			mov eax,current
			mov ebx,previous
		loop L1
		CALL crlf
		jmp _end

	_newLine:
		CALL crlf
		jmp iL1

	_spaces:
		mov edx, OFFSET spaces
		CALL WriteString
		jmp _placeholder

	_incorrect:
		mov edx, OFFSET error
		CALL WriteString
		call crlf
		mov edx,OFFSET sentence2
		CALL WriteString
		mov edx, OFFSET sentence3
		call crlf
		CALL WriteString
		call ReadInt
		cmp eax,46
		jg _incorrect
		mov input,eax
		jmp back


														;PG 202 ReadString for taking in input
	_end:
		mov edx, OFFSET Final_message
		CALL WriteString
		CALL crlf
		mov edx, OFFSET bye
		CALL WriteString
		mov edx, OFFSET user_name
		CALL WriteString

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
