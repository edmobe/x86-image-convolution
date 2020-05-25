; Proyecto individual 1
; Eduardo Moya

INCLUDE Irvine32.inc  
INCLUDE macros.inc

; ----------------------------- Constants --------------------------------				
imageMaxWidth = 3900
imageMaxHeight	= 2200
imageMaxResolution	= imageMaxWidth * imageMaxHeight					; width x height
extendedImageMaxSize = (imageMaxWidth + 2) * (imageMaxHeight * 2)	; (width + 2) x (height + 2)
BUFFER_SIZE_IN	= extendedImageMaxSize + 1
BUFFER_CONSOLE = 10

; User console input (image size)
bufferConsole				BYTE BUFFER_CONSOLE DUP(?), 0, 0
stdInHandle					HANDLE ?
bytesRead					DWORD ?
askForDimensions			BYTE "Insert image dimensions using the structure widthxheight (example: 1920x1080): ",0

; File read
imageArray		BYTE BUFFER_SIZE_IN DUP(0)
fileNameIn		BYTE "input.txt",0
fileHandleIn	HANDLE ?

; Convolution
imageWidth				WORD ?
imageWidthExtended		WORD ?
imageHeight				WORD ?
imageHeightExtended		WORD ?
imageResolution			DWORD ?
extendedImageSize		DWORD ?
pixelsIn				DWORD ? 
sharpeningKernel		BYTE 9 DUP(0)
sum						WORD 0
imageRowCounter			WORD 0
imageColumnCounter		WORD 0
kernelRowCounter		BYTE 0
kernelColumnCounter		BYTE 0
kernelCounter			BYTE 0
kernelRowOffset			DWORD 0
kernelColumnOffset		DWORD 0
imageRowOffset			DWORD 0
imageColumnOffset		DWORD 0
sharpenedImageCounter	DWORD 0
newImage				BYTE 0
sharpenedImage			BYTE imageMaxResolution DUP(0)

; File Write
fileNameOut		BYTE "normSharpened.txt", 0
fileHandleOut	HANDLE ?
bytesWrittenOut DWORD ?
str1Out			BYTE "Cannot create file",0dh,0ah,0	
str2Out			BYTE "Bytes written to file: ",0

.code
main PROC
; -------------- GET IMAGE DIMENSIONS FROM CONSOLE ------
; Ask for the input
mov	edx,OFFSET askForDimensions			
call	WriteString

; Get handle to standard input
INVOKE GetStdHandle, STD_INPUT_HANDLE
mov stdInHandle,eax

; Wait for user input
INVOKE ReadConsole, stdInHandle, ADDR bufferConsole,
	BUFFER_CONSOLE, ADDR bytesRead, 0

; Transform the dimensions
xor esi, esi					; Position in value counter = 0
xor edi, edi					; Buffer counter = 0
xor eax, eax					; Dimension container
xor ebx, ebx					; Char value container
mov cx, 10						; Multiplier

getImageWidth:
mov bl, bufferConsole[edi]		; Get actual value in buffer
cmp bl, 120
je endWidth
sub bl, 48						; Get number
cmp esi, 0
je updateWidthValue
mul cx
updateWidthValue:
add ax, bx
inc edi
inc esi
jmp getImageWidth
endWidth:
mov imageWidth, ax
xor eax, eax
xor esi, esi
inc edi

getImageHeight:
mov bl, bufferConsole[edi]		; Get actual value in buffer
cmp bl, 13
je endHeight
sub bl, 48						; Get number
cmp esi, 0
je updateHeightValue
mul cx
updateHeightValue:
add ax, bx
inc edi
inc esi
jmp getImageHeight
endHeight:
; Get amount of pixels
mov imageHeight, ax
mov bx, imageWidth
mul bx
mov cx, dx
shl ecx, 16
add cx, ax
mov imageResolution, ecx
; Get amount of pixels (extended)
mov ax, imageHeight
mov bx, imageWidth
add ax, 2
add bx, 2
mov imageHeightExtended, ax
mov imageWidthExtended, bx
mul bx
mov cx, dx
shl ecx, 16
add cx, ax
mov extendedImageSize, ecx

; -------------------- READ FILE ------------------------
; Let user input a filename.
	mov edx,OFFSET fileNameIn
	mov ecx,SIZEOF fileNameIn

; Open the file for input.
	mov edx,OFFSET fileNameIn
	call OpenInputFile
	mov fileHandleIn,eax

; Check for errors.
	cmp eax,INVALID_HANDLE_VALUE ; error opening file?
	jne file_ok_in ; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp quit ; and quit
	
file_ok_in:
; Read the file into a buffer.
	mov edx,OFFSET imageArray
	mov ecx,BUFFER_SIZE_IN
	call ReadFromFile
	jnc check_buffer_size ; error reading?
	mWrite "Error reading file. " ; yes: show error message
	call WriteWindowsMsg
	jmp close_file

check_buffer_size:
	cmp eax,BUFFER_SIZE_IN; buffer large enough?
	jb buf_size_ok ; yes
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp quit

buf_size_ok:
	mov imageArray[eax],0 ; insert null terminator
	mWrite "File size: "
	call WriteDec ; display file size
	call Crlf

; Display the buffer.
	mWrite <"Buffer:",0dh,0ah,0dh,0ah>
	mov edx,OFFSET imageArray ; display the buffer
	call WriteString
	call Crlf

close_file:
	mov eax,fileHandleIn
	call CloseFile

; ------------------- TRANSFORM BUFFER TO INT ARRAY --------
; cl: register to hold the char and transform it to integer
; al: register that holds multiplication results
; dl: n as in 10^n
; bl: actual number
cld
mov ax, imageWidthExtended
mov bx, imageHeightExtended
mul bx
mov bx, dx
shl ebx, 16
mov bx, ax
mov pixelsIn, ebx					; pixelIn = (width+2)x(height+2)
xor esi, esi						; esi: counter
xor edi, edi						; edi: pixel counter
xor eax, eax							
xor ebx, ebx							
xor ecx, ecx							
xor edx, edx							

; ----------------------- CONVOLUTION -------------------------
convolution:
	mov sharpeningKernel[0], 0
	mov sharpeningKernel[1], -1
	mov sharpeningKernel[2], 0
	mov sharpeningKernel[3], -1
	mov sharpeningKernel[4], 5
	mov sharpeningKernel[5], -1
	mov sharpeningKernel[6], 0
	mov sharpeningKernel[7], -1
	mov sharpeningKernel[8], 0
	
new_kernel_row:
	mov ebx, kernelRowOffset
	add ebx, kernelColumnOffset
	add ebx, imageRowOffset
	add ebx, imageColumnOffset
	mov cl, [imageArray + ebx]
	xor edx, edx
	mov dl, kernelCounter
	mov al, [sharpeningKernel + edx]
	cbw 
	imul cx
	add sum, ax
	inc kernelCounter
	inc kernelRowCounter
	cmp kernelRowCounter, 3
	je new_kernel_column
	inc kernelRowOffset
	jmp new_kernel_row

new_kernel_column:
	inc kernelColumnCounter
	cmp kernelColumnCounter, 3
	je new_image_row
	mov kernelRowOffset, 0
	mov kernelRowCounter, 0
	xor eax, eax
	mov ax, imageWidthExtended
	add kernelColumnOffset, eax
	jmp new_kernel_row

new_image_row:
	mov ax, sum
	mov ebx, sharpenedImageCounter
	cmp ax, 0
	jl less_than_zero
	cmp ax, 255
	jg over_255
	mov sharpenedImage[ebx], al
	jmp sum_stored
less_than_zero:
	mov sharpenedImage[ebx], 0
	jmp sum_stored
over_255:
	mov sharpenedImage[ebx], 255
sum_stored:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov kernelRowOffset, 0
	mov kernelColumnOffset, 0
	mov kernelRowCounter, 0
	mov kernelColumnCounter, 0
	mov kernelCounter, 0
	mov sum, 0
	inc imageRowOffset
	inc sharpenedImageCounter
	mov ax, imageWidth
	inc imageRowCounter
	cmp imageRowCounter, ax
	jne new_kernel_row

new_image_column:
	inc imageColumnCounter
	mov ax, imageHeight
	cmp imageColumnCounter, ax
	je sharpened
	mov imageRowCounter, 0
	mov imageRowOffset, 0
	xor eax, eax
	mov ax, imageWidthExtended
	add imageColumnOffset, eax
	jmp new_kernel_row
	
sharpened:
; ----------------------- WRITE FILE ------------------------
; Create a new text file.
	mov	edx, OFFSET fileNameOut
	call	CreateOutputFile
	mov	fileHandleOut,eax

; Check for errors.
	cmp	eax, INVALID_HANDLE_VALUE	; error found?
	jne	file_out_ok					; no: skip
	mov	edx,OFFSET str1Out			; display error
	call	WriteString
	jmp	quit
file_out_ok:
; Write the buffer to the output file.
	mov	eax,fileHandleOut
	mov	edx,OFFSET sharpenedImage
	mov	ecx,imageResolution
	call	WriteToFile
	mov	bytesWrittenOut,eax		; save return value
	call	CloseFile
	
	COMMENT @
; Display the return value.
	mov	edx,OFFSET str2Out		; "Bytes written"
	call	WriteString
	mov	eax,bytesWrittenOut
	call	WriteDec
	call	Crlf
	@

	; Do the same process for oversharpening
	cmp newImage, 1
	je quit
	inc newImage
	; Change settings for oversharpening
	mov	fileNameOut, "o"
	mov fileNameOut[1], "v"
	mov fileNameOut[2], "e"
	mov fileNameOut[3], "r"
	mov sharpeningKernel[0], 0
	mov sharpeningKernel[1], -2
	mov sharpeningKernel[2], 0
	mov sharpeningKernel[3], -2
	mov sharpeningKernel[4], 9
	mov sharpeningKernel[5], -2
	mov sharpeningKernel[6], 0
	mov sharpeningKernel[7], -2
	mov sharpeningKernel[8], 0
	; Reset all convolution values
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi
	mov sum, 0
	mov imageRowCounter, 0
	mov imageColumnCounter, 0
	mov kernelRowCounter, 0
	mov kernelColumnCounter, 0
	mov kernelCounter, 0
	mov kernelRowOffset, 0
	mov kernelColumnOffset, 0
	mov imageRowOffset, 0
	mov imageColumnOffset, 0
	mov sharpenedImageCounter, 0
	mov bytesWrittenOut, 0
	jmp new_kernel_row

quit:
	exit
main ENDP
END main