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
	;Call WriteString
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
    str_array   BYTE		12 DUP(?)			; 12 choosen so as to check if the number exceed the max for a 32 bit register; 10 digit number is the biggest that can be put into the ECX register
; Max +ve number that can be stored in ecx is 2^32-1 (FFFFFFFFh). Reason for str_array being 12 is that a number taken as an ASCII string will take a byte in memory, This byte will be converted to
; an actual number which will be smaller than a byte
	num_array	DWORD		10 DUP(?)
	temp		BYTE		21 DUP(0)	
	num			BYTE		 4 DUP(0)
	sum			DWORD		?
	tem			DWORD		?
	iterator	DWORD		?

	mybytes BYTE 12h,34h,56h,78h
	b WORD 1234h

.code
main proc
	; write your code here
	
	CALL introduction
	
	;mov ecx,12
	;mov edx, OFFSET str_array
	;CALL ReadString
	;mov edx, OFFSET str_array
	;add edx,10
	;mov eax,[edx]
	;cmp eax,127
	;je quitt

	mov iterator,0
	push iterator					;44
	;quitt:
	push tem						;40
	mov sum,0	
	push sum						;36
	push OFFSET num_array			;32
	push OFFSET str_array			;28
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

readVal PROC		;24
	
	push eax		;20
	push ebx		;16
	push ecx		;12
	push edx		;8
	push ebp		;4
	push edi		;0

	mov ebp,esp
	; add multiple input loop/recurssion
	get_user_input:
		mov edi,[ebp+28]				;Stores the offset of the array
		getstring edi
		mov esi,edi						; Storing the offset of the array in esi
		cld

		mov ecx,12
		mov ebx,0		
		
		loop1:
			inc ebx

			lodsb						; mov esi to eax  Use lodsb instead of lodsd as lodsd (lods doubleword) takes a doubleword in, instead of a byte (lods byte (lodsb))
			
			cmp ebx,11					; checks wether the number will fit into the ECX register
			je exceed_size_check
			all_good:
			cmp eax,00
			je string_finish			; when the NULL character is inserted
			cmp eax,48					; eax = str[k]
			jl wrong_num
			cmp eax,57
			jg wrong_num
			
			; Adds the sum for characters
			complete_number:			; will be primarily changed for -ve number approach
				
				pushad

				mov ebx, eax			; is the value of k
				mov eax, [ebp+36]		; is the added sum (starts from 0)
				mov edx,10
				mul edx					; x = 10 * x, x = sum
				sub ebx,48				; k - 48, where k = str[k]
				add eax,ebx				; x = 10 * x + (k-48)
				mov [ebp+36],eax		; Storing sum back in memory
				
				popad
			
			
			loop loop1

	; Call recurvsively from this function and have a jump on the next line towards the end of the array
	
	store_num_array:
		mov eax,[ebp+36]
		mov edx,[ebp+44]
		mov edi,[ebp+32]
		mov [edi+edx],eax
		;dont forget to reset sum to 0

	string_finish:
		mov edi,[ebp+36]
		cmp edi,4294967295
		jle store_num_array
		mov edx,OFFSET error
		CALL WriteString
		CALL CRLF
		mov eax,0
		mov [ebp+36],eax						; Resets sum (sum = 0)
	
	exceed_size_check:							; checks the physical size i.e. more then 10 digits
		;mov esi, [edi+10]						; not possible as str_array is a byte array and esi holds 4 bytes (Complete Register)\
		;lodsb									; not needed a performed at the beginning of the function
		cmp eax,00
		je all_good
		mov edx,OFFSET error
		CALL WriteString
		CALL CRLF
		jmp get_user_input

	wrong_num:
		; add exception for -ve numbers
        mov edx,OFFSET error
		CALL WriteString
		CALL CRLF
		mov eax,0
		mov [ebp+36],eax
		jmp get_user_input
	    

		jmp get_user_input
		;iterator++	
	
	pop edi
	pop ebp
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

readVal ENDP


end main