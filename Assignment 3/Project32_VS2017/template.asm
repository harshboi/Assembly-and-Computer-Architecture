TITLE Program Template     (template.asm)

; Author:			   Harshvardhan Singh
; Course / Project ID: CS 271                 Date: 1/26/2018
; Description: Program 2

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

program_name		BYTE	"Welcome to the Integer Accumulator by Harshvardhan Singh",0
my_name				BYTE	"Programmed by Harshvardhan Singh",0
question			BYTE	"What's your name? "
user_name			BYTE	21 DUP(?)
array				SDWORD   30 DUP(?)
sentence1			BYTE	"Please enter nubers in [-100,-1] ",0
sentence2			BYTE	"Enter a non-negative number when you are finished to see results",0
sentence3			BYTE	"Enter a number: ",0
num_entered			BYTE	"You entered ",0
num_entered2		BYTE	" valid numbers",0
sum_sentence		BYTE    "The sum of your valud numbers is ",0
sum					SDWORD  ?
average_sentence    BYTE	"The rounded average is ",0
average				SDWORD	?
final_mssg			BYTE	"Thank you for playing Integer Accumulator! Its been a pleasure to meet you, ",0
counter				DWORD	?
spaces				BYTE	"     ",0
bye					BYTE	"Live Long and Prosper ",0
error1				BYTE	"Number smaller than -100 entered, enter another number ",0


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
	mov esi,OFFSET array
	mov ebx,0
    
	take_input:
	  mov edx, OFFSET sentence3
	  CALL WriteString
	  CALL ReadInt
	  cmp eax,0
	  jge is_positive
	  cmp eax,-100
	  jl is_negative
	  mov [esi],eax
	  add esi,4
	  inc ebx
	  loop take_input
	 
	 is_positive:
	   mov counter,ebx				; Holds the number of elements in an array
	   mov edx, OFFSET num_entered
	   mov eax, counter
	   Call WriteInt
	   mov edx, OFFSET num_entered2
	   Call WriteString
	   mov eax,0
       mov ecx,counter
       mov esi, OFFSET array
	   jmp _sum

	  is_negative:
	    mov edx,OFFSET error1
		Call WriteString
		call crlf
		jmp take_input

	  _sum:
		 add eax, [esi]
		 add esi,4
		 loop _sum
	  
	  mov sum,eax



	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
