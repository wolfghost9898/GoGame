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
      
      cmp bx,64d  ; si es mayor a 16 nos salimos del loop
      jge l22
      mov temp,bx
      
      cmp [tablero + bx],2d
      je l23
      cmp [tablero + bx],3d
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
      jmp l21

   l22:
   cmp turno,0d
   je l26 
   mov cadena,49 
   jmp l27 

   l26: 
      mov cadena,48 

   l27:
      escribirArchivo 
endm

;##############################################################################
;########################## CARGAR ESTADO ###################
;##############################################################################
cargarEstado macro
   xor bx,bx 
   mov SI,offset buffer
   
   l28:
      cmp bx,64d
      jge l29
      mov temp,bx
      mov cl,[SI + bx]
      xor ch,ch 
      

      cmp cl,'2'
      je l32 
      
      cmp cl,'3'
      je l33 
      jmp l34
      l32:
         mov [tablero + bx],2d
         jmp l34
      
      l33:
         mov [tablero + bx],3d 
         jmp l34



      l34:
      mov bx,temp
      inc bx
      jmp l28
   l29:
   
   mov cl, buffer + 65
   cmp cl,'0'
   je l30
   mov turno, 1d
   jmp l31 
   l30:
   mov turno,0d

   l31:
   
endm


;##############################################################################
;########################## CERRAR ARCHIVO ###################
;##############################################################################
cerrarArchivo macro
   mov ah,3Eh
   mov bx,filehandle
   int 21h
endm


;##############################################################################
;########################## GUARDAR TABLERO ###################
;##############################################################################
guardarTablero macro
   LOCAL recursividad,fin,blanco,negro,salto,recursividadX,finX
   escribirCadenaArchivo html,40
   escribirCadenaArchivo headHtml,96
   escribirCadenaArchivo bodyHtml,74
   
   mov bx,8d

   recursividad:
      cmp bx,0d
      jle fin 

      mov cx,1d
       
      recursividadX:
         cmp cx,8d
         jg finX 

         mov temp,bx 
         mov temp2,cx 

         mov cx,bx 
         mov bx,temp2
         mapeoLexico

         cmp tablero[bx],3d 
         je blanco 
         cmp tablero[bx],2d
         je negro
         escribirCadenaArchivo sinFichaHtml,31
         jmp salto
      
         blanco:
            escribirCadenaArchivo BFichaHtml,37
            jmp salto
         
         negro:
            escribirCadenaArchivo NFichaHtml,37
         salto:

         mov bx,temp
         mov cx,temp2
         inc cx
         jmp recursividadX

      finX:

   dec bx
   jmp recursividad 
   fin:

   escribirCadenaArchivo closeBodyHtml,27
endm
;##############################################################################
;########################## ESCRIBIR UNA CADENA EN UN ARCHIVO###################
;##############################################################################
escribirCadenaArchivo macro cadena, tam
   mov ah,40h
   mov bx,filehandle
   mov cx,tam
   mov dx, offset cadena 
   int 21h

   mov ah,40h
endm