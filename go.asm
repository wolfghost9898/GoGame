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
            cmp cx,7d 
            jg finX
            
            
            mov temp,bx 
            mov temp2,cx 
            
            ;sub bx,1d
            mov cx,bx 
            mov bx,temp2
            mapeoLexico
            
            cmp tablero[bx],2d
            je posNegra
            cmp tablero[bx],3d
            je posBlanca
            mostrarCaracter 32
            jmp l14
            posNegra:
            mostrarCaracter 'F'
            mostrarCaracter 'N'
            jmp l14 
            posBlanca:
            mostrarCaracter 'F'
            mostrarCaracter 'B' 
            jmp l14
            
            
            l14:
            mostrarCaracter 32
            mostrar separacion 
            mostrarCaracter 32
            mov bx,temp
            mov cx,temp2
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

;##############################################################################
;########################## CONTROL MOVIMIENTO              ###################
;##############################################################################
controlMovimiento macro posX,posY
   mov bl,posX
   sub bl,17d ; Lo pasamos a numero
   mov bh,0d ; limpimos los bits mas significativos

   mov cl,posY
   
   ; X >= 0
   cmp bl,48d 
   jge l0
   jmp l1

   ; X <= 8
   l0:
   cmp bl,56d
   jle l2
   jmp l3

   ;Falsa
   l1:
   l3:
   mostrar errorPosicion
   xor bx,bx 
   mov bx,2d ; Error
   jmp l4

   ;Verdadera
   l2:
      ; Y >= 0
      cmp cl,48d
      jge l5
      jmp l1

      ; Y <= 8
      l5:
      cmp cl,56d
      jle l6
      jmp l1 

      l6:
      
      sub bl,48d
      sub cl,48d
      mov bh,0d 
      mov ch,0d

      mapeoLexico
      
      cmp tablero[bx],2d
      je eExiste
      cmp tablero[bx],3d
      je eExiste
      
      
      
      
      cmp turno,0d
      je tNegro 
      mov tablero[bx],3d
      jmp salirTurno 
      
      

      tNegro:
      mov tablero[bx],2d
      xor bx,bx 
      mov bx,3d ; Todo bien todo correcto 
      
      jmp salirTurno

      eExiste:
      mostrar exitePosicion
      xor bx,bx 
      mov bx,2d ; Error
      jmp l4


      salirTurno:
      cambiarTurno
      

   l4:
   

endm
;##############################################################################
;########################## VERIFICAR SI ES EXIT            ###################
;##############################################################################
mapeoLexico macro 
   xor AX,AX
   mov AX,CX
   mov CX,8d
   mul CX
   add AX,BX
   mov CX,2d
   mul CX
   
   mov BX,AX
   
endm

;##############################################################################
;########################## CAMBIAR TURNO             ###################
;##############################################################################
cambiarTurno macro 
   cmp turno,0d
   je l7 
   mov turno,0d
   jmp l8
   
   l7:
   mov turno,1d

   l8:
endm

;##############################################################################
;########################## VERIFICAR SI ES EXIT            ###################
;##############################################################################
isExit macro palabra
   mov dl, [SI + 0]
   cmp dl,'E'
   je l9
   jmp l10 
   
   l9:
   mov dl, [SI + 1]
   cmp dl,'X'
   je l11
   jmp l10

   l11:
   mov dl, [SI + 2]
   cmp dl,'I'
   je l12
   jmp l10 

   l12:
   mov dl, [SI + 3]
   cmp dl,'T'
   jne l10 

   mov bx,1d 
   jmp l13

   
   l10:
      mov bx,0d 
   l13:

endm

;##############################################################################
;########################## COMANDO SAVE            ###################
;##############################################################################
isSave macro palabra
   mov dl, [SI + 0]
   cmp dl,'S'
   je l15 ;Verdadera
   jmp l16 ;Falsa

   l15:
      mov dl, [SI + 1]
      cmp dl,'A'
      je l17 ;Verdadera
      jmp l16 ;Falsa

   l17:
      mov dl, [SI + 2]
      cmp dl,'V'
      je l18 ;Verdadera
      jmp l16 ;Falsa


   l18:
      mov dl, [SI + 3]
      cmp dl,'E'
      je l19 ;Verdadera
      jmp l16 ;Falsa

   l19: 
      mov bx,1d
      jmp l20

   l16:
      mov bx,0d
   
   l20:
endm 

;##############################################################################
;########################## MACRO PARA ESCRIBIR EN EL ARCHIVO ###################
;##############################################################################
escribirArchivo macro 
   mov ah,40h
   mov al,02H
   mov bx,filehandle
   mov cx,1
   mov dx,offset cadena
   int 21h
 
endm

;##############################################################################
;########################## GUARDAR EL ESTADO ###################
;##############################################################################
guardarEstado macro
   xor bx,bx
   l21:
      
      cmp bx,32d  ; si es mayor a 16 nos salimos del loop
      jge l22
      mov temp,bx
      
      cmp tablero[bx],2d
      je l23
      cmp tablero[bx],3d
      je l24
      mov cadena,48
      jmp l25
      l23:
         mov cadena,50
         jmp l25
      l24:
         mov cadena,51
         jmp l25

      l25:
         escribirArchivo
      mov bx,temp
      
      inc bx
      inc bx
      jmp l21

   l22: 
endm

;##############################################################################
;########################## CARGAR ESTADO ###################
;##############################################################################
cargarEstado macro
   mov cl, buffer + 0
   xor ch,ch
   sub cx, 48
   mov tablero[0],0d
endm

;##############################################################################
;########################## CERRAR ARCHIVO ###################
;##############################################################################
cerrarArchivo macro
   mov ah,3Eh
   mov bx,filehandle
   int 21h
endm
.model small
.stack
.data
   ;--------------------------------------------------------------- MENSAJES -----------------------------------------------
   cabecera   db "Universidad de San Carlos de Guatemala",10,"Facultad de Ingenieria",10,"Ciencias y Sistemas",10,
   "Arquitectura de computadores y ensambladores 1",10,"Carlos Eduardo Hernandez Molina",10,"201612118",10,"Seccion: A",10,"$"
   
   opciones db 10,10,"1) Iniciar Juego",10,"2) Cargar Juego",10,"3) Salir",10,"$"

   despedida db 10,"Saliendo del juego...","$"

   suerte db 10,"Ganbatte...$"


   errorPosicion db 10, "Posicion Incorrecta :(",10,"$"

   separacion db "---$"
   separacionFilas db "    *     *     *     *     *     *     *     *",10,"$"
   cabeceraX db "    A     B     C     D     E     F     G     H ",10,"$"

   turnoNegra db 10,"Turno Negra: $"
   turnoBlanca db 10,"Turno Blanca: $"

   exitePosicion db 10,"Ya existe una ficha en esa posicion",10,"$"
   ;-------------------------------------------- TABLERO ---------------------------------------------------------------------
   tablero dw 32 
   turno db ?
   coorX db ?
   coorY db ?

   ;------------------------------------------- INSTRUCCIONES ----------------------------------------------------------------
   instruccion db 4 DUP("$")
   
   ;----------------------------------------------------- ARCHIVO --------------------------------------------------------------
   ingresarArchivo db 10,"Ingrese el nombre del archivo: $";
   nombreArchivo db 13,0,13 dup("$")
   creadoExito db 10,"Se ha creado el archivo$"
   openFallido db 10,"No se ha podido abrir el archivo$"
   creadoFallido db 10,"No se ha podido guardar la partida$"
   partidaGuardara db 10,"Se ha guardado la partida$"
   cargaExito db 10,"Se ha cargado con exito la partida$"
   filehandle dw ?
   cadena db 2 DUP("$")
   buffer db 17 dup (24h)

   ;------------------------------------------------------ HTML ----------------------------------------------------------------
   
   ;---------------------------------------- OTROS-----------------------------------------------------------------------
   temp dw ?
   temp2 dw ?
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
   mov turno,0d ; Negras Inician 0 -> Negras, 1 -> Blancas
   mov bl,'1'
   ; switch para las opciones
   cmp bl,'1'
   je jugar
   
   cmp bl,'2'
   je cargar
   
   jmp salida
   
   
   ;#################################################################################################################################
   ;#########################################################JUGAR###################################################################
   ;#################################################################################################################################
   jugar:
  

   
   ;----------------------------------------------- Mostrar Tablero -------------------------------------------------
      mostrar suerte
      mostrarTablero tablero
      
      
      recursividadJuego:
         mostrarCaracter 10
         ;------------------------------------------------- Mostrar Turno Actual -----------------------------------------
         cmp turno,0d
         je tNegra 
         mostrar turnoBlanca
         jmp empezar
         tNegra: 
            mostrar turnoNegra
      
         empezar:
      
      
         lea SI,instruccion              ; el indice del stack apuntara a la direccion de frase

         mov dx,SI                 ; dx apunta al si
         mov ah,0AH                ; interrupcion para obtener algo de consola
         int 21h

         lea SI, instruccion + 2
         ;--------------------------------------------------------------- COMANDO EXIT -------------------------------------------------------
         xor bx,bx
         isExit instruccion + 2 ;Si es el comando salir
         cmp bx,1d
         je salida
         
         ;-------------------------------------------------------------- COMANDO SAVE -------------------------------------------------------
         xor bx,bx
         isSave instruccion + 2 ; Si es el comando SAVE
         cmp bx,1d 
         je save
         ;---------------------------------------------------------- MOVIMIENTO EN EL TABLERO ----------------------------------------------
         xor bx,bx
         mostrarCaracter 10
         controlMovimiento [SI + 0],[si + 1]
         
         cmp bx,2d 
         je recursividadJuego

         jmp jugar


   cargar:
      mostrarCaracter 10
      mostrar ingresarArchivo
      mov dx,offset nombreArchivo
      mov bx,dx
      mov ah,0Ah 
      int 21h
      mov [byte ptr nombreArchivo+2+8],0

      mov ah,3Dh
      xor al,al
      lea dx,[nombreArchivo + 2]
      int 21h
      jc openError
      
      mov filehandle,ax
      mov bx,filehandle
      mov ah,3fh
      mov al,0
      mov cx,16
      mov dx,offset buffer
      int 21h
      jc openError
      
      cerrarArchivo
      xor ax,ax
      xor bx,bx
      xor cx,cx 
      xor dx,dx
      
      cargarEstado
      
      mostrar cargaExito

      jmp jugar
      

      openError:
         mostrar openFallido
      jmp salida

   ;####################################################### EXIT ############################################
   salida:
      mostrar despedida
      mov   ax,4c00h       
      int   21h            
   

   ;####################################################### SAVE ############################################
   save:
      mostrarCaracter 10
      mostrar ingresarArchivo
      
      mov dx,offset nombreArchivo
      mov bx,dx
      mov ah,0Ah 
      int 21h
      mov [byte ptr nombreArchivo+2+8],0
      

      mov ah,3ch 
      mov cx,00000000b
      lea dx,[nombreArchivo + 2]
      int 21h
      mov filehandle,ax 
      jnc creadoE 
      mostrar creadoFallido
      jmp jugar
    
      creadoE:
         mostrar creadoExito
         guardarEstado
         mostrar partidaGuardara
         cerrarArchivo
         jmp jugar





end 