SECTION .text

GLOBAL _start 
_start:

org 0x8000
bits 16
	push  0xb800
	pop   es     		; Set ES to the Video Memory
	;; Clear screen
	mov ax, 0x0000    	; Clean screen blue background
	call  cls
	;; Print message
	call  print
	;; Done!
	jmp $   ; this freezes the system, best for testing
	hlt	;this makes a real system halt
	ret     ;this makes qemu halt, to ensure everything works we add both

cls:
	xor   di,di
	mov   cx, 80*24		;Default console size
	repnz stosw
	ret

print:
	xor   di, di
.loop:
	mov ah, 10H
	int 16H
	mov bl, al
	mov ah, 10H
	int 16H
        cmp al, bl
	jz .end
	jmp   .loop ;print next character

.end:
	mov si,matrixgiven
	mov cl, 8
	mov ah, 0x1b
	.loop2:
		lodsb
		test al, al
		jz .ext
		stosw
		dec cl
		jnz .nxt
		mov cl, 8
		add di, 144
	.nxt:	jmp .loop2
	
.ext:
	mov si,matrixtranspose
	mov ax, di
	mov di, matrixgiven
	movq mm1, [di]
	movq mm2, [di + 8]
	movq mm3, [di + 16]
	movq mm4, [di + 24]
	punpcklbw mm1, mm2
	punpcklbw mm3, mm4
	movq mm0, mm1
	punpcklwd mm1, mm3
	punpckhwd mm0, mm3
	movq [si], mm1
	movq [si + 8], mm0
	
			
	movq mm1, [di]
	movq mm2, [di + 8]
	movq mm3, [di + 16]
	movq mm4, [di + 24]
	punpckhbw mm1, mm2
	punpckhbw mm3, mm4
	movq mm0, mm1
	punpckhwd mm1, mm3
	punpcklwd mm0, mm3
	movq [si + 24], mm1
	movq [si + 16], mm0
	
	mov di, ax
	mov ah, 0x1b
	mov si,matrixtranspose
	mov cl, 4
	add di, 160
	.loop3:
		lodsb
		test al, al
		jz .exit1
		stosw
		dec cl
		jnz .nxt1
		mov cl, 4
		add di, 152
	.nxt1:	jmp .loop3	
.exit1:
	ret
		

SECTION .DATA	
	
matrixgiven: db "56524573965437476129398712198956", 0
matrixtranspose: times 32 db (0)

times 512-($-$$) db 0 ; Make it a disk sector

;Begin MBR Signature
db 0x55 ;byte 511 = 0x55
db 0xAA ;byte 512 = 0xAA

	
