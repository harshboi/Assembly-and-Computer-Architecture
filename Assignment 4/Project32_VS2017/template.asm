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
	range		DWORD		?
	composites  DWORD		?
	jack		DWORD		?

.code
main proc
	; write your code here

	CALL introduction
	CALL GetUserData

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



end main