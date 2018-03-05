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
	_title		BYTE		"Sorting Random Integers               Programmed by Harshvardhan",0
	description	BYTE		"This program generates random numbers in the range [100 .. 999], displays the original list, sorts the list, and calculates the median value. Finally, it displays the list sorted in descending order. ",0
	quesetion0  BYTE		"How many numbers should be generated? [10 .. 200]: ",0
	output0		BYTE		"The unsorted random numbers:",0
	output1		BYTE		"The median is ",0
	output2		BYTE		"The sorted list is:",0
	error		BYTE		"Out of range. Try again.",0 
	num_gen		DWORD		?

	mybytes BYTE 12h,34h,56h,78h
	b WORD 1234h

.code
main proc
	; write your code here
	
	CALL introduction


	invoke ExitProcess,0
main ENDP

;---------------------------------------------------------------------------------------------------------
; INTRODUCTION
; Print general information about the program
;---------------------------------------------------------------------------------------------------------

introduction PROC
    pushfd							; Pushes all the flags
    mov edx, OFFSET _title
	CALL WriteString
	CALL CRLF
	CALL CRLF
	mov edx, OFFSET description
	CALL WriteString
	CALL CRLF
	CALL CRLF
	popfd							; Pops all the flags
	ret

introduction ENDP

;---------------------------------------------------------------------------------------------------------
;GETDATA
; gets the range of numbers
;---------------------------------------------------------------------------------------------------------

getdata PROC
    pushfd
	mov edx, OFFSET question0
	CALL WriteString
	Call ReadInt
	CALL CRLF
	mov num_gen, eax

	validate:
	    cmp eax, 10
		jl error_detected
		cmp eax,200
		jg error_detected
		jmp all_good

	error_detected:
	    mov edx, OFFSET error
		CALL WriteString
		CALL CRLF
		mov edx, OFFSET question0
		CALL WriteString
		CALL ReadInt
		mov num_gen,eax
		jmp validate

	all_good:
		popad
		ret

getdata ENDP


;---------------------------------------------------------------------------------------------------------
;FILLARRAY
;Fills the array with random numbers
;---------------------------------------------------------------------------------------------------------



end main