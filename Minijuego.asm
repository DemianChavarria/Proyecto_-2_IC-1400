; Librerias
extern printf
extern system
extern scanf

; SECCCION DATA
section .data

; COMANDOS
Limpiar_consola db "clear", 0
Salir_juego db "exit", 0

; VARIABLES DE main:
mostrar_menu db 10, "Entrando al Buscaminas...", 10, 10, 0
menu_invalido db 10, "Su opcion fue invalida, Seleccione el numero de la opcion en pantalla...", 10, 10, 0
opciones_menu db "1. Jugar", 10
    db "2. Manual de controles", 10
    db "3. Salir del juego", 10, 10, 0

; VARIABLES DE _Jugar:
mostrar_dificultad db 10, "Se debe seleccionar la dificultad del juego...", 10, 10, 0
mostrar_dificultad_mal db 10, "Su opcion fue invalida, elija el numero de la opcion en pantalla...", 10, 10, 0
opciones_Jugar db "1. Dificultad Principiante", 10        
    db "2. Dificultad Intermedio", 10
    db "3. Dificultad Infierno", 10
    db "4. Volver al menu", 10, 10, 0

; VARIABLES DE _Manual


; MENSAJE INPUT
mensaje_opcion db "Ingrese su Opcion: ", 0  
opcion db "%d", 0


; (inputs)
section .bss
 
; INPUT DE OPCION
eleccion resd 1


; SECCION DE CONDIGO DE EJECUCION
section .text
global main

; Menu del Minijuego
; cuando es llamado, retorna el menu, que en este caso seria el principal
main:
    push Limpiar_consola   ; limpia la consosla
    call system
    add esp, 4

    ; muestra el menu principal
    push mostrar_menu  
    call printf    
    push opciones_menu
    call printf
    add esp, 8

    ; se muestra el mensaje para que el usuario elija una de las opciones
    ; #R: solo numeros
    push mensaje_opcion
    call printf
    add esp, 4

    ; la opcion del usuario se guarda en este bloque
    push eleccion
    push opcion
    call scanf
    add esp, 4
        mov eax, [eleccion]
    
    ; IF
    IF:
        mov ebx, 1 ; si el User elige 1, llama a la funcion _Jugar
        cmp eax, ebx
        je _Jugar

        mov ebx, 2 ; si el User elige 2, llama a la funcion _Manual
        cmp eax, ebx
        je _Manual

        mov ebx, 3 ; si el User elige 1, llama a la funcion _Salir
        cmp eax, ebx
        je _salir

    ; ELSE
    push Limpiar_consola 
    call system
    add esp, 4

    ; muestra el menu principal
    push menu_invalido
    call printf      
    push opciones_menu
    call printf 
    add esp, 8

    ; se muestra el mensaje para que el usuario elija una de las opciones
    ; #R: solo numeros
    push mensaje_opcion
    call printf
    add esp, 4

    push eleccion 
    push opcion
    call scanf
    add esp, 8
        mov eax, [eleccion]
        jmp IF

; MENU DE SELECCION DE DIFICULTAD
; Cuando es llamado, retorna un menu donde el user selecciona su dificultad
_Jugar:
    push Limpiar_consola
    call system
    add esp, 4

    ; se muestra el menu de dificultad
    push mostrar_dificultad
    call printf
    push opciones_Jugar
    call printf
    add esp, 8

    ; se muestra el mensaje para que el usuario elija una de las opciones
    ; #R: solo numeros
    push mensaje_opcion
    call printf
    add esp, 4

    push eleccion 
    push opcion
    call scanf
    add esp, 4


; FUNCION DE INSTRUCCION
; cuando es llamado retorna la linea de instrucciones basicas de controles del juego
_Manual:
    push Limpiar_consola
    call system
    add esp, 4


; FUNCION DE SALIDA
; cuando es llamado, retorna la salida del juego
_salir:

    push Salir_juego
    call system
    add esp, 4



