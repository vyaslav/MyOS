; MyOS: loader
; author: vyaslav

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.


org 7c00h
;############################
DEF_SET equ 1h
DEF_RUN equ 0h
DEF_RSAVE equ 2h
DEF_RREST equ 3h
DEF_RESET equ 4h
;############################
;+BIOS_putc
;  +DEF_RUN
;    -I: al - Char
macro BIOS_putc def {
	if def = DEF_SET
		mov ah, 09h
		mov cx, 1
		mov bh, 0
		mov bl, 07h
	else if def = DEF_RESET
		mov ah, 09h
	else if def = DEF_RSAVE
		push    ax bx cx
	else if def = DEF_RREST
		pop     cx bx ax
	else if def = DEF_RUN
		int     10h
	end if		
}
;############################
;+BIOS_move_cur
;  +DEF_RUN
;    -I: dh - cursor row
;    -I: dl - cursor col
macro BIOS_move_cur def {
	if def = DEF_SET
		mov ah, 02h
		mov bh, 00h
	else if def = DEF_RESET
		mov ah, 02h		
	else if def = DEF_RSAVE
		push ax bx
	else if def = DEF_RREST
		pop bx ax
	else if def = DEF_RUN
		int 10h
	end if		
}
;############################
;+C_Print_String
;  -I: string - String to output in CS
macro C_Print_String string {
push si dx
BIOS_putc DEF_RSAVE
	mov si, string
	mov dh, 0
	mov dl, byte[cur]
	lods byte [cs:si]
	;push $+4
	;cmp al, 0
	;jne iP_PRINTS
	;pop dx
	call iP_PRINTS
BIOS_putc DEF_RREST
pop dx si
}
;############################
; MAIN
;############################
C_Print_String msg_welcome
;mov dx, 4
mov dh, 0
mov dl, byte[cur]
mov si, -1
start:
;############################
; MAIN LOOP
;############################
mov cx, 3
neg si
add dx, si
cmp si, 1
jne set_dot
mov al, '.'
;skip next
jmp ILOOP
set_dot:   mov al, ' '
ILOOP:
	push cx
	call P_MOVE_CUR
	add dx, si
	mov  byte[cur], dl
	call P_PUTC
	pop cx
loop ILOOP
jmp start
;############################
cur db 0
msg_welcome db 'MyOS', 0
P_PUTC:
	BIOS_putc DEF_SET
	BIOS_putc DEF_RUN
ret
P_MOVE_CUR:
	BIOS_move_cur DEF_SET
	BIOS_move_cur DEF_RUN
ret
iP_PRINTS:
	;put char
	call P_PUTC
	;move curso
	inc dl
	mov byte[cur], dl
	call P_MOVE_CUR
	lods byte [cs:si]
	cmp al, 0
	jne iP_PRINTS
ret
;############################
spam_buffer:
	spam	db (7dfeh - $) dup (0)
	db		55h, 0aah
