; Librerias
extern printf
extern system
extern scanf


;#####################################################################################################################
;#####################################################################################################################


; SECCCION DATA
section .data

;#####################################################################################################################

; COMANDOS
Limpiar_consola db "clear", 0
Salir_juego db "exit", 0

;#####################################################################################################################

; VARIABLES DE main:
mostrar_menu db 10, "Entrando al Buscaminas...", 10, 10, 0  ;MENU
menu_invalido db 10, "Su opcion fue invalida, Seleccione el numero de la opcion en pantalla...", 10, 10, 0  ;MENU UNIVERSAL
opciones_menu db "1. Jugar", 10
    db "2. Manual de controles", 10
    db "3. Salir del juego", 10, 10, 0

;#####################################################################################################################

; VARIABLES DE _Jugar:
mostrar_dificultad db 10, "Se debe seleccionar la dificultad del juego...", 10, 10, 0 ;MENU
opciones_Jugar db "1. Dificultad Principiante", 10        
    db "2. Dificultad Intermedio", 10
    db "3. Dificultad Infierno", 10
    db "4. Volver al menu", 10, 10, 0

;#####################################################################################################################

; VARIABLES DE _Manual
mostrar_manual db 10, "nada por el momento...", 10, 10, 0 ; MENU
opciones_Manual db "1. Volver al menu", 10, 0  ; OPCIONES DE MENU

;#####################################################################################################################

; VARIABLES MATRIZ INVISIBLE

;#####################################################################################################################

; VARIABLES MATRIZ VISIBLE
celdas db "| %c | %c | %c | %c | %c | %c | %c | %c | %c |", 10, 0
lineas db "-----------------------------------------------", 10, 0
Controles db 10, "1. Marcar una celda", 10
    db "2. Desmarcar una celda", 10
    db "3. Opciones de partida", 10
    db "4. Volver", 10, 10, 0
Marcar_celda db 10, "ingrese 1 para volver o Marque su celda:", 10, 0
Desmarque_celda db 10, "ingrese 1 para volver o Desmarque su Celda:", 10, 0
Opciones_partida db 10, "1, Reanudar Partida", 10, "2, Nueva Partida", 10, "3. Reiniciar Partida", 10, "Abandonar Partida", 10, 10, 0

; CONTROLES...
Marcador db "X", 0


;#####################################################################################################################


;#####################################################################################################################
;#####################################################################################################################


; MENSAJE INPUT Opciones
mensaje_opcion db "Ingrese su Opcion: ", 0  
opcion db "%d", 0

; MENSAJE INPUT selceccionar celdas
mensaje_celda db "Ingrese 1 para Controles", 10, 10, "Seleccione una celda: ", 0
celda db "%d", 0


;#####################################################################################################################
;#####################################################################################################################


; (inputs)
section .bss

;#####################################################################################################################
 
; INPUT DE OPCION
eleccion resd 1

;#####################################################################################################################

; INPUT DE SELECCION DE CELDA
celda_seleccionada resd 1

;#####################################################################################################################


;#####################################################################################################################
;#####################################################################################################################


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
    add esp, 4

    Invalido_1:  ; si la opcion ingresada es invalida, hace un salto de regreso aqui
    
    push opciones_menu 
    call printf
    add esp, 4

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
    
    mov ebx, 1 ; si el User elige 1, llama a la funcion _Jugar
    cmp eax, ebx
    je _Jugar

    mov ebx, 2 ; si el User elige 2, llama a la funcion _Manual
    cmp eax, ebx
    je _Manual

    mov ebx, 3 ; si el User elige 1, llama a la funcion _Salir
    cmp eax, ebx
    je _salir

    ;#####################################################################################################################

        ; INVALIDO


    push Limpiar_consola 
    call system
    add esp, 4

    ; muestra el menu principal
    push menu_invalido
    call printf      
    
    jmp Invalido_1


;#####################################################################################################################
;#####################################################################################################################


; MENU DE SELECCION DE DIFICULTAD
; Cuando es llamado, retorna un menu donde el user selecciona su dificultad
_Jugar:
    push Limpiar_consola
    call system
    add esp, 4

    ; se muestra el menu de dificultad
    push mostrar_dificultad
    call printf
    add esp, 4

    Invalido_2:  ; si la opcion es invalida, hace un salto de regreso aqui
    push opciones_Jugar
    call printf
    add esp, 4

    ; se muestra el mensaje para que el usuario elija una de las opciones
    ; #R: solo numeros
    push mensaje_opcion
    call printf
    add esp, 4

    push eleccion 
    push opcion
    call scanf
    add esp, 8
    
    mov esi, [eleccion]

    jmp _Crear_matriz

    ;#####################################################################################################################
        
        ; INVALIDO

    _Jugar_Not:

        push Limpiar_consola
        call system
        add esp, 4

        push menu_invalido  ;muestra el menu de la opcion invalida
        call printf
        add esp, 4
        
        jmp Invalido_2


;#####################################################################################################################
;#####################################################################################################################


; FUNCION DE INSTRUCCION
; cuando es llamado retorna la linea de instrucciones basicas de controles del juego
_Manual:
    
    push Limpiar_consola
    call system
    add esp, 4

    ; se muestra el menu de controles
    push mostrar_manual
    call printf
    add esp, 4

    Invalido_3: ; si la opcion ingresada es invalida, hace un salto de regreso aqui

    push opciones_Manual
    call printf
    add esp, 4

    ; se muestra el mensaje para que el usuario elija una de las opciones
    ; #R: solo numeros
    push mensaje_opcion
    call printf
    add esp, 4

    push eleccion
    push opcion
    call scanf
    add esp, 8

        mov eax, [eleccion]; la opcion del usuario se guarda en este bloque

        mov ebx, 1 ; si el User elige 1, llama a la funcion main
        cmp eax, ebx
        je main

;#####################################################################################################################

    ; INVALIDO

    ; muestra el menu del manual invalido
    push menu_invalido
    call printf
    add esp, 4
        
    jmp Invalido_3


;#####################################################################################################################
;#####################################################################################################################


; FUNCION DE SALIDA
; cuando es llamado, retorna la salida del juego
_salir:

    push Salir_juego
    call system
    add esp, 4


;#####################################################################################################################
;#####################################################################################################################

_Crear_matriz:

    push Limpiar_consola
    call system
    add esp, 4

;#####################################################################################################################
    ; VALIDANDO OPCION INGRESADA DE _Jugar

    cmp esi, 4  ; si es igual a 4, devulevo a main
    je main

    cmp esi, 1    ; SI ES MENOR A 1 me devulevo a _jugar
    jl _Jugar_Not

    cmp esi, 3   ; SE ES MAYOR A 3 me devuelvo a _jugar
    jg _Jugar_Not

;#####################################################################################################################


    Regreso: ; si User elige volver, volvera a crear la matriz y lo siguiente
    mov ebx, 0 ; iterador
    
    While_1:
        add ebx, 1

        push celdas  ; imprime celdas
        call printf
        add esp, 4
        
        push lineas  ; imprime lineas que separan las celdas
        call printf
        add esp, 4

        cmp ebx, 8  ; SI ES MENOR O IGUAL A 9
        je While_1
        jl While_1
    
    ; muestra mensaje de seleccion de celda u controles
    push mensaje_celda
    call printf
    add esp, 4
    
    push celda_seleccionada  ; guarda celda u Opcion selecccionada
    push celda
    call scanf 
    add esp, 8

    mov eax, [celda_seleccionada]

    cmp eax, 1   ; Controles del juego
    je _Controles


;   FUNCION DE CONTROLES DEL JUEGO
; CUANDO ES LLAMADO, RETORNA LAS OPCIONES DE CONTROLES Y OPCIONES EN LA PARTIDA ACTIVA
_Controles:

    push Controles  ; Muestra los controles, como marcar y desmarcar celdas o las opciones de partida
    call printf 
    add esp, 4

    push mensaje_opcion ; "ingrese su opcion:"
    call printf
    add esp, 4

    push celda_seleccionada ; se guarda la opcion o celda seleccionada
    push celda
    call scanf 
    add esp, 8

    mov esi, [celda_seleccionada]

    cmp esi, 1
    je Marco

    cmp esi, 2
    je Desmarco

    cmp esi, 3
    je Opciones

    cmp esi, 4
    je Vuelvo

;#####################################################################################################################
    ; INVALIDO
        
        push Limpiar_consola
        call system
        add esp, 4

        push menu_invalido ;muestra opcion invalida
        call printf
        add esp, 4
        
        jmp Regreso

;#####################################################################################################################

    ; AL PRESIONAR 1, EL USER TIENE LA OPCION DE MARCAR 
    Marco:

        jmp MATRIZ_VISIBLE
        Marco_V:

    ; AL PRESIONAR 2, EL USER TIENE LA OPCION DE DESMARQUE
    Desmarco:
        
        jmp MATRIZ_VISIBLE
        Desmarco_V:

    ; AL PRESIONAR 3, EL USER TENDRA LAS OPCIONES DE PARTIDA, COMO REINICIAR, ABANDONAR O INICIAR NUEVA PARTIDA
    Opciones:

        jmp MATRIZ_VISIBLE
        Opciones_V:

        push Opciones_partida ; Muestra las Opciones de partida
        call printf
        add esp, 4
    
        push mensaje_opcion
        call printf
        add esp, 4

        push eleccion
        push opcion
        call scanf 
        add esp, 8

            mov 



    
    ; AL PRESIONAR 4, EL USER VUELVE AL MOMENTO INICIAL
    Vuelvo:

        push Limpiar_consola
        call system
        add esp, 4

        jmp Regreso


;#####################################################################################################################
;#####################################################################################################################


; FUNCION DE IMPRIMIR MATRIZ
; CUANDO ES LLAMADO RETORNA NUEVAMENTE LA MATRIZ Y SE DEVUELVE A DONDE FUE LLAMADO
MATRIZ_VISIBLE:

    push Limpiar_consola
    call system
    add esp, 4

    mov ebx, 1

    While_2:

        push celdas  ; imprime celdas
        call printf
        add esp, 4
            
        push lineas  ; imprime lineas que separan las celdas
        call printf
        add esp, 4

        add ebx, 1 ; sumando iterador

        cmp ebx, 8  ; SI ES MENOR O IGUAL A 9
        je While_2
        jl While_2
    
    ; SE DEVUELVE A DONDE FUE LLAMADO
    cmp esi, 1
    je Marco_V

    cmp esi, 2
    je Desmarco_V

    cmp esi, 3
    je Opciones_V


;#####################################################################################################################
;#####################################################################################################################

