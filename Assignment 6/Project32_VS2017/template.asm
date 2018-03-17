TITLE Program Template     (template.asm)

; Author:			   Harshvardhan Singh
; Course / Project ID: CS 271                 Date: 3/08/2018
; Description: Program 6A, Designing low-level I/O procedures 
; OSU ID: 9717726420

INCLUDE Irvine32.inc
; divide by 10 and remainder is the character value
;.386
;.model flat,stdcall
;.stack 4096
ExitProcess proto,dwExitCode:dword

;---------------------------------------------------------------------------------------------------------
; getString macro
;
;---------------------------------------------------------------------------------------------------------

displayString MACRO tem

ENDM


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
	extra_credit BYTE		"Done as per extra credit",0
    
	num_gen		DWORD		?
    str_array   BYTE		12 DUP(?)			; 12 choosen so as to check if the number exceed the max for a 32 bit register; 10 digit number is the biggest that can be put into the ECX register
; Max +ve number that can be stored in ecx is 2^32-1 (FFFFFFFFh). Reason for str_array being 12 is that a number taken as an ASCII string will take a byte in memory, This byte will be converted to
; an actual number which will be smaller than a byte
	num_array	REAL4		10 DUP(?)
	temp		BYTE		21 DUP(0)	
	num			BYTE		 4 DUP(0)
	sum			SDWORD		?
	tem			SDWORD		?
	iterator	SDWORD		?
	average		SDWORD		?
	is_negative DWORD		?
	print_array	BYTE		12 DUP(?)
	
	mybytes BYTE 12h,34h,56h,78h
	b WORD 1234h

.code
main proc
	; write your code here
	

	mov eax,-12345
	mov esi,OFFSET num_array
	mov ecx,[esi]
		test eax,eax
		jl check
	push edx
	push eax
	check:
		push ecx


	CALL introduction
	
	;mov ecx,12
	;mov edx, OFFSET str_array
	;CALL ReadString
	;mov edx, OFFSET str_array
	;add edx,10
	;mov eax,[edx]
	;cmp eax,127
	;je quitt
	
	mov iterator,1
	push is_negative				;48
	push iterator					;44
	;quitt:
	push tem						;40
	mov sum,0	
	push sum						;36
	push OFFSET num_array			;32
	push OFFSET str_array			;28
	CALL readVal
	mov eax,[num_array+8]
	Call WriteInt
	
	mov sum,0
	mov tem,0
	mov iterator,1
	mov is_negative,0
	push is_negative				;48
	push iterator					;44
	push sum						;48
	push tem						;44
	push OFFSET num_array			;40
	push OFFSET print_array			;36
	


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
		mov edx,OFFSET instruction1
		Call WriteString
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
			
				num_is_neg:
			loop loop1

	; Call recurvsively from this function and have a jump on the next line towards the end of the array
	
	store_num_array:
		CLD								; Clears the direction flag for stosd
		mov eax,[ebp+44]				; mov iterator into edx
		dec eax
		mov edx,4
		mul edx
		mov edx,eax
		mov eax,[ebp+36]				; move sum into eax
		mov edi,[ebp+32]				; move num_array into edi
		STOSD							; store eax into edi
		mov edi,[ebp+32]				; move num_array into edi
		mov [edi+edx],eax
		mov eax,0
		mov [ebp+36],eax
		jmp recurse
		;dont forget to reset sum to 0
		; for recursive approach, look at exercise for week 9. Basically push everything pushed in main again

	string_finish:
		mov eax,[ebp+48]
		cmp eax,1
		jne is_pos
			mov eax,[ebp+36]
			not eax									; Will perform the 1s complement
			inc eax									; Performs the 2s complement
			mov [ebp+36],eax
		is_pos:
			mov edi,[ebp+36]
			cmp edi,2147483647
			jle store_num_array						; Don't use JLE as 4294967294 is evaluated as a -ve number
			mov edx,OFFSET error
			CALL WriteString
			CALL CRLF
			mov eax,0
			mov [ebp+36],eax						; Resets sum (sum = 0)
			jmp get_user_input
	
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
		dec ebx									; Check for a negative number
		cmp ebx,0
		jne place_holder
			cmp eax,45							; 45 is ASCII in dec for "-" character
			jne  place_holder
			mov edi,1
			mov [ebp+48],edi
			jmp num_is_neg	
		place_holder:
        mov edx,OFFSET error
		CALL WriteString
		CALL CRLF
		mov eax,0
		mov [ebp+36],eax
		jmp get_user_input
	    

		jmp get_user_input
		;iterator++	

	recurse:
		; ADD OUTPUT FOR AS DONE BY EXTRA CREDIT
		mov edi,[ebp+44]
		cmp edi,10
		je input_finished
		mov eax,[ebp+44]							; inc iterator will not work as iterator is not pushed onto the stack
        inc eax
		mov [ebp+44],eax
		mov eax,0
		mov [ebp+48],eax							; setting is_negative to 0
		push [ebp+48]
		push [ebp+44]
		push [ebp+40]
		push [ebp+36]
		push [ebp+32]								; is the offset num_array
		push [ebp+28]								; is the offset str_array
		CALL readVal
		input_finished:
			pop edi
			pop ebp
			pop edx
			pop ecx
			pop ebx
			pop eax
		ret 24
	;ret		
readVal ENDP

;---------------------------------------------------------------------------------------------------------
;
;
;---------------------------------------------------------------------------------------------------------

writeVal PROC

	pushad				;0 - 28
	
	mov ebp,esp
	mov esi,[ebp+40]					; Stores the offset of the numerical array
	mov edi,[ebp+36]					; Stores the offset of printing array
	;mov eax,[ebp+44]					; stores tem
	mov ecx,2

	conversion:
		mov eax,[esi+[ebp+44]]	; ebp + 4* iterator value
		jmp _is_neg
		pos_conversion:
			mov edx,0
			mov ebx,10
			div ebx
			add edx,48					; Holds the remainder
			mov ecx,eax					; saving eax, eax holds the quotient (will be used in the next iteration)
			mov eax,edx
			stosb
			mov eax,ecx
			cmp eax,0
			jg pos_conversion
			mov eax,[ebp+44]
			add eax,4
			mov [ebp+44],eax
			jmp done
	
	_is_neg:
		mov ecx,[esi]
		test ecx, ecx
		jl neg_conversion				; Will jump if negative
		jmp pos_conversion				; will jump if positive

	neg_conversion:
		not eax							; 1's complement
		inc eax							; 2's complement
		mov edx,0
		mov ebx,10
		div ebx
		add edx,48
		mov ecx,eax
		mov eax,edx
		STOSB
		mov eax,ecx
		cmp eax,0
		jg neg_conversion
		mov eax,[ebp+44]
		add eax,4
		mov [ebp+44],eax
		mov eax,54
		STOSB
		jmp done		

	done:
		; Call the macro for printing the number
		; call conversion for going to the next number
		;mov 

WriteVal ENDP

end main