TITLE Program Template     (template.asm)

; Author: Fernando I. Rodriguez-Estrada	 
; Last Modified: 5/27/2023
; OSU email address: rodrifer@oregonstate.edu
; Course number/section:   CS271 Section 40X
; Project Number: 5	           Due Date: 5/28/2023
; Description: 

INCLUDE Irvine32.inc

; (insert macro definitions here)
ROW_LENGTH = 20

; fillArray PROC
LO = 20
HI = 30
ARRAYSIZE = 200

; (insert constant definitions here)

.data

testArray				DWORD       100,200,30,400,500,1 ,2, 2, 3, 3, 3, 3 ,3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5 ,5 , 3, 3, 3, 3, 3, 3,3, 3, 3, 3, 3, 3, 3,  3
testArrayLength		    DWORD       LENGTHOF testArray  
rowIndex				DWORD		?	


; displayArray
rowLength				DWORD		20
numberRows				DWORD		?
space					DWORD		' ', 0
inputArrayOFFSET		DWORD		?
currentRowLength		DWORD		?

; fillArray
randomElements			DWORD		ARRAYSIZE DUP(?)
randomElementsIndex		DWORD		?

; exchangeElements	
tempIndex				DWORD		? 
tempValue				DWORD		?

	
.code
main PROC

	call	Randomize
	call	testProc
	;call	fillArray
	;PUSH	ARRAYSIZE
	;PUSH	OFFSET randomElements
	;call	displayArray


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
	MOV		EBX, OFFSET testArray
	ADD		EBX, 4
	PUSH	EBX	
	call	exchangeElements	


RET
testPROC ENDP

; ---------------------------------------------------------------------------------
; Name: fillArray		
;
; Description: fills the array with random elements between the two specified bounds
;
; Preconditions: LO, HI, and ARRAY_SIZE are declared in the data segment
; array address is declared in .data, and arrayAddress OFFSET is pushed to the PROC
;
; Postconditions: EAX is modified; new array holds values
;
; Returns:
;
; ---------------------------------------------------------------------------------

fillArray PROC	

	MOV		ESI, OFFSET randomElements			; ESI = index of randomElements
	MOV		ECX, ARRAYSIZE	
_appendElements:
; --------------------------
; get randomNumber betweenm [LO, HI]
; EAX = randomeNumber
; --------------------------
_getRandomNumber:
	MOV		EAX, HI
	INC		EAX
	call	RandomRange
	; if randomNumber < LO: JMP _getRandomNumber
	CMP		EAX, LO	
	JB		_getRandomNumber					; EAX = randomNumber

; --------------------------
; add element to randomElements Array 
; --------------------------
_addElementToArray:	
	MOV		[ESI], EAX							; randomElements[ESI] = randomNumebr
	ADD		ESI, 4
	LOOP	_appendElements

RET
fillArray ENDP

; ---------------------------------------------------------------------------------
; Name: procedureName
;
; Description: Prints 20 elements per row.
;
; Preconditions: array OFFSET and array length are pushed to stack, respectively.
;
; Postconditions: NA	
;
; Returns: NA
;
; ---------------------------------------------------------------------------------
displayArray PROC
	PUSH	ESP
	PUSH	EBP	
	MOV		EBP, ESP

_loadArray:		
	MOV		ESI, [EBP+12]				; [ESI] = inputArray
	MOV		EDI, [EBP+16]				; EDI = LENGTHOF inputArray


; for(i=LENGTHOF inputArray; i > 0; i --) {
	MOV		ECX, EDI
_printElement:
	MOV		EAX, [ESI]
	call	WriteDec	
	; print(' ')
	MOV		EDX, OFFSET space
	call	WriteString					
	ADD		ESI, 4
	INC		currentRowLength	
_indentConditionally:	
	; if currentRowLengthl < rowLength: JMP printElement 
	; else: CrLf
	MOV		EBX, currentRowLength 
	CMP		EBX, ROW_LENGTH 
	JNE		_continue	
	call	CrlF
; --------------------------
; reset currentRowLength
; --------------------------
	PUSH	EAX
	MOV		EAX, 0
	MOV		currentRowLength, EAX
	POP		EAX

_continue:
	LOOP	_printElement
	
	POP		EBP
	POP		ESP
	
RET		8
displayArray ENDP

exchangeElements PROC	
	PUSH	ESP	
	PUSH	EBP	
	MOV		EBP, ESP

	MOV		ESI, [EBP+12]							; ESI = indexOne
	MOV		EDI, [EBP+16]							; EDI = indexTwo

	; tempValue = [indexOne]

_useTemptsToSwitchElements:
; [indexOne], [indexTwo] = [IndexTwo], [indexOne]
	MOV		EAX, [EDI]
	MOV		EBX, [ESI]
	MOV		[ESI], EAX 
	MOV		EAX, EBX 
	MOV		[EDI], EAX

	MOV		EAX, [ESI]
	call	WriteDec

	MOV		EAX, [EDI]
	call	WriteDec
	
	POP		EBP
	POP		ESP
RET	8
exchangeElements ENDP

END main
