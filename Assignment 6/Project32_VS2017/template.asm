TITLE Program Template     (template.asm)

; Author:			   Harshvardhan Singh
; Course / Project ID: CS 271                 Date: 3/08/2018
; Description: Program 6A, Designing low-level I/O procedures 
; OSU ID: 9717726420

INCLUDE Irvine32.inc

;.386
;.model flat,stdcall
;.stack 4096
ExitProcess proto,dwExitCode:dword

;---------------------------------------------------------------------------------------------------------
; getString macro
;
;---------------------------------------------------------------------------------------------------------

getString MACRO tem						;input is the offset of the array
	
	mov edx, tem
	mov ecx,20								; 10 digit number is the biggest that can be fit into the ecx register
	CALL ReadString
	Call WriteString
ENDM

.data
	; declare variables here
	name		WORD		DUP(?)
	_title		BYTE		"Program 6A, Designing low-level I/O procedures ",0
	_name		BYTE		"Written by: Harshvardhan Singh",0
	description BYTE		"Each number needs to be small enough to fit inside a 32 bit register.",0
	instruction	BYTE		"Please provide 10 unsigned numbers",0
	instruction1 BYTE		"Please enter an unsigned number: ",0
	output1		BYTE		"After you have finished inputting the raw numbers I will display a list of th eintegers, their sum and their average value",0
	error		BYTE		"ERROR: you did not enter an unsigned number or your number was too  big. Try again.",0 
	output2		BYTE		"You entered the following numbers: ",0
	output3		BYTE		"The sum of these numbers is: ",0
	output4		BYTE		"The average is: ",0
	gbyemssg	BYTE		"Thanks for playing!",0
    
	num_gen		DWORD		?
    array       BYTE		10 DUP(?)										; 10 digit number is the biggest that can be put into the ECX register
	num_array	DWORD		10 DUP(?)
	temp		BYTE		21 DUP(0)	
	num			BYTE		 4 DUP(0)	

	mybytes BYTE 12h,34h,56h,78h
	b WORD 1234h

.code
main proc
	; write your code here
	
	CALL introduction
	
	push OFFSET array
	CALL readVal
	


	invoke ExitProcess,0
main ENDP


;---------------------------------------------------------------------------------------------------------
; INTRODUCTION
; Print general information about the program
;---------------------------------------------------------------------------------------------------------

introduction PROC

	push eax
	push ebx
	push edx
	push ebp

	mov edx, OFFSET _title
	CALL WriteString
	CALL CRLF
	mov edx, OFFSET _name
	CALL WriteString
	CALL CRLF
	CALL CRLF
	mov edx, OFFSET instruction
	CALL WriteString
	CALL CRLF
	mov edx, OFFSET description
	CALL WriteString
	CALL CRLF
	mov edx, OFFSET output1
	CALL WriteString
	CALL CRLF
	CALL CRLF
	
	pop ebp
	pop edx
	pop ebx
	pop eax

	ret 

introduction ENDP


;---------------------------------------------------------------------------------------------------------
; Store
; 
;---------------------------------------------------------------------------------------------------------

readVal PROC
	
	push eax
	push ebx
	push ecx
	push edx
	push ebp
	push edi

	mov ebp,esp
	
	mov ecx,10
	mov edi,[ebp+28]
	mov edx, OFFSET instruction1
	CALL WriteString
	getString edi
	
	str_to_int:
        mov eax,0
		
	    
	
	
	pop edi
	pop ebp
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

readVal ENDP


end main