SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

segment .data 
   section .data
   ; Mensajes para ingresar los valores
   userMsg db 'Ingrese el primer valor: ', 0
   lenUserMsg equ $ - userMsg
   userMsg2 db 'Ingrese el segundo valor: ', 0
   lenUserMsg2 equ $ - userMsg2

   ; Operaciones 
   sumaMsg db '1. Suma', 0x0A
   lenSumaMsg equ $ - sumaMsg
   restaMsg db '2. Resta', 0x0A
   lenRestaMsg equ $ - restaMsg
   multMsg db '3. Multiplicación', 0x0A
   lenMultMsg equ $ - multMsg
   divMsg db '4. División', 0x0A
   lenDivMsg equ $ - divMsg

   ; Seleccionar opción y mostrar resultado
   chooseOption db 'Seleccione una opción: ', 0
   lenChooseOption equ $ - chooseOption
   resultMsg db 'El resultado de la operación es: ', 0
   lenResultMsg equ $ - resultMsg

   resultado db ''

segment .bss

   num1 resb 8 
   num2 resb 8 
   res resb 8
   option resb 2  
   outputbuffer resb 8

section	.text
   global _start    ;must be declared for using gcc
	
_start:         
   ; Solicitar primer valor
   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, userMsg         
   mov edx, lenUserMsg
   int 0x80                

   mov eax, SYS_READ 
   mov ebx, STDIN  
   mov ecx, num1 
   mov edx, 5
   int 0x80            

   ; Solicitar segundo valor
   mov eax, SYS_WRITE        
   mov ebx, STDOUT         
   mov ecx, userMsg2          
   mov edx, lenUserMsg2         
   int 0x80

   mov eax, SYS_READ  
   mov ebx, STDIN  
   mov ecx, num2 
   mov edx, 5
   int 0x80        

   ; Mostrar el menú
   menu:
      mov eax, 4
      mov ebx, 1
      mov ecx, sumaMsg
      mov edx, lenSumaMsg
      int 80h

      mov eax, 4
      mov ebx, 1
      mov ecx, restaMsg
      mov edx, lenRestaMsg
      int 80h

      mov eax, 4
      mov ebx, 1
      mov ecx, multMsg
      mov edx, lenMultMsg
      int 80h

      mov eax, 4
      mov ebx, 1
      mov ecx, divMsg
      mov edx, lenDivMsg
      int 80h

      ; Solicitar la opción
      mov eax, 4
      mov ebx, 1
      mov ecx, chooseOption
      mov edx, lenChooseOption
      int 80h

      ; Leer la opción
      mov eax, 3
      mov ebx, 0
      mov ecx, option
      mov edx, 2
      int 80h

      ; Comparamos el valor leído
      cmp byte [option], '1'
      je sum_operation
      cmp byte [option], '2'
      je res_operation
      cmp byte [option], '3'
      je mul_operation
      cmp byte [option], '4'
      je div_operation

   sum_operation:
      mov eax, [num1]
      sub eax, '0'
	
      mov ebx, [num2]
      sub ebx, '0'
      add eax, ebx
      add eax, '0'
      mov [res], eax
      jmp mostrar_resultado

   res_operation:
      mov eax, [num1]
      sub eax, '0'
	
      mov ebx, [num2]
      sub ebx, '0'
      sub eax, ebx
      add eax, '0'
      mov [res], eax
      jmp mostrar_resultado

   mul_operation:
      mov eax, [num1]
      sub eax, '0'
	
      mov ebx, [num2]
      sub ebx, '0'
      mul ebx

      mov [res], al
      add byte [res], '0'
      jmp mostrar_resultado

   div_operation:
   ; Movemos los números a los registros
      mov al, [num1]
      mov bl, [num2]

   ; Igualamos a cero los registros 
      mov dx, 0
      mov ah, 0

   ; Ascii a decimal
      sub bl, '0'
      sub al, '0'

      div bl
      add ax, '0'

      ; El resultado se almacena en al (cociente)
      mov [res], ax ; Almacenar el cociente de la división en res
      jmp mostrar_resultado


   ; Imprimir el resultado
   mostrar_resultado:
      mov al, [res]
      sub al, '0'
      aam 
      add ax, 3030h
      mov [outputbuffer], ah
      mov [outputbuffer + 1], al
      mov ecx, outputbuffer
      mov edx, 2
      mov ebx, 1
      mov eax, 4
      int 80h

      mov eax, 1
      mov bl, [res]
      int 80h
      

   exit:       
      mov eax, SYS_EXIT   
      xor ebx, ebx 
      int 0x80