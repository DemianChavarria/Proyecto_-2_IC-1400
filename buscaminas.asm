; Librerias
extern printf
extern system
extern scanf
extern rand
extern srand
extern time

; =========================
; SECTION DATA
; =========================
section .data

mina db "* ",0
vacio db ". ",0

ingrese_fila db "Ingrese fila (0-8): ",0
ingrese_columna db "Ingrese columna (0-8): ",0

mensaje_perdio db 10,"BOOM! Perdio el juego",10,0

mostrar_caracter db "%s",0
mostrar_numero db "%d ",0

; COMANDOS
Limpiar_consola db "clear", 0

; MENU PRINCIPAL
mostrar_menu db 10, "Entrando al Buscaminas...", 10, 10, 0

menu_invalido db 10
    db "Su opcion fue invalida...",10,10,0

opciones_menu db "1. Jugar",10
    db "2. Manual de controles",10
    db "3. Salir del juego",10,10,0

; MENU DIFICULTAD
mostrar_dificultad db 10
    db "Se debe seleccionar la dificultad...",10,10,0

opciones_Jugar db "1. Dificultad Principiante",10
    db "2. Dificultad Intermedio",10
    db "3. Dificultad Infierno",10
    db "4. Volver al menu",10,10,0

; INPUT
mensaje_opcion db "Ingrese su Opcion: ",0
opcion db "%d",0

salto db 10,0


; =========================
; SECTION BSS
; =========================
section .bss

eleccion resd 1

; MATRIZ 9x9
matriz resd 81

fila_usuario resd 1
columna_usuario resd 1

tablero_visible resd 81

; =========================
; SECTION TEXT
; =========================
section .text
global main
main:

    jmp menu_principal

menu_principal:

    ; limpiar consola
    push Limpiar_consola
    call system
    add esp,4

    ; mostrar menu
    push mostrar_menu
    call printf
    add esp,4

    push opciones_menu
    call printf
    add esp,4

    ; pedir opcion
    push mensaje_opcion
    call printf
    add esp,4

    ; leer opcion
    push eleccion
    push opcion
    call scanf
    add esp,8

    mov eax,[eleccion]

    ; opcion 1
    cmp eax,1
    je _Jugar

    ; opcion 2
    cmp eax,2
    je _Manual

    ; opcion 3
    cmp eax,3
    je _salir

    ; invalido
    jmp menu_principal



; =========================
; MENU DIFICULTAD
; =========================
_Jugar:

menu_dificultad:

    ; limpiar
    push Limpiar_consola
    call system
    add esp,4

    ; mostrar menu dificultad
    push mostrar_dificultad
    call printf
    add esp,4

    push opciones_Jugar
    call printf
    add esp,4

    ; pedir opcion
    push mensaje_opcion
    call printf
    add esp,4

    ; leer opcion
    push eleccion
    push opcion
    call scanf
    add esp,8

    mov eax,[eleccion]

    ; PRINCIPIANTE
    cmp eax,1
    je _Principiante

    ; volver menu
    cmp eax,4
    je main

    ; cualquier otra opcion
    jmp menu_dificultad



; =========================
; PRINCIPIANTE
; =========================
_Principiante:

    ; srand(time(0))
    push 0
    call time
    add esp,4

    push eax
    call srand
    add esp,4

    ; limpiar matriz
    mov esi,0
    jmp llenar_tablero

llenar_tablero:

    cmp esi,81
    je poner_minas

    mov dword [matriz + esi*4],0
    mov dword [tablero_visible + esi*4],0

    inc esi
    jmp llenar_tablero



; =========================
; PONER MINAS
; =========================
poner_minas:

    mov dword [matriz + 5*4], -1
    mov dword [matriz + 20*4], -1
    mov dword [matriz + 35*4], -1
    mov dword [matriz + 50*4], -1
    mov dword [matriz + 70*4], -1

    jmp juego_loop

loop_minas:

    cmp ecx,0
    je juego_loop

    call rand

    mov ebx,81
    xor edx,edx
    div ebx

    ; ya hay mina?
    cmp dword [matriz + edx*4],-1
    je loop_minas

    ; poner mina
    mov dword [matriz + edx*4],-1

    dec ecx
    jmp loop_minas



; =========================
; LOOP DEL JUEGO
; =========================
juego_loop:

    ; limpiar
    push Limpiar_consola
    call system
    add esp,4

    ; mostrar tablero
    call mostrar_tablero

    ; pedir fila
    push ingrese_fila
    call printf
    add esp,4

    push fila_usuario
    push opcion
    call scanf
    add esp,8

    ; pedir columna
    push ingrese_columna
    call printf
    add esp,4

    push columna_usuario
    push opcion
    call scanf
    add esp,8

    ; calcular posicion
    mov eax,[fila_usuario]

    imul eax,9

    add eax,[columna_usuario]

    ; revisar mina
    cmp dword [matriz + eax*4],-1
    je perder

    ; descubrir casilla
    mov dword [tablero_visible + eax*4],1

    jmp juego_loop



; =========================
; PERDER
; =========================
perder:

    ; limpiar
    push Limpiar_consola
    call system
    add esp,4

    ; mostrar minas
    call mostrar_minas

    ; mensaje perder
    push mensaje_perdio
    call printf
    add esp,4

    ; volver menu
    jmp main



; =========================
; MOSTRAR TABLERO
; =========================
mostrar_tablero:

    mov esi,0

    jmp fila_tablero


fila_tablero:

    cmp esi,9
    je fin_tablero

    mov edi,0

columna_tablero:

    cmp edi,9
    je nueva_linea

    ; posicion
    mov eax,esi

    imul eax,9

    add eax,edi

    ; visible?
    cmp dword [tablero_visible + eax*4],1
    je mostrar_numero_real

    ; mostrar oculto
    push vacio
    push mostrar_caracter
    call printf
    add esp,8

    inc edi
    jmp columna_tablero



mostrar_numero_real:

    push dword [matriz + eax*4]
    push mostrar_numero
    call printf
    add esp,8

    inc edi
    jmp columna_tablero



nueva_linea:

    push salto
    call printf
    add esp,4

    inc esi
    jmp fila_tablero



fin_tablero:

    ret



; =========================
; MOSTRAR MINAS
; =========================
mostrar_minas:

    mov esi,0

    jmp fila_minas
   

fila_minas:

    cmp esi,9
    je fin_minas

    mov edi,0

columna_minas:

    cmp edi,9
    je nueva_linea_minas

    ; posicion
    mov eax,esi

    imul eax,9

    add eax,edi

    ; es mina?
    cmp dword [matriz + eax*4],-1
    je imprimir_mina

    ; no mina
    push vacio
    push mostrar_caracter
    call printf
    add esp,8

    inc edi
    jmp columna_minas



imprimir_mina:

    push mina
    push mostrar_caracter
    call printf
    add esp,8

    inc edi
    jmp columna_minas



nueva_linea_minas:

    push salto
    call printf
    add esp,4

    inc esi
    jmp fila_minas



fin_minas:

    ret



; =========================
; MANUAL
; =========================

_Manual:

    jmp main



; =========================
; SALIR
; =========================
_salir:

    mov eax,1
    xor ebx,ebx
    int 0x80