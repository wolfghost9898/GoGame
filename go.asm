mostrar macro mensaje
  mov ah,09h
  mov dx, offset mensaje
  int 21h   
endm




.model small
.stack
.data
   cabecera   db "Universidad de San Carlos de Guatemala",10,"Facultad de Ingenieria",10,"Ciencias y Sistemas",10,
   "Arquitectura de computadores y ensambladores 1",10,"Carlos Eduardo Hernandez Molina",10,"201612118",10,"Seccion: A",10,"$"
   
   opciones db 10,10,"1) Iniciar Juego",10,"2) Cargar Juego",10,"3) Salir",10,"$"
 
.code
 
inicio:
   mov ax,@data
   mov ds,ax
   mov dx,ax
   mostrar cabecera
   mostrar opciones

 
   mov   ax,4c00h       
   int   21h            
 
end 