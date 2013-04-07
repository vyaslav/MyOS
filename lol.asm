; VictoriaOS: loader
; Copyright Ilya Strukov, 2008

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.

org 7c00h
	;Bios Print char func
    mov     cx, 1h
	mov dh, 0
	mov dl,0
set_al_0:
	mov al,0
start: 
	;PRINT CHAR
	mov ah, 09h
	mov bh, 0
    mov bl, 07h
    int 10h
	;if overflow set 0
    ;cmp al, 0FFh
	;je set_al_0	
	inc al
	;UPDATE CURSOR
	;inc dl
	;mov     ah, 02h
    ;mov     bh, 00h
    ;int     10h
jmp start
msg_welcome db 'lol?', 0
	
spam_buffer:
	spam	db (7dfeh - $) dup (0)
	db		55h, 0aah
