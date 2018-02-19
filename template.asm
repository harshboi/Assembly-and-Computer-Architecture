TITLE Program Template     (template.asm)

; Author:			   Harshvardhan Singh
; Course / Project ID: CS 271                 Date: 1/26/2018
; Description: Program 2

INCLUDE Irvine32.inc

;.386
;.model flat,stdcall
;.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	; declare variables here
	name		WORD		DUP(?)
	_title		BYTE		"Composite Numbers		programmed by Harshvardhan",0
	info1		BYTE		"Enter the number of composite numbers you would like to see.",0
	info2		BYTE		"I accept orders for upto 400 composites ",0
	question	BYTE		"Enter the number of composites to display [1-400]: ",0
	error		BYTE		"Out of range. Try again.",0
	empty		BYTE		"Number has no composites",0
	range		DWORD		?
	composites  DWORD		?
	jack		DWORD		?
	spaces		BYTE		"   ",0
	lines		DWORD		?
.code
main proc
	; write your code here

	CALL introduction
	CALL GetUserData
	CALL ShowComposites

	invoke ExitProcess,0
main ENDP

;---------------------------------------------------------------------------------------------------------
;Introduction
;Prints out the description and rules for the programs
;---------------------------------------------------------------------------------------------------------

introduction proc
	mov edx, OFFSET _title
	CALL WriteString
	CALL CRLF
	CALL CRLF
	mov edx, OFFset info1
	CALL WriteString
	CALL CRLF
	mov edx, OFFset info2
	CALL WriteString
	CALL CRLF
	CALL CRLF
	ret

introduction ENDP

;---------------------------------------------------------------------------------------------------------
;GetUserData
;Takes in data from the user and checks wether the number is in the correct range
;
;---------------------------------------------------------------------------------------------------------

GetUserData proc
	

	mov edx, OFFSET question
	CALL WriteString
	CALL ReadInt
	mov range,eax
	CALL CRLF

	validate:
		cmp eax,0
		jle errorL
		cmp eax,400
		jg errorL
		ret

	errorL:
		mov edx, OFFSET error
		CALL WriteString
		call crlf
		jmp getuserdata

GetUserData ENDP

;---------------------------------------------------------------------------------------------------------
;ShowComposites
;Calculates and shows all the composite numbers one by one
;---------------------------------------------------------------------------------------------------------

ShowComposites PROC
	mov lines,0
	mov jack,eax				; Keeps a copy of eax

	cmp eax,3
	jle _nocomp					; checks if number entered is <= 3

	mov ecx,eax					; Sets the loop counter
	sub ecx,3					; Removes numbers 1,2,3 as these are handles seperately
	mov eax,4					; the first composite number to be checked
	mov ebx,2					; first divisor
	jmp iscomposite

	_nocomp:
		mov edx, OFFSET empty
		CALL WriteString
		jmp place_holder

	iscomposite:
		mov ebx,2
		
		mov jack,eax
		jmp has_factors			; Check if composite 
		
		p_holder1:
			add eax,1
		loop iscomposite
		
	jmp place_holder
	
	has_factors:
		mov edx,0
		push eax			;PUSH OPERATION PERFORMED
		div ebx
		cmp edx,0		; Check if the remainder is 0 (0 = factor)
		je done
		pop eax				;POP
		add ebx,1
		cmp eax,ebx
		jle p_holder1
		jmp has_factors

	done:
		cmp lines,10
		jne _ignorelinespace
		mov lines,0
		CALL CRLF
		_ignorelinespace:
			pop eax
			Call WriteDec
		mov edx,OFFSET spaces
		CALL WriteString
		;add print statement
		add lines,1
		jmp p_holder1
		
	place_holder:
		ret

ShowComposites ENDP

end main