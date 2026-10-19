# PROYECTO-M-DULO-2---KEYGEN-B-SICO-
Torres Enriquez Braulio Adan
Descripción del proyecto: Generador de llaves (keygen) estructurado en lenguaje ensamblador x86-64. El programa utiliza la API de Windows para leer una cadena y calcula una llave única utilizando la sumatoria iterativa de sus códigos ASCII y una operación lógica XOR adicional para fortalecer la validación.
Instrucciones de compilación:
Compilar: uasm64 -win64 keygen_torres_braulio.asm
Enlazar: GoLink.exe keygen_torres_braulio.obj kernel32.dll /fo keygen_torres_braulio.exe /console /entry main
El sistema solicita el nombre capturándolo mediante la función ReadConsoleA en un buffer de memoria. Posteriormente, extrae cada byte con movzx dentro de un ciclo que recorre la cadena usando direccionamiento indirecto por registro en RSI. Se van sumando los valores ASCII en el acumulador RAX y finalmente se le aplica la operación lógica XOR con el valor hexadecimal 0xABCD para obtener la llave definitiva.
