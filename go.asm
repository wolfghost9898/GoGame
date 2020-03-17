;##############################################################################
;########################## MACRO ENCARGADO DE MOSTRAR UNA CADENA #############
;##############################################################################
mostrar macro mensaje
  mov ah,09h
  mov dx, offset mensaje
  int 21h   
endm

;##############################################################################
;########################## MACRO ENCARGADO DE MOSTRAR UN CARACTER ############
;##############################################################################
mostrarCaracter macro caracter
   mov ah,2
   mov dl,caracter
   int 21h
endm


;##############################################################################
;########################## MACRO ENCARGADO DE MOSTRAR UN NUMERO ############
;##############################################################################
mostrarNumero macro caracter
   mov ah,2
   mov dl,caracter
   add dl,30h
   int 21h
endm

;##############################################################################
;########################## MACRO ENCARGADO OBTENER UN CHAR ###################
;##############################################################################
ingresarCaracter macro 
   mov ah,1
   int 21h
   mov bl,al
endm

;##############################################################################
;########################## MOSTRAR TABLERO                 ###################
;##############################################################################
mostrarTablero macro tablero
   mostrarCaracter 10
   mov bx,8d
   ;For para Y
   recursividad:
      cmp bx,0d
      jle fin 
      mostrarNumero bl
      mostrarCaracter 32
      mostrarCaracter 32
      mostrarCaracter 32
         ; For para X
         mov cx,0d
         recursividadX:
            cmp cx,6d 
            jg finX
            
            mostrar separacion 
            mostrarCaracter 32
            mostrarCaracter 32
            mostrarCaracter 32

            inc cx
            jmp recursividadX
         finX:
      mostrarCaracter 10
      mostrar separacionFilas
      dec bx
      jmp recursividad

   fin:
   mostrarCaracter 10
   mostrar cabeceraX
endm

.model small
.stack
.data
   ;--------------------------------------------------------------- MENSAJES -----------------------------------------------
   cabecera   db "Universidad de San Carlos de Guatemala",10,"Facultad de Ingenieria",10,"Ciencias y Sistemas",10,
   "Arquitectura de computadores y ensambladores 1",10,"Carlos Eduardo Hernandez Molina",10,"201612118",10,"Seccion: A",10,"$"
   
   opciones db 10,10,"1) Iniciar Juego",10,"2) Cargar Juego",10,"3) Salir",10,"$"

   despedida db 10,"Saliendo del juego...","$"

   suerte db 10,"Gambete..$"

   separacion db "---$"
   separacionFilas db "  *     *     *     *     *     *     *     *",10,"$"
   cabeceraX db "  A     B     C     D     E     F     G     H ",10,"$"

   turnoNegra db 10,"Turno Negra: $"
   turnoBlanca db 10,"Turno Blanca: $"
   ;-------------------------------------------- TABLERO ---------------------------------------------------------------------
   tablero db 16,16
   turno db ?
 
.code
 
inicio:
   mov ax,@data
   mov ds,ax
   mov dx,ax
   ; Mostrar Cabecera
   mostrar cabecera
   mostrar opciones
   ; Pedir una opcion
   ;ingresarCaracter
   
   mov bl,'1'
   ; switch para las opciones
   cmp bl,'1'
   je jugar
   
   cmp bl,'2'
   je cargar
   
   jmp salida
   jugar:
   mov turno,0d ; Negras Inician 0 -> Negras, 1 -> Blancas

   
  
   mostrar suerte
   mostrarTablero tablero
   mostrarCaracter 10
   
   cmp turno,0d
   je tNegra 
   mostrar turnoBlanca
   jmp salida
   tNegra: 
   mostrar turnoNegra
   
   jmp salida


   cargar:
   jmp salida


   salida:
   mostrar despedida
   mov   ax,4c00h       
   int   21h            
 
end 