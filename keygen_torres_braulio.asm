; ------------------------------------------------------------
; PROYECTO MÓDULO 2 - "KEYGEN BÁSICO"
; ------------------------------------------------------------
extrn GetStdHandle: proc
extrn ReadConsoleA: proc
extrn WriteConsoleA: proc
extrn ExitProcess: proc

.data
    prompt          db 'Ingresa tu nombre de usuario: ', 0
    prompt_len      dq $ - prompt - 1
    msg_llave       db 'Tu llave es: ', 0
    msg_llave_len   dq $ - msg_llave - 1
    msg_error       db 'Nombre no valido', 13, 10, 0
    msg_error_len   dq $ - msg_error - 1

    buffer_nombre   db 64 DUP(0)      
    bytes_leidos    dq 0
    bytes_escritos  dq 0

    hInput          dq 0
    hOutput         dq 0

    buffer_hex      db 16 DUP('0')    
    crlf            db 13, 10, 0
    hex_len         dq 16
    crlf_len        dq 2

.code
main proc
    sub rsp, 28h

    ; Obtener handle de salida
    mov rcx, -11               
    call GetStdHandle
    mov [hOutput], rax

    ; Obtener handle de entrada
    mov rcx, -10               
    call GetStdHandle
    mov [hInput], rax

    ; Mostrar prompt al usuario
    mov rcx, [hOutput]
    lea rdx, prompt
    mov r8, [prompt_len]
    lea r9, bytes_escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Capturar nombre
    mov rcx, [hInput]
    lea rdx, buffer_nombre
    mov r8, 64                 
    lea r9, bytes_leidos
    mov qword ptr [rsp + 20h], 0
    call ReadConsoleA

    ; Manejar caso de nombre vacío (Requisito RF-4)
    lea rsi, buffer_nombre
    movzx rax, byte ptr [rsi]
    cmp rax, 13             ; Comparar si es retorno de carro (\r)
    je caso_error
    cmp rax, 10             ; Comparar si es salto de línea (\n)
    je caso_error

    ; Generar llave a partir del nombre
    lea rcx, buffer_nombre
    call generar_llave         

    ; Convertir llave a cadena hexadecimal
    lea rdi, buffer_hex
    call convertir_hex

    ; Imprimir texto "Tu llave es:"
    mov rcx, [hOutput]
    lea rdx, msg_llave
    mov r8, [msg_llave_len]
    lea r9, bytes_escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Imprimir la llave de 16 caracteres
    mov rcx, [hOutput]
    lea rdx, buffer_hex
    mov r8, [hex_len]
    lea r9, bytes_escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Salto de línea final
    mov rcx, [hOutput]
    lea rdx, crlf
    mov r8, [crlf_len]
    lea r9, bytes_escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    jmp fin

caso_error:
    mov rcx, [hOutput]
    lea rdx, msg_error
    mov r8, [msg_error_len]
    lea r9, bytes_escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

fin:
    xor rcx, rcx
    call ExitProcess
main endp

; ------------------------------------------------------------
; Procedimiento: generar_llave
; Entrada: RCX contiene la dirección base del nombre
; Salida: RAX devuelve la llave procesada
; ------------------------------------------------------------
generar_llave proc
    mov rsi, rcx
    xor rax, rax            ; Limpiar acumulador para la suma

ciclo_suma:
    movzx rdx, byte ptr [rsi]
    cmp rdx, 13             ; Salir si encuentra \r
    je fin_suma
    cmp rdx, 10             ; Salir si encuentra \n
    je fin_suma
    cmp rdx, 0              ; Salir si es nulo
    je fin_suma

    add rax, rdx            ; Sumar código ASCII
    inc rsi                 ; Avanzar puntero
    jmp ciclo_suma

fin_suma:
    xor rax, 0ABCDh         ; Transformación usando XOR
    ret
generar_llave endp

; ------------------------------------------------------------
; Procedimiento: convertir_hex
; Entrada: RAX contiene la llave numérica, RDI la dirección del buffer
; Implementación basada en instrucción DIV de la Semana 4
; ------------------------------------------------------------
convertir_hex proc
    mov rcx, 16             ; Configurar loop para generar 16 dígitos
    add rdi, 15             ; Apuntar a la última posición del buffer
    mov r8, 16              ; Divisor constante para base hexadecimal

ciclo_hex:
    xor rdx, rdx            ; Limpiar RDX antes de DIV (obligatorio)
    div r8                  ; RDX:RAX / 16. Cociente en RAX, residuo en RDX

    ; Convertir el residuo en DL a su respectivo carácter ASCII
    cmp dl, 9
    jg es_letra
    add dl, '0'             ; Si es del 0 al 9, sumar 48 ('0')
    jmp guardar_char

es_letra:
    add dl, 55              ; Si es del 10 al 15, sumar 55 ('A'-'F')

guardar_char:
    mov [rdi], dl           ; Almacenar carácter de atrás hacia adelante
    dec rdi                 ; Retroceder el puntero
    loop ciclo_hex          ; Decrementar RCX y repetir

    ret
convertir_hex endp
end