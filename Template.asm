TITLE Program Template     (template.asm)

; Author: Fernando I. Rodriguez-Estrada	 
; Last Modified: 5/27/2023
; OSU email address: rodrifer@oregonstate.edu
; Course number/section:   CS271 Section 40X
; Project Number: 5	           Due Date: 5/28/2023
; Description: 

INCLUDE Irvine32.inc

; MACROS

;-----------------------------------------------------------------
; Name: lastIndexToEBX
; 
; EBX gets the address of the last index. 
; 
; Preconditions: arrayLength and arrayOFFSET are passed as arguments. 
;
; recieves
; arrayLength = length of array
; arrayOFFSET
;
; returns: EBX = address of last index.
;-----------------------------------------------------------------

lastIndexToEBX MACRO arrayLength, arrayStartingIndex
	MUL		arrayLength, 4
	MOV		ESI, arrayLength
	ADD		ESI, arrayStartingIndex
ENDM

ROW_LENGTH = 20

; fillArray PROC
LO = 20
HI = 30
ARRAYSIZE = 200

; (insert constant definitions here)

.data

testArray				DWORD		1, 11, 7, 6, 5, 4, 3, 2, 1, 0
testArrayLength		    DWORD       LENGTHOF testArray  
rowIndex				DWORD		?	
no						BYTE		"No", 0
yes						BYTE		"yes",	0


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

; gnomeSort
originalArrayOFFSET		DWORD		?
lastArrayIndex			DWORD		?

	
.code
main PROC

	call	Randomize
	call	fillArray

	call	testProc
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

	PUSH	10
	PUSH	OFFSET testArray
	call	displayArray
	call	CrLf

	PUSH	OFFSET testArray
	call	gnomeSort

	;;test


	PUSH	10
	PUSH	OFFSET testArray
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

	
_iterateSortAlgorithm:
	; ---------------------------------------------
	; if ESI == 0: ESI += 4
	; else: continue 
	; ---------------------------------------------
	_incrementZeroIndex:
		SUB		EDI, originalArrayOFFSET		; configuers address
		CMP		EDI, 0
		JNE		_cmpTwinIndices	
		ADD		EDI, 4
	_cmpTwinIndices:
		ADD		EDI, originalArrayOFFSET		; to compare to existing address
		
		_configureIndexDecrement:
			MOV		EAX, EDI
			SUB		EAX, 4						; EAX = currIndex - 4

		_cmpElementSizes:
			MOV		EBX, [EDI]
			CMP		[EAX], EBX
			JNLE	_incrmentIndex	

		_swapElements:
			PUSH	EAX
			PUSH	EDI	
			call	exchangeElements

			SUB		EDI, 4
			JMP		_continue
		_incrmentIndex:		

		MOV		EAX, EDI
		call	WriteDec	
		call	CrLf
		ADD		EDI, 4
		MOV		EAX, EDI
		call	WriteDec
		call	CrlF

	_continue:
	_lastArrayIndexToESI:
		MOV		ESI, originalArrayOFFSET
		MOV		EAX, ESI
		call	Writedec
		call	CrlF
		
		PUSH	EBX 
;-------------------------------------------------
;	ESI = (ARRAYSIZE * 4 + originalArrayOFFSSET
; -------------------------------------------------
		MOV		EBX, ARRAYSIZE
		MOV		EAX, 4
		MUL		EBX 
		ADD		ESI, EBX
		MOV		EAX, ESI
		call WriteDec


		POP		EBX 
		call	Writedec
			
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

	POP		EBP
	POP		ESP
RET	8
exchangeElements ENDP

END main