DOSSEG
	.model small
	.stack 300h
    .data
    CARRIAGE_RETURN     equ     0Ah
    ESC_KEY             equ     1Bh
    UP_KEY              equ     48h
    DOWN_KEY            equ     50h
    LEFT_KEY            equ     4bh
    RIGHT_KEY           equ     4dh
    SPACE_KEY           equ     20h
    F1_KEY              equ     3bh
    F2_KEY              equ     3ch
    F3_KEY              equ     3dh
    F4_KEY              equ     3eh
    F5_KEY              equ     3fh
    F6_KEY              equ     40h
    F7_KEY              equ     41h
    F8_KEY              equ     42h
    F9_KEY              equ     43h
    RED                 db      27, "[31m$"
    BLUE                db      27, "[34m$"
    YELLOW              db      27, "[33m$"
    GREEN               db      27, "[32m$"
    PINK                db      27, "[35m$"
    LBLUE               db      27, "[36m$"
    GREY                db      27, "[37m$"
    BLACK               db      27, "[30m$"
    BRIGHT_COL          db      27, "[1m$"    
    DIM_COL             db      27, "[2m$"
    CLS                 db      27, "[2J$"    
    RESET_COL           db      27, "[0m$"
    MODE                db      1   
    NUMBER              db      4 DUP('$') 
    EMPTY_STRING_25     db      "                        $"
    OPEN                db      "K($"
    CLOSE_BRACKET       db      ")    $"
            
	.code
start:
    mov ax,@data
    mov ds,ax                   ; ustaw segment danych
    mov ah, 09h             
    lea dx, [CLS]               ; wyczyszczenie ekranu
    int 21h
    mov ah, 2h              
    mov dh, 9                  ; usttawienie wiersza 
    mov dl, 40                  ; ustawienie kolumny
    int 10h
    loop1:
        call coursor_position   ; wywołanie procedury wypisującej pozycje kursora w dolnym lewym rogu ekranu
        mov ah, 8h 			    ; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				    ; przerwanie dos
        cmp al, ESC_KEY         ; porownanie wpisanego znaku z kodem klawisza ESC
        je koniec               ; skok na koniec jesli ESC
        cmp al, SPACE_KEY       
        je SPACE                ; skok do estykiety SPACE (wywołanie zmiany trybu)
        cmp al, 00h             ; porównanie czy al = 0     
        jnz loop1               ; jeśli nie 0, skok do loop1
        mov ah, 8h 			    ; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				    ; przerwanie dos
        cmp al, UP_KEY          ; skok do up jeśli wcisnieto strzalke do gory
        je up
        cmp al, DOWN_KEY        ; skok do down jeśli wcisnieto strzalke w dol
        je down
        cmp al, LEFT_KEY        ; skok do left jeśli wcisnieto strzalke w lewo
        je left
        cmp al, RIGHT_KEY       ; skok do right jeśli wcisnieto strzalke w prawo
        je right
        cmp al, F1_KEY
        je F1
        cmp al, F2_KEY
        je F2
        cmp al, F3_KEY
        je F3
        cmp al, F4_KEY
        je F4
        cmp al, F5_KEY
        je F5
        cmp al, F6_KEY
        je F6
        cmp al, F7_KEY
        je F7
        cmp al, F8_KEY
        je F8
        cmp al, F9_KEY
        je F9
    jmp loop1                   ; jeśli wciśnięty klawisz inny niż enter skocz do etykiety petla
    
    koniec:
        mov	ax, 4c00h		    ; funkja zakończenia programu
        int	21h	

; obsługa przycsików klawiatury - strzałki i klawisze fu:
    up:
        call up_proc
        jmp loop1
    down:
        call down_proc
        jmp loop1
    left:
        call left_proc
        jmp loop1
    right:
        call right_proc
        jmp loop1
    
    SPACE:
        call space_proc
        jmp loop1       
    
    F1:
        call F1_proc
        jmp loop1
        
    F2:
        call F2_proc
        jmp loop1

    F3:
        call F3_proc
        jmp loop1
        
    F4:
        call F4_proc
        jmp loop1   

    F5:
        call F5_proc
        jmp loop1
        
    F6:
        call F6_proc
        jmp loop1

    F7:
        call F7_proc
        jmp loop1
        
    F8:
        call F8_proc
        jmp loop1

    F9:
        call F9_proc
        jmp loop1


; procedury sterowania kursorem
    up_proc proc
        call read
        cmp dh, 0
        jz jump_over_up                ; wróc do loop1 jeśli dh=0
        mov ah, 2h
        dec dh
        int 10h
        call draw
        ret
        jump_over_up:
            mov dh, 24
            mov ah, 2h
            int 10h
            call draw
            ret
    up_proc endp

    down_proc proc
        call read
        cmp dh, 24
        jge jump_over_down                ; wroc do loop1 jesli dh<=25
        mov ah, 2h
        inc dh
        int 10h
        call draw
        ret
        jump_over_down:
            mov dh, 0
            mov ah, 2h
            int 10h
            call draw
            ret
    down_proc endp

    left_proc proc
        call read
        cmp dl, 0
        jz jump_over_left                ; wroc do loop1 jesli dl=0
        dec dl
        mov ah, 2h
        int 10h
        call draw
        ret
        jump_over_left:
            mov dl, 78
            mov ah, 2h
            int 10h
            call draw
            ret
    left_proc endp

    right_proc proc
        call read
        cmp dl, 78 
        je jump_over_right                ; wroc do loop1 jesli dl<=79
        inc dl
        mov ah, 2h
        int 10h
        call draw
        ret
        jump_over_right:
            mov dl, 0
            mov ah, 2h
            int 10h
            call draw
            ret
    right_proc endp

; procedury zmiany kolorów:
    F1_proc proc
        lea dx, [GREY]
        call set_color_dim
        ret
    F1_proc endp

    F2_proc proc
        lea dx, [BLUE]
        call set_color_dim
        ret
    F2_proc endp

    F3_proc proc
        lea dx, [GREEN]
        call set_color_dim
        ret
    F3_proc endp
     
    F4_proc proc
        lea dx, [BLUE]
        call set_color_bright
        ret
    F4_proc endp

    F5_proc proc
        lea dx, [RED]
        call set_color_dim
        ret
    F5_proc endp

    F6_proc proc
        lea dx, [PINK]
        call set_color_bright
        ret
    F6_proc endp

    F7_proc proc
        lea dx, [YELLOW]
        call set_color_dim
        ret
    F7_proc endp
    
    F8_proc proc
        lea dx, [GREY]
        call set_color_bright
        ret
    F8_proc endp

    F9_proc proc
        lea dx, [BLACK]
        call set_color_dim
        ret
    F9_proc endp

; procedura zmiany trybu (toggle)
    space_proc proc
        mov bl, byte ptr ds:[MODE]
        cmp bl, 0
        jnz set_to_zero
            mov bx, 1
            mov byte ptr ds:[MODE], bl
            ret
        set_to_zero:
            xor bx, bx
            mov byte ptr ds:[MODE], bl
            ret
    space_proc endp
        
; procedura odczytu pozycji kursora
    read proc   
        mov ah, 03h                 ; funkcja odczytu pozycji 
        int 10h                     ; wywołanie przerwania BIOS
        ret                         ; powrót
    read endp

; procedura ustawiania koloru tła
    set_color_bright proc
        mov ah, 09h                 ; wpisz nr funkcji do al
        push dx                     ; odłóż kod koloru na stos  
        lea dx, [RESET_COL]         ; reset ustawienia kolorów
        int 21h                     ; wywołaj funkcje przez przerwanie DOS  
        lea dx, [BRIGHT_COL]        ; ustaw jasne kolory
        int 21h                     ; wywołaj funkcje przez przerwanie DOS
        pop dx                      ; ponbierz kod koloru ze stosu
        int 21h                     ; wywołaj funkcje przez przerwanie DOS
        ret                         ; powróc
    set_color_bright endp
    
    set_color_dim proc
        mov ah, 09h                 ; wpisz nr funkcji do al
        push dx                     ; odłóż kod koloru na stos
        lea dx, [RESET_COL]         ; reset ustawienia kolorów
        int 21h                     ; wywołaj funkcje przez przerwanie DOS
        lea dx, [DIM_COL]           ; ustaw ciemny kolory
        int 21h                     ; wywołaj funkcje przez przerwanie DOS
        pop dx                      ; ponbierz kod koloru ze stosu
        int 21h                     ; wywołaj funkcje przez przerwanie DOS
        ret                         ; powróc
    set_color_dim endp

; procedura rysowania 
    draw proc
        xor bx, bx
        mov bl, byte ptr ds:[MODE]
        cmp bx, 0
        jz no_draw
        xor dx, dx
        mov ah, 02h
        mov dl, 219                 ; rysuj tło
        int 21h
        call read 
        mov ah, 2h
        dec dl
        int 10h
        ret
        no_draw:
        ret
    draw endp
    
; procedura wypisania pozycji kursora
    coursor_position proc
        xor dx, dx
        call read
        push dx
        mov ah, 2h
        mov dh, 24
        mov dl, 02
        int 10h
        mov ah, 9h
        lea dx, [EMPTY_STRING_25]
        int 21h
        mov ah, 2h
        mov dh, 24
        mov dl, 02
        int 10h
        mov ah, 09h
        lea dx, [OPEN]
        int 21h
        xor ax, ax
        pop dx
        mov al, dh
        push dx
        call ascii_to_number
        lea dx, [NUMBER]
        mov ah, 09h
        int 21h
        mov ah, 02h
        mov dl, ','
        int 21h
        xor ax, ax
        pop dx
        mov al, dl
        push dx
        call ascii_to_number
        lea dx, [NUMBER]
        mov ah, 09h
        int 21h
        mov ah, 09h
        lea dx, [CLOSE_BRACKET]
        int 21h
        pop dx
        mov ah, 02h
        int 10h

        ret
    coursor_position endp
    
    ascii_to_number proc
        xor cx, cx
        mov bx, 10                  ; dzielnik
        petla:
            xor dx, dx              ; zerowanie dx przed dzieleniem
            div bx                  ; dzielenie ax/bx
            add dx, 48              ; dodajemy 48 aby uzyskać nr w kodzie ASCII 
            push dx                 ; dodajemy dx na stos
            inc cx                  ; inkrementacja licznika
            cmp ax, 0               
        jnz petla
        push cx

        mov cx, 4
        clear_array:
            mov bx, cx
            mov [NUMBER+bx], '$'
        loop clear_array

        pop cx
        xor si, si
        save_number:
            mov bx, si
            pop dx
            mov [NUMBER+bx], dl
            inc si
        loop save_number
        ret
    ascii_to_number endp
   
end start