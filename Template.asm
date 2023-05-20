TITLE Program Template     (template.asm)

; Author: Fernando I. Rodriguez-Estrada	 
; Last Modified: 5/27/2023
; OSU email address: rodrifer@oregonstate.edu
; Course number/section:   CS271 Section 40X
; Project Number: 5	           Due Date: 5/28/2023
; Description: 

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

testArray			DWORD       100,200, 100,30,400,500,1 ,2, 2, 3, 3, 3, 3 ,3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5 ,5 
testLengthArray     DWORD       LENGTHOF testArray  
rowIndex			DWORD		?	

; displayArray
rowLength			DWORD		20
numberRows			DWORD		?
space				DWORD		' ', 0

.code
main PROC

call testProc


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

; ---------------------------------------------------------------------------------
; Name: procedureName
;
; Description:
;
; Preconditions:
;
; Postconditions:
;
; Returns:
;
; ---------------------------------------------------------------------------------

testProc PROC	

	PUSH	OFFSET testArray
	PUSH	testLengthArray

	call	displayArray
RET
testPROC ENDP

; ---------------------------------------------------------------------------------
; Name: procedureName
;
; Description: Prints 20 elements per row.
;
; Preconditions: array OFFSET and array length are pushed to stack, respectively.
;
; Postconditions:
;
; Returns:
;
; ---------------------------------------------------------------------------------
displayArray PROC
	PUSH	ESP
	PUSH	EBP	
	MOV		EBP, ESP

_loadArray:		
	MOV		EDI, [EBP+12]				; EDI = LENGTHOF inputArray
	MOV		ESI, [EBP+16]				; [ESI] = inputArray[0] 

_calculateRows:	
	MOV		EAX, EDI
	MOV		EDX, 0
	MOV		EBX, rowLength 
	DIV		EBX						
	MOV		numberRows, EDX

	MOV		ECX, numberRows
_printRow:

	PUSH	ECX	
	MOV		ECX, rowLength 
_printElement:
	MOV		EAX, [ESI]
	call	WriteDec
	; print " "
	MOV		EDX, OFFSET space
	call	WriteString	
	ADD		ESI, 4								; [ESI] = inputArray.next()
	LOOP	_printElement	
	POP		ECX 
	call	CrlF
	LOOP	_printRow
	POP		EBP
	POP		ESP
	
RET		8
displayArray ENDP

END main
