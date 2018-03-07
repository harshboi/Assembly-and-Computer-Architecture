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

	mybytes BYTE 12h,34h,56h,78h
	b WORD 1234h

.code
main proc
	; write your code here
	
	CALL Randomize

	CALL introduction
	
	push OFFSET num_gen
	CALL getdata
	
    push OFFSET array						;0		36
	
	PUSH num_gen							;4		32
	PUSH lo									;8		28
	PUSH hi									;12		24		16
	CALL fillarray							;16		20
	
	push temp1
	push temp
	push j
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
	ret 

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
	push eax
	push ebx
	push ecx
	push edx
	push ebp
	
	mov ecx,10

	mov ebp,esp  						; Store a copy of the stack pointer in EBP (Base Pointer) so that we don;t lose ESP
	mov edi,[ebp+40]
	mov ecx,[ebp+24]					; Stores the number of elements in the array

	mov eax,0
	mov ebx,0
	l4:
		mov eax,[edi+4*ebx]
		inc ebx
		CALL WriteInt
		CALL CRLF
		loop l4
	
	mov ecx,[ebp+24]					; Stores the number of elements in the array
	mov eax,0							; eax = k
	dec ecx								; k < request-1
	
	selection_sort:
		mov esi,eax						; i = k
	    mov ebx,[edi+(4*esi)]			; ebx = array[i]`				; i = k
		
		inc eax
		mov [ebp+28],eax				; j = k+1
		dec eax

		L1:											; Inner for loop
            
			mov [ebp+32],eax						; storing eax in temp
			mov eax,[ebp+28]						; Storing j in eax, value of k lost for the moment
			mov edx,[edi+4*eax]						; edx = array[j], j = i+1
			mov eax,[ebp+32]						; Bringin k from temp to eax

			cmp edx,ebx								; array[j]>array[i]
			jg greater
			jmp next_iter
						

		next_iter:
			mov [ebp+32],eax						; Storing k in temp
			mov eax,[ebp+28]						; Storing j in eax
			inc eax									; j++
			cmp eax,[ebp+24]						; if(j<num_array)
			je end_inner_loop
			mov [ebp+28],eax						; transfer incremented j
			mov eax,[ebp+32]						; Restore k to eax
			jmp L1
		
		swap:
			mov [ebp+32],eax						; Saving k in temp
			mov edx,eax
			mov eax,[edi+4*eax]						; eax = array[k]
			mov [ebp+36],eax						; Store eax (array[k]) in temp1
			mov	[edi+(4*edx)],ebx					; array[k] = array[i]
			mov ebx,[ebp+36]						; ebx = array[k] stored in temp1
			mov [edi+(4*esi)],ebx
			mov eax,edx
			jmp place_holder
		
		greater:
			mov esi,[ebp+28]						; i = j
			mov ebx,[edi+(4*esi)]					; ebx = array[i]`				; i = k

			jmp next_iter							; checks for the next inner or outer iteration
			
		end_inner_loop:
			mov eax,[ebp+32]						; Restore k to eax
			cmp eax, esi
			jne swap
			place_holder:
				inc eax
				loop selection_sort

		;greater:
		;	mov esi,[ebp+28]						; i = j
		;	mov ebx,[edi+(4*esi)]					; ebx = array[i]`				; i = k
;
;			jmp next_iter							; checks for the next inner or outer iteration
			
;		next_outer_loop:
;			inc eax
;			loop selection_sort
		
	pop ebp	
	pop edx
	pop ecx	
	pop ebx	
	pop eax	

	ret 16
_SORT ENDP

;---------------------------------------------------------------------------------------------------------
; Sorted
; Prints the sorted array
;---------------------------------------------------------------------------------------------------------

SORTED PROC

mov ebp,esp
mov ecx,[ebp+4]
mov edi,[ebp+8]
mov eax,0
mov ebx,0

L1:
	CALL CRLF
	mov eax,[edi+4*ebx]
    CALL WriteInt
	CALL CRLF
	add ebx,4
	loop L1

ret 8


SORTED ENDP

end main














