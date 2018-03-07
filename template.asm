TITLE Program Template     (template.asm)

; Author:			   Harshvardhan Singh
; Course / Project ID: CS 271                 Date: 1/26/2018
; Description: Program 2

INCLUDE Irvine32.inc

;.386
;.model flat,stdcall
;.stack 4096
ExitProcess proto,dwExitCode:dword

	_min			EQU			10
	_max			EQU			200
	_lo				EQU			100
	_hi				EQU  		999

.data
	; declare variables here
	name		WORD		DUP(?)
	_title		BYTE		"Sorting Random Integers               Programmed by Harshvardhan",0
	description	BYTE		"This program generates random numbers in the range [100 .. 999], displays the original list, sorts the list, and calculates the median value. Finally, it displays the list sorted in descending order. ",0
	question0   BYTE		"How many numbers should be generated? [10 .. 200]: ",0
	output0		BYTE		"The unsorted random numbers:",0
	output1		BYTE		"The median is ",0
	output2		BYTE		"The sorted list is:",0
	error		BYTE		"Out of range. Try again.",0 

	min			DWORD		_min
	max			DWORD		_max
	lo			DWORD		_lo
	hi			DWORD		_hi

	num_gen		DWORD		?
	array		DWORD		_max DUP(?)

	j			DWORD		?
	temp		DWORD		?
	temp1		DWORD		?
	spaces		BYTE		"   ",0
	mybytes BYTE 12h,34h,56h,78h
	b WORD 1234h

.code
main proc
	; write your code here
	
	CALL Randomize
	push OFFSET _title
	push OFFSET description
	CALL introduction
	
	push OFFSET num_gen
	CALL getdata
	
    push OFFSET array						;0		36
	
	PUSH num_gen							;4		32
	PUSH lo									;8		28
	PUSH hi									;12		24		16
	CALL fillarray							;16		20
	

	push num_gen							;4 as array is still on the stack0
    CALL _SORT

    push num_gen
	CALL sorted
	invoke ExitProcess,0
main ENDP

;---------------------------------------------------------------------------------------------------------
; INTRODUCTION
; Print general information about the program
;---------------------------------------------------------------------------------------------------------

introduction PROC
    push edx							; Pushes all the flags
	push ebp
	mov ebp,esp
	mov edx, OFFSET _title
	CALL WriteString
	CALL CRLF
	CALL CRLF
	mov edx, OFFSET description
	CALL WriteString
	CALL CRLF
	CALL CRLF
	pop ebp
	pop edx
	ret 8

introduction ENDP

;---------------------------------------------------------------------------------------------------------
;GETDATA
; gets the range of numbers
; ALL VALUES POPPED INSIDE + ADDRESS OF NUM_GEN
;---------------------------------------------------------------------------------------------------------

getdata PROC
    push eax
	push edx
	push esp
	push ebp
	
	mov edx, OFFSET question0
	CALL WriteString
	Call ReadInt
	CALL CRLF
	mov ebp, [esp+20]
	mov [ebp], eax

	validate:
	    cmp eax, min
		jl error_detected
		cmp eax, max
		jg error_detected
		jmp all_good

	error_detected:
	    mov edx, OFFSET error
		CALL WriteString
		CALL CRLF
		mov edx, OFFSET question0
		CALL WriteString
		CALL ReadInt
		mov [ebp],eax
		jmp validate

	all_good:
		pop ebp
		pop esp
		pop edx
        pop eax
		
	ret 4

getdata ENDP


;---------------------------------------------------------------------------------------------------------
;FILLARRAY
;Fills the array with random numbers
;---------------------------------------------------------------------------------------------------------

fillarray PROC
	
	push eax							;20
	push ecx							;24
	push edx							;28
	push ebp							;32

    mov ebp,esp							; Moves the offset of the stack pointer
    mov esi,[ebp+32]					; Moves the OFFSET of the arraymov 
	mov ecx,[ebp+28] 					; Moves the total number of array elements to be obtained
	mov temp,ecx
	
	mov edx, 0
	
	L1:
	    mov eax,[ebp+20]					; Move the value for max into eax
		;mov temp,eax
		sub eax,[ebp+24]					; subtract low from eax (high)
		;mov temp,eax
		inc eax								; Increment for the random range function to stop at the previous value
		CALL RandomRange
		add eax, [ebp+24] 					; Gets a value in the range 100, 999
		mov [esi+edx],eax
		mov eax,[esi+edx]
		mov temp,eax
		add edx,4

		loop L1
		
	pop ebp
	pop edx
	pop ecx
	pop eax
	ret 12						; Will not pop the array

fillarray ENDP

;---------------------------------------------------------------------------------------------------------
; Sort
; Will sort the array
;---------------------------------------------------------------------------------------------------------

_SORT PROC

	push ebp
	push eax
	push ecx

	   mov ebp, esp
	   mov ecx, [ebp+16]                           ; ecx = num_gen
	
	upper_loop:
	   mov edi, [ebp+20]                           ;array's current element
	   mov eax, ecx
	lower_loop:
	   mov edx, [edi]
	   mov ebx, [edi+4]
	   cmp ebx, edx
	   jle next_iteration                           ; Performs the comparison
	   mov [edi], ebx                               ; Will switch the numbers
	   mov [edi+4], edx
	next_iteration:
	   add edi, 4
	   loop lower_loop
	   
		mov ecx, eax
	   loop upper_loop
  
	pop ecx	
	pop eax
	pop ebp
	ret 4

_SORT ENDP

;---------------------------------------------------------------------------------------------------------
; Sorted
; Prints the sorted array
;---------------------------------------------------------------------------------------------------------

SORTED PROC

	mov edx, OFFSET output0
	CALL WriteString
	CALL CRLF

	mov ebp,esp
	mov ecx,[ebp+4]
	mov edi,[ebp+8]
	mov eax,0
	mov ebx,0
	mov edx,0
	mov esi,0

	L1:
		mov eax,[edi+4*ebx]
		cmp edx,10
		jge _placeholder
		_back:
			CALL WriteDec
			mov esi,edx
			mov edx, OFFSET spaces
			CALL WriteString
			mov edx,esi
			mov esi,0
		inc edx
		add ebx,1
		loop L1
		JMP EXITt

		_placeholder:
			CALL CRLF
			mov edx,0
			jmp _back
		exitt:
 			ret 8


SORTED ENDP

end main














