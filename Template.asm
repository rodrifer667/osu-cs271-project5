TITLE Program Template     (template.asm)

; Author: Fernando I. Rodriguez-Estrada	 
; Last Modified: 5/27/2023
; OSU email address: rodrifer@oregonstate.edu
; Course number/section:   CS271 Section 40X
; Project Number: 5	           Due Date: 5/28/2023
; Description: 

INCLUDE Irvine32.inc

printNum MACRO num
	PUSH	EAX
	MOV		EAX, num
	call	WriteDec	
	POP		EAX 

ENDM

;-----------------------------------------------------------------
; Name: sourceElToEAX 
; 
; Moves element held in the first index of random array into EAX
; 
; Preconditions: NA
;
; recieves: NA

; returns: currEl
;-----------------------------------------------------------------

sourceElementToEAX MACRO median
	MOV		EAX, [ESI]
	MOV		currEl, EAX

ENDM


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
	call	CrlF

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
; Name: setZero
;
; sets the input to zero.
; 
; Preconditions: desired zero is passed as an argument.
;
; recieves
; num = number to set to zero.
;
; returns: NA
;-----------------------------------------------------------------

setZero MACRO num 

	PUSH	EBX
	MOV		EBX, 0	
	MOV		num, EBX
	POP		EBX
	
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
counts			DWORD		ARRAYSIZE DUP(?)
elFrequenciesLength		DWORD		?
elFrequenciesOFFSET		DWORD		?
currElFrequencies		DWORD		1
currIndex				DWORD		1
currEl					DWORD		?
randomElOFFSET			DWORD		?
currElFrequency			DWORD		?

; procName
procTitle				BYTE		"Generating, Sorting, and Counting Random Integers!					By Feranndo I Rodriguez-Estrada", 0
programInstructions		BYTE		"This porgram generates a list of 200 random integers between 15 and 50, inclusive. It then displays the orginal", 
									" list, sorts the list, displays the median of the list, displays the list sorted in ascending order, and finally displays the number of instances of each generated value, starting with the number of lowest."

; titles
unsortedTitle			BYTE		"Your unsorted random number: ", 0
sortedTitle				BYTE		"Your sorted randome numbers: ", 0
instancesTitle			BYTE		"Your list of indances of each generated number, starting with the smallest value:", 13, 10, 13, 10, 0
goodBye					BYTE		"Goodbye, and thanks for using my program!", 0

.code
main PROC

	call	introduction	

_getRandomArray:
	call	Randomize
	call	fillArray

_displayRandomArrayTitle:
	MOV		EDX, OFFSET unsortedTitle
	call	WriteString
	call	CrlF
	
_displayRandomArray:
	PUSH	OFFSET randomElements
	PUSH	ARRAYSIZE
	call	displayArray

_sortRandomArray:
	PUSH	OFFSET randomElements
	call	gnomeSort

_displaySortedTitle:
	MOV		EDX, OFFSET sortedTitle
	call	WriteString
	call	CrlF
_displaySortedArray:	
	PUSH	OFFSET randomElements
	PUSH	ARRAYSIZE
	call	displayArray

_displayMedian:
 	PUSH	OFFSET randomElements
	call	displayMedian

_displayFrequencies:
	PUSH	OFFSET randomElements
	PUSH	OFFSET counts
	call	countList

_displayFreqencyArar:
	PUSH	elFrequenciesOFFSET	
	PUSH	11
	call	displayArray

_displayGoodByeMessage:
	MOV		EDX, OFFSET goodBye
	call	WriteString
	

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
	PUSH	OFFSET counts
	call	countList

RET
testPROC ENDP

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

introduction PROC

	MOV		EDX, OFFSET procTitle
	call	WriteString
	call	CrlF
	call	CrlF

	MOV		EDX, OFFSET programInstructions
	call	WriteString
	call	CrlF
	call	CrlF

RET
introduction ENDP


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

_displayCountTitle:
	call	CrlF
	MOV		EDX, OFFSET instancesTitle
	call	WriteString
	
_accessBasePointer:
	PUSH	ESP
	PUSH	EBP
	MOV		EBP, ESP

_initializeVariables:
	MOV		EDI, [EBP+12]							
	MOV		ESI, [EBP+16]	
	MOV		elFrequenciesOFFSET, EDI
	MOV		randomElOFFSET, ESI 	
	MOV		currElFrequency, 0

	MOV		EAX, [ESI]
	ADD		ESI, 4


	MOV		EBX, [ESI]
	MOV		currEl, EBX
	
;-------------------------------------------------------
; iterate throug the random array to count the array frequencies.
;-------------------------------------------------------

_annotateFrequency:
	CMP		EAX, currEl	
	JE		_incrementCurrFrequency
		
	_resetCurrFrequencyCount:

		_appendElementToFreqCount:
			PUSH EBX
			MOV	EBX, currElFrequency
			MOV	DWORD PTR [EDI], EBX	

			POP EBX
			ADD EDI, 4
		setZero		currElFrequency
		MOV		currEl, EAX
		JMP		_continue
	_incrementCurrFrequency:
		INC		currElFrequency
	_continue:
	ADD		ESI, 4
	MOV		EAX, [ESI]
	printSpace

	;---------------------------------------------------
	; continue while end array not reached.
	;---------------------------------------------------
	CMP		ESI, lastArrayIndex
	JLE		_annotateFrequency	

_appendLastElFrequency:

			PUSH EBX
			MOV	EBX, currElFrequency
			MOV	DWORD PTR [EDI], EBX
			POP	EBX

	
_finish:
	POP		EBP
	POP		ESP
RET 8	
countList ENDP

END main