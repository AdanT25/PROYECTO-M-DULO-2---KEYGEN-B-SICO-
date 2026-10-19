# PROYECTO-M-DULO-2---KEYGEN-Basico
Link de video: https://youtu.be/NOEsu9RexK0
Torres Enriquez Braulio Adan
Descripción del proyecto: Generador de llaves (keygen) estructurado en lenguaje ensamblador x86-64. El programa utiliza la API de Windows para leer una cadena y calcula una llave única utilizando la sumatoria iterativa de sus códigos ASCII y una operación lógica XOR adicional para fortalecer la validación.
Instrucciones de compilación:
Compilar: uasm64 -win64 keygen_torres_braulio.asm
Enlazar: GoLink.exe keygen_torres_braulio.obj kernel32.dll /fo keygen_torres_braulio.exe /console /entry main
El sistema solicita el nombre capturándolo mediante la función ReadConsoleA en un buffer de memoria. Posteriormente, extrae cada byte con movzx dentro de un ciclo que recorre la cadena usando direccionamiento indirecto por registro en RSI. Se van sumando los valores ASCII en el acumulador RAX y finalmente se le aplica la operación lógica XOR con el valor hexadecimal 0xABCD para obtener la llave definitiva.
<img width="1687" height="433" alt="image" src="https://github.com/user-attachments/assets/1d9ea2b7-aa67-4a83-af41-a54a42e8e941" />
<img width="1552" height="224" alt="image" src="https://github.com/user-attachments/assets/b70cc5b7-4103-4513-a5bf-ee4cef7442a3" />
