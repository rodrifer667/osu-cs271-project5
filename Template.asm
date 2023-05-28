TITLE Program Template     (template.asm)

; Author: Fernando I. Rodriguez-Estrada	 
; Last Modified: 5/27/2023
; OSU email address: rodrifer@oregonstate.edu
; Course number/section:   CS271 Section 40X
; Project Number: 5	           Due Date: 5/28/2023
; Description: 

INCLUDE Irvine32.inc

; MACROS

printTestArray MACRO
	PUSHAD

	PUSH	ARRAYSIZE
	PUSH	OFFSET testArray
	call	displayArray	
	call	CrlF

	POPAD
ENDM

;-----------------------------------------------------------------
; Name: printElement 
; 
; prints the element along with a space.
; 
; Preconditions: address of index is passed as an argument.
;
; recieves
; indexAddress = address of index.
;
; returns: NA
;-----------------------------------------------------------------

printElement MACRO element

	MOV		EAX, element
	call	WriteDec	

	MOV		EDX, OFFSET space
	call	Writestring


ENDM

;-----------------------------------------------------------------
; Name: printSpace
; 
; prints the element along with a space.
; 
; Preconditions: address of index is passed as an argument.
;
; recieves
; indexAddress = address of index.
;
; returns: NA
;-----------------------------------------------------------------

printSpace MACRO 

	PUSH	EDX
	MOV		EDX, OFFSET space
	call	Writestring
	POP		EDX

ENDM

ROW_LENGTH = 20

; fillArray PROC
LO = 20
HI = 30
ARRAYSIZE = 16

; (insert constant definitions here)

.data

testArray				DWORD		12, 3, 34, 5, 2, 3, 43, 2, 2, 34, 2,2 ,3, 2,3, 34
testArrayLength		    DWORD       LENGTHOF testArray  
rowIndex				DWORD		?	
no						BYTE		"No", 0
yes						BYTE		"yes",	0


; displayArray
rowLength				DWORD		20
numberRows				DWORD		?
space					DWORD		' ', 0
inputArrayOFFSET		DWORD		?
currentRowLength		DWORD		1
inputArrayLength		DWORD		?

; fillArray
randomElements			DWORD		ARRAYSIZE DUP(?)
randomElementsIndex		DWORD		?

; exchangeElements	
tempIndex				DWORD		? 
tempValue				DWORD		?

; gnomeSort
originalArrayOFFSET		DWORD		?
lastArrayIndex			DWORD		?

	
.code
main PROC

	call	Randomize
	call	fillArray
	call	testProc


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
	PUSH	ARRAYSIZE
	call	displayArray

RET
testPROC ENDP

; ---------------------------------------------------------------------------------
; Name: gnomeSort
;
; Description: implement gnome sorting algorithm.
;
; Preconditions: OFFSET inputArray is pushed the runtime stack.
;
; Postconditions: 
;
; Returns:
;
; ---------------------------------------------------------------------------------

gnomeSort PROC
_storeRegisters:
	PUSH	ESP
	PUSH	EBP
	MOV		EBP, ESP

_accesArgument:
	MOV		EDI, [EBP+12]
	MOV		originalArrayOFFSET, EDI

_lastArrayIndexToESI:
		MOV		ESI, originalArrayOFFSET
		
		PUSH	EBX 
;-------------------------------------------------
;	ESI = ARRAYSIZE * 4 + originalArrayOFFSSET
; -------------------------------------------------
		MOV		EBX, ARRAYSIZE
		MOV		EAX, EBX
		MOV		EAX, 4
		MUL		EBX 
		MOV		EBX, EAX
		ADD		ESI, EBX
		MOV		lastArrayIndex, ESI

		POP		EBX 
	
_iterateSortAlgorithm:

	PUSHAD
	PUSH	ARRAYSIZE	
	PUSH	OFFSET testArray
	call	displayArray
	call	CrlF
	POPAD	
	; ---------------------------------------------
	; if ESI == 0: ESI += 4
	; else: continue 
	; ---------------------------------------------
	_incrementZeroIndex:
		CMP		EDI, originalArrayOFFSET
		JNE		_cmpTwinIndices	
		ADD		EDI, 4
	_cmpTwinIndices:
		
		_configureIndexDecrement:
			MOV		EAX, EDI
			SUB		EAX, 4						; EAX = currIndex - 4

		_cmpElementSizes:
			MOV		EBX, [EDI]
			CMP		[EAX], EBX
			JLE		_incrmentIndex	

		_swapElements:
			PUSH	EAX
			PUSH	EDI	
			call	exchangeElements
	
			SUB		EDI, 4
			JMP		_continue
		_incrmentIndex:		
			MOV		EAX, EDI
			ADD		EDI, 4
			MOV		EAX, EDI


	_continue:
		_cmpLastIndex:
			; ----------------------------------------------
			; if currenIndex < finalIndex: JMP _iterateSortAlgorithm 
			; ----------------------------------------------
			CMP		lastArrayIndex, EDI
			JGE		_iterateSortAlgorithm

	_finish:	
	POP		EBP
	POP		ESP
RET	4
gnomeSort ENDP


; ---------------------------------------------------------------------------------
; Name: fillArray		
;
; Description: fills the array with random elements between the two specified bounds
;
; Preconditions: LO, HI, and ARRAY_SIZE are declared in the data segment
; array address is declared in .data, and arrayAddress OFFSET is pushed to the PROC. 
; Registers modified: EAX, ECX, and ESI.
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
; Postconditions: ADBS Modified registers are EAX, EDI, EBX, and ESI	
;
; Returns: NA
;
; ---------------------------------------------------------------------------------
displayArray PROC
	PUSH	ESP
	PUSH	EBP	
	MOV		EBP, ESP

_loadArrayRequirements:		
	MOV		ESI, [EBP+16]				; ESI = inputArrayOFFSET
	MOV		ECX, [EBP+12]				; ECX = number of elements	
	MOV		EBX, ROW_LENGTH
			
_printIteratively:	
	printElement [ESI]	
	ADD		ESI, 4
	
	_createNewLineConditionally:
		INC		currentRowLength
		CMP		EBX, currentRowLength 
		JGE		_loopPrint 

		call	CrLf			
		MOV		EDX, 1
		MOV		currentRowLength, EDX

	
	_loopPrint:
	LOOP	_printIteratively
	
_displayElement:	
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

	MOVSD					

	POP		EBP
	POP		ESP
RET	8
exchangeElements ENDP

END main