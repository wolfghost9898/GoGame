include files.asm
include estados.asm
include movi.asm

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
         mov cx,1d
         recursividadX:
            cmp cx,8d 
            jg finX
            
            
            mov temp,bx 
            mov temp2,cx 
            
            mov cx,bx 
            mov bx,temp2
            mapeoLexico
            
            cmp [tablero + bx],2d
            je posNegra
            cmp [tablero + bx],3d
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
   LOCAL eSuicidio,turnoSuicidioN,saltoSuicidio
   mov bl,posX
   sub bl,16d ; Lo pasamos a numero
   mov bh,0d ; limpimos los bits mas significativos

   mov cl,posY
   
   ; X >= 1
   cmp bl,49d 
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
      ; Y >= 1
      cmp cl,49d
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

      mov temp8,bx
      mov temp9,cx 

      mapeoLexico
      
      cmp [tablero + bx],2d
      je eExiste
      cmp [tablero + bx],3d
      je eExiste
      
      
      
      cmp turno,0d
      je tNegro 
      mov [tablero + bx],3d
      jmp salirTurno 
      
      

      tNegro:
      mov [tablero + bx],2d
      
      
      jmp salirTurno

      eExiste:
         mostrar exitePosicion
         xor bx,bx 
         mov bx,2d ; Error
         jmp l4

      

      salirTurno:
         
         
         ;cmp bx,1d 
         ;je eSuicidio
         
         xor ax,ax
         xor bx,bx
         xor cx,cx 
         xor dx,dx
      

   l4:
      

endm
;##############################################################################
;########################## MAPEO LEXICO           ###################
;##############################################################################
mapeoLexico macro 
   xor AX,AX
   sub BX,1d
   mov AX,BX
   mov BX,8d
   mul BX
   add AX,CX
   sub AX,1d
   
   mov BX,AX

endm

;##############################################################################
;########################## LIMPIAR TABLERO          ###################
;##############################################################################



;##############################################################################
;########################## CAMBIAR TURNO             ###################
;##############################################################################
cambiarTurno macro 
   LOCAL l7,l8
   cmp turno,0d
   je l7 
   mov turno,0d
   jmp l8
   
   l7:
   mov turno,1d

   l8:
endm

;##############################################################################
;########################## DELIMITAR TERRITORIO           ###################
;##############################################################################

delimitarTerritorio macro
   LOCAL recursividadY,finY,nada,finX,recursividadX,libre,todo,negro,territorioNegro,blanco,territorioBlanco
   
   mov bx,8d
   recursividadY:
      cmp bx,0d 
      jle finY
      mov tempTurno,0d
      mov cx,1d
      recursividadX:
         cmp cx,8d 
         jg finX
         
         mov temp,bx
         mov temp2,cx 

         mov bx,cx 
         mov cx,temp


         buscarTerritorio bx,cx
         mov temp5,dl
         
         cmp dx,0d
         je libre

         cmp dx,2d
         je negro

         cmp dx,3d
         je blanco

         jmp nada

         libre:
            cmp tempTurno,0d
            je todo
            cmp tempTurno,2d 
            je territorioNegro
            cmp tempTurno,3d 
            je territorioBlanco

            jmp nada
         
         negro:
            cmp tempTurno,0d
            je territorioNegro
            cmp tempTurno,2d
            je territorioNegro
            cmp tempTurno,3d
            je todo
            jmp nada

         blanco:
            cmp tempTurno,0d
            je territorioBlanco
            cmp tempTurno,2d
            je todo
            cmp tempTurno,3d
            je territorioBlanco
            
            jmp nada


         todo:
            mov bx,temp 
            llenarLibre temp2,temp6,temp
            mov bx,temp 
            mov cx,temp6
            inc cx
            mov tempTurno,0d
            mov dl,temp5
            mov tempTurno,dl
            jmp recursividadX

        
         territorioNegro:
            mov bx,temp 
            llenarNegras temp2,temp6,temp
            mov bx,temp 
            mov cx,temp6
            inc cx
            mov dl,temp5
            mov tempTurno,dl
            jmp recursividadX
         

         territorioBlanco:
            mov bx,temp 
            llenarBlancas temp2,temp6,temp
            mov bx,temp 
            mov cx,temp6
            inc cx
            mov dl,temp5
            mov tempTurno,dl
            jmp recursividadX


         nada:
            mov bx,temp 
            mov cx,temp2
            inc cx
            mov tempTurno,0d
            jmp recursividadX
      finX:
      mov bx,temp
      dec bx
      jmp recursividadY
      
   finY:


endm

;##############################################################################
;########################## BUSCAR TERRITORIO LIBRE         ###################
;##############################################################################
buscarTerritorio macro posX,posY
   LOCAL recursividad,fin,blanca,fin2
   mov bx,posX 
   mov cx,posY 
   
   recursividad:
      cmp bx,8d 
      jg fin 
         mov temp3,bx
         mov temp6,bx 
         mapeoLexico 

         cmp [tablero + bx],2d 
         je negra
         cmp [tablero + bx],3d 
         je blanca

         mov bx,temp3
         mov cx,posY
      inc bx 
      jmp recursividad
   
   negra:
      mov dx,2d
      jmp fin2

   blanca: 
      mov dx,3d 
      jmp fin2

   fin:
      mov temp6,9d
      mov dx,0d

   fin2:
      xor dh,dh
endm

;##############################################################################
;########################## LLENAR TERRITORIO LIBRE        ###################
;##############################################################################
llenarLibre macro posXI,posXF,posY
   LOCAL recursividad,fin
   mov cx,posY 
   mov bx,posXI 
   
   recursividad:
      cmp bx,posXF 
      jge fin
         mov temp3,bx 
         mapeoLexico 

         mov [tablero + bx],4d 
         

         mov bx,temp3 
         mov cx,posY
      inc bx
      jmp recursividad

   fin:

endm


;##############################################################################
;########################## LLENAR TERRITORIO NEGRA        ###################
;##############################################################################
llenarNegras macro posXI,posXF,posY
   LOCAL recursividad,fin
   mov cx,posY 
   mov bx,posXI 
   
   recursividad:
      cmp bx,posXF 
      jge fin
         mov temp3,bx 
         mapeoLexico 

         mov [tablero + bx],5d 
         

         mov bx,temp3 
         mov cx,posY
      inc bx
      jmp recursividad

   fin:

endm



;##############################################################################
;########################## LLENAR TERRITORIO BLANCA        ###################
;##############################################################################
llenarBlancas macro posXI,posXF,posY
   LOCAL recursividad,fin
   mov cx,posY 
   mov bx,posXI 
   
   recursividad:
      cmp bx,posXF 
      jge fin
         mov temp3,bx 
         mapeoLexico 

         mov [tablero + bx],6d 
         

         mov bx,temp3 
         mov cx,posY
      inc bx
      jmp recursividad

   fin:

endm

;##############################################################################
;########################## OBTENER PUNTUACION        ###################
;##############################################################################
obtenerPuntuacion macro
   LOCAL recursividadY,finY,finX,recursividadX,negra,blanca,salto
   
   mov bx,8d
   recursividadY:
      cmp bx,0d 
      jle finY
      mov cx,1d
      recursividadX:
         cmp cx,8d 
         jg finX
         
         mov temp,bx
         mov temp2,cx 

         mov bx,cx 
         mov cx,temp

         mapeoLexico 
         cmp [tablero + bx],2d
         je negra 
         cmp [tablero + bx],5d 
         je negra 
         cmp [tablero + bx],3d
         je blanca
         cmp [tablero + bx],6d 
         je blanca 

         jmp salto 

         negra: 
            inc puntuacionNegras 
            jmp salto 
         
         blanca: 
            inc puntuacionBlancas

         salto:



         
         mov bx,temp 
         mov cx,temp2
         inc cx
         jmp recursividadX
      finX:
      mov bx,temp
      dec bx
      jmp recursividadY
      
   finY:
endm

;##############################################################################
;########################## REINICIAR       ###################
;##############################################################################

reiniciarJuego macro
   LOCAL recursividad,fin
   mov puntuacionBlancas,0d
   mov puntuacionNegras,0d
   mov tempTurno,0d
   mov flagPass,0d
   xor bx,bx 
   recursividad:
   cmp bx,64d
   jg fin

   mov [tablero + bx],0d
   inc bx
   jmp recursividad


   fin:

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

      msgPuntuacionB db 10,"Blancas:$"
      msgPuntuacionN db 10,"Negras:$"

      msgGanadorBlancas db 10,"El ganador son las blancas uwu$"
      msgGanadorNegras db 10,"El ganador son las negras uwu$"
      msgDespedida db 10,"Presione cualquier tecla para salir....$"

      msgSuicidio db 10,"No se puede realizar suicidio...$"
   ;-------------------------------------------- TABLERO ---------------------------------------------------------------------
      tablero db 70 dup(0)
      turno db ?
      flagPass db 2 dup(0)

      puntuacionBlancas db 4 dup(0)
      puntuacionNegras db 4 dup(0)

   ;------------------------------------------- INSTRUCCIONES ----------------------------------------------------------------
      instruccion db 4 DUP("$")
   
   ;----------------------------------------------------- ARCHIVO --------------------------------------------------------------
      ingresarArchivo db 10,"Ingrese el nombre del archivo: $";
      nombreArchivo db 13,0,13 dup("$")
      nombreArchivo2 db 13,0,13 dup("$")
      creadoExito db 10,"Se ha creado el archivo$"
      openFallido db 10,"No se ha podido abrir el archivo$"
      creadoFallido db 10,"No se ha podido guardar la partida$"
      partidaGuardara db 10,"Se ha guardado la partida$"
      cargaExito db 10,"Se ha cargado con exito la partida$"
      filehandle dw ?
      cadena db 2 DUP("$")
      buffer db 66 dup (24h)

   ;------------------------------------------------------ HTML ----------------------------------------------------------------
      html db "<!DOCTYPE html>",10,"<html lang=",34,"es",34,">",10,"<head>",10,"$"
      headHtml db "<link rel=",34,"stylesheet",34,"href=",34,"style.css",34,">",10,"<meta charset=",34,"UTF-8",34,">",10,"<title>201612118</title>",10,"</head>",10,"$"
      bodyHtml db "<body>",10,"<div class=",34,"board",34,">",10,"<img src=",34,"board.png",34,"/>",10,"<div class=",34,"boardGrid",34,">",10,"$"
      closeBodyHtml db "</div>",10,"</div>",10,"</body>",10,"$"
      closeHtml db "</html>$"
      sinFichaHtml db "<div class=",34,"gridSpace",34,">0</div>",10,"$"
      BFichaHtml db "<div class=",34,"gridSpace white",34,">0</div>",10,"$"
      NFichaHtml db "<div class=",34,"gridSpace black",34,">0</div>",10,"$"
      circle db "<div class=",34,"circle",34,">0</div>",10,"$"
      triangle db "<div class=",34,"triangle",34,">0</div>",10,"$"
      square db "<div class=",34,"square",34,">0</div>",10,"$"

      direccionTablero db "C:\p4\salida\estadoTablero.html",0
      direccionTablero2 db "C:\p4\salida\reporte2.html",0

      showExitoso db "Se creo un html con el estado del tablero",10,"$"
      showFallado db "No se pudo crear el html con el estado del tablero",10,"$"
      h1Html db "<h1>$"
      h1closeHtml db "</h1>",10,"$"
      diagonal db "/$"
      dspuntos db ":$"
      espacioss db "   $"
      day db 2 DUP(0),"$"
      day2 db 2 DUP(0),"$"

      month db 2 DUP(0),"$"

      year dw 8 DUP(0),"$"
      year1 db 2 DUP(0),"$"
      year2 db 2 DUP(0),"$"
      year3 db 2 DUP(0),"$"
      year4 db 2 DUP(0),"$"

      horas DB ?, '$'
      minutos DB ?,'$'
      segundos DB ?,'$'

   ;---------------------------------------- OTROS---,--------------------------------------------------------------------
      temp dw ?
      temp2 dw ?
      temp3 dw ?
      temp4 dw ?
      temp5 db 0
      temp6 dw ?
      temp7 db 0
      temp8 dw ? 
      temp9 dw ?
      tempTurno db 0
      tempSuicidio db 0
.code
 
inicio:
   mov ax,@data
   mov ds,ax
   mov dx,ax
   menu:
   ; Mostrar Cabecera
   mostrarCaracter 10
   mostrarCaracter 10
   mostrar cabecera
   mostrar opciones
   ; Pedir una opcion
   ingresarCaracter
   mov turno,0d ; Negras Inician 0 -> Negras, 1 -> Blancas
   mov bh,0d
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
      ;jmp salida
      
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
      
      
         
         xor ax,ax
         mov ah,0AH                ; interrupcion para obtener algo de consola
         mov dx,offset instruccion                 ; dx apunta al si
         int 21h
        


         lea SI, instruccion + 2
         ;--------------------------------------------------------------- COMANDO EXIT -------------------------------------------------------
         xor bx,bx
         isExit instruccion + 2 ;Si es el comando salir
         cmp bx,1d
         je exitLabel
         
         ;-------------------------------------------------------------- COMANDO SAVE -------------------------------------------------------
         xor bx,bx
         isSave instruccion + 2 ; Si es el comando SAVE
         cmp bx,1d 
         je save

         ;------------------------------------------------------------- COMANDO PASS ------------------------------------------------------
         xor bx,bx
         isPass instruccion + 2 
         cmp bx,1d 
         je pass 

         xor bx,bx 
         isShow instruccion  + 2 
         cmp bx,1d 
         je show
         ;---------------------------------------------------------- MOVIMIENTO EN EL TABLERO ----------------------------------------------
         xor bx,bx
         mostrarCaracter 10
         ; Si quiere poner una ficha donde ya existe una
         controlMovimiento [SI + 0],[si + 1]
         cmp bx,2d 
         je recursividadJuego

         ; Verificar las capturas
         controlCaptura
         prevenirSuicidio
         mov flagPass,0d
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
      mov cx,65
      mov dx,offset buffer
      int 21h
      jc openError
      
      cerrarArchivo
     
      
      cargarEstado
      
      mostrar cargaExito
      xor ax,ax
      xor bx,bx
      xor cx,cx 
      xor dx,dx
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
      
      mov dx,offset nombreArchivo2
      mov bx,dx
      mov ah,0Ah
      xor al,al 
      int 21h
      mov [byte ptr nombreArchivo2+2+8],0
      

      mov ah,3ch 
      mov cx,00000000b
      lea dx,[nombreArchivo2 + 2]
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


   ;###################################################### SHOW ############################################
   show:
      mov ah,3ch 
      mov cx,00000000b
      lea dx, [direccionTablero]
      int 21h
      mov filehandle,ax 
      jnc showE 
      mostrar showFallado
      jmp jugar

         showE:
            mostrar showExitoso
            guardarTablero
            cerrarArchivo
            jmp jugar



   ;###################################################### PASS #################################################3
   pass:
      cmp flagPass,1d 
      je finJuego 
         mov flagPass,1d 
         cambiarTurno
         jmp jugar

      finJuego:
         delimitarTerritorio

         mov ah,3ch 
         mov cx,00000000b
         lea dx, [direccionTablero2]
         int 21h
         mov filehandle,ax 
         jnc passE 
         mostrar showFallado
         jmp salida

            passE: 
               hacerReporte2
               obtenerPuntuacion
               cerrarArchivo

               mostrarCaracter 10
               mostrar msgPuntuacionB
               printNumero puntuacionBlancas
               mostrar msgPuntuacionN
               printNumero puntuacionNegras

               mov bl,puntuacionNegras
               
               cmp bl,puntuacionBlancas
               jg ganadorNegras

               cmp bl,puntuacionBlancas
               jl ganadorBlancas 


               ganadorBlancas:
                  mostrar msgGanadorBlancas
                  jmp despedidaLabel
               
               ganadorNegras:
                  mostrar msgGanadorNegras

               despedidaLabel:
                  mostrar msgDespedida
                  ingresarCaracter
                  reiniciarJuego
               jmp menu

   ;###################################################### EXIT LABEL #################################################
   exitLabel:
      reiniciarJuego
      jmp menu
end 