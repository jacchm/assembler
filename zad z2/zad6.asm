DOSSEG
	.model small
	.stack 100h
    .data
    ENTER_KEY           equ     0Dh
    CARRIAGE_RETURN     equ     0Ah
    PASSWD_OK           db      ENTER_KEY, CARRIAGE_RETURN, 'Password OK$'
    PASSWD_FAIL         db      ENTER_KEY, CARRIAGE_RETURN, 'Password Fail$'
	
	.code
start:
    mov ax,@data
    mov ds,ax                           ; ustaw segment danych
    mov cx, 10H                         ; wpisanie do wartosci 16 (dec) do bx - max ilość znaków
    petla:
        xor ax, ax  
        cmp cx, 0   
        jz blad                         ; skocz na koniec jeśli b=0 (wpisanie 16 znaków)
        mov ah, 8h 			            ; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				            ; przerwanie dos
        cmp al, ENTER_KEY               ; porownanie wpisanego znaku z kodem klawisza ENTER
        je wyjscie_z_petli              ; jesli wcisnieto enter skok do etykiety wyjscie z petli
        mov dl, '*'                     ; wpisanie * do dl    
        mov ah, 02h                     ; funkcja wyświetlenia znaku
        int 21h                         ; wywołanie przerwania
        dec cx                          ; dekrementacja bx
    jmp petla                           ; jeśli wciśnięty klawisz inny niż enter skocz do etykiety petla
    wyjscie_z_petli:
    xor dx, dx  
    mov dl, OFFSET [PASSWD_OK]          ; wiadomość PASSWD_OK do rejestru dl
    mov ah, 09h                         ; funkcja wyświetlenia ciągu znaków na ekran
    int 21h                             ; wywołanie przerwania DOS
    jmp koniec                          ; skok na koniec programu
    blad:                               ; obsluga blednie wpisanego hasla
        xor dx, dx
        mov dl, OFFSET [PASSWD_FAIL]    ; wiadomość PASSWD_FAIL do rejestru dl
        mov ah, 09h                     ; funkcja wyświetlenia ciągu znaków na ekran
        int 21h                         ; wywołanie przerwania DOS
        jmp koniec                      ; skok na koniec programu

    koniec:
        mov	ax, 4c00h		            ; funkja zakończenia programu
        int	21h	
end start