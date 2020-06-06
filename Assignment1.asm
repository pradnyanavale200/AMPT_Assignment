    BITS 16

start:
    mov ax,0x07C0
    mov ds,ax			; Set data segment to where we're loaded
    mov bx,0xB800
    mov es,bx
    mov ax, 00000h             ; (4096 + 512) / 16 bytes per paragraph
    mov ss, ax
    mov sp, 7C00h
    mov di,808
    mov bl, 01h

    mov si, text_string     ; Put string position into SI
    call print_string      ; Call our string-printing routine
    

    jmp $                   ; Jump here - infinite loop!


    text_string db 'This is my String', 0


print_string:                   ; Routine: output string in SI to screen
 .repeat:
    mov ah, 09h             ; int 10h 'print char' function
    mov bh, 0x00
    cmp al,' '
    je .continue
    jmp .noti
.continue:
    add bl, 01h
    jmp .noti
.noti:
    mov cx, 01h
    lodsb                   ; Get character from string
    inc di
    cmp al, 0
    je .done              ; If char is zero, end of string
    ;MOV CX,0000H
    ;MOV DX,67ABH
    int 10h                 ; Otherwise, print it
    mov bh, 00h
    mov ah, 03h
    ;MOV DX,0C27H
    int 10h
    mov ah, 02h
    mov bh, 00h
    inc dl
    int 10h
    jmp .repeat

 .done:
    inc di
    ret
    times 510-($-$$) db 0   ; Pad remainder of boot sector with 0s
    dw 0xAA55               ; The standard PC boot signature
