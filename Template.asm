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
; Name: printElement 
; 
; prints the element along with a space.
; 
; Preconditions: address of index is passed as an argument.
;
; recieves
; median = median element 

; returns: NA
;-----------------------------------------------------------------

printMedian MACRO median
	  .data
	MedianMessage		BYTE	"The median value of the array: ", 0	
      .code

_printMedianMessage:
	MOV		EDX, OFFSET MedianMessage
	call	WriteString

_printMedian:
	MOV		EAX, median
	call	WriteDec

ENDM

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

printSortedArray MACRO inputArray

	ARRAYSIZE = 200

	.data
	 inputArray DWORD randomElements
		
	.code
		PUSH	OFFSET randomElements
		call	gnomeSort

		PUSH	OFFSET randomElements
		PUSH	ARRAYSIZE
		call	displayArray

ENDM

ROW_LENGTH = 20

; fillArray PROC
LO = 20
HI = 30
ARRAYSIZE =	200 

; (insert constant definitions here)

.data

testArray				DWORD		12, 3, 34, 5, 7, 3, 43, 32,12 , 34, 2,2 ,3, 82,3, 34
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

; displayMedian	
medianOFFSET			DWORD		?
medianElement			DWORD		? 

; countList		
elementFrequencies		DWORD		ARRAYSIZE DUP(?)
elFrequenciesLength		DWORD		?
elFrequenciesOFFSET		DWORD		?
currElFrequencies		DWORD		1
currIndex				DWORD		1
currEl					DWORD		?


.code
main PROC

_getRandomArray:
	call	Randomize
	call	fillArray
	
_displayRandomArray:
	PUSH	OFFSET randomElements
	PUSH	ARRAYSIZE
	call	displayArray

_sortRandomArray:
	PUSH	OFFSET randomElements
	call	gnomeSort

_displaySortedArray:	
	PUSH	OFFSET randomElements
	PUSH	ARRAYSIZE
	call	displayArray

_displayMedian:
 	PUSH	OFFSET randomElements
	call	displayMedian

_displayFrequencies:
	PUSH	OFFSET randomElements
	PUSH	OFFSET elementFrequencies	
	call	countList

;call	testPROC
; 	PUSH	OFFSET elementFrequencies	
; 	MOV		EBX, OFFSET elementFrequencies
;	call	countList	


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

_displayFrequencies:
	PUSH	OFFSET randomElements
	PUSH	OFFSET elementFrequencies	
	call	countList

RET
testPROC ENDP

; ---------------------------------------------------------------------------------

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
		SUB		lastArrayIndex, 4

		POP		EBX 
	
_iterateSortAlgorithm:

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
			PUSHAD
			PUSH	EAX
			PUSH	EDI	
			call	exchangeElements
			POPAD
	
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

	MOV		EDX, 1
	MOV		currentRowLength, EDX

		
			
_printIteratively:	

	PUSHAD

	MOV		EAX, [ESI]
	call	WriteDec	

	MOV		EDX, OFFSET space
	call	Writestring
	
	POPAD






; 	printElement [ESI]	
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

_finish:	
	call	CrlF
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
	PUSHAD

; [indexOne], [indexTwo] = [IndexTwo], [indexOne]
	MOV		EAX, [EDI]
	MOV		EBX, [ESI]
	MOV		[ESI], EAX 
	MOV		EAX, EBX 
	MOV		[EDI], EAX

	POPAD

	POP		EBP
	POP		ESP
RET	8
exchangeElements ENDP

; ---------------------------------------------------------------------------------
; Name: displayMedian
;
; Description: prints the median.
;
; Preconditions: the desired arra OFFSET is pushed on to the stack. median is declared
; in the .data segment.
;
; Postconditions:  
;
; Returns: NA
;
; ---------------------------------------------------------------------------------

displayMedian PROC
	PUSH	ESP
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EBX, [ESP+12]

	MOV		originalArrayOFFSET, EBX

_divideARRAYSIZEbyTwoFlored:

;----------------------------------------------------------
; medianElement = floor(ARRAYSIZE/2) + 4*originalArrayOFFSET
;----------------------------------------------------------
	MOV		EAX, ARRAYSIZE
	MOV		EDX, 0
	MOV		EBX, 2
	DIV		EBX
	
	MOV		EBX, 4
	MUL		EBX
	ADD		EAX, originalArrayOFFSET
	
	MOV		EAX, [EAX]
	MOV		medianElement, EAX

	printMedian medianElement


_finsh:
	POP		EBP
	POP		ESP
RET 8
displayMedian ENDP

countList PROC
_accessBasePointer:
	PUSH	ESP
	PUSH	EBP
	MOV		EBP, [ESP]

_initializeVariables:
	MOV		EDX, [EBP+12]							
	MOV		EBX, [EBP+16]		
	MOV		elFrequenciesOFFSET, EDX
	MOV		randomElementsOFFSET, EBX 	

	MOV		EAX, elFrequenciesOFFSET
	call	writeDec
	call	crlf

	MOV		EAX, currEl
	call	WriteDec
	call	crlf
		
;-------------------------------------------------------
; iterate throug the random array to count the array frequencies.
;-------------------------------------------------------
;	MOV		ECX, ARRAYSIZE
_annotateFrequency:
;	MOV		EAX, elFrequenciesOFFSET	
; 	call	WriteDec
;	LOOP	_annotateFrequency
	
_finish:
	POP		EBP
	POP		ESP
RET 8	
countList ENDP

END main