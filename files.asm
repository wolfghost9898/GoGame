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
      
      cmp bx,128d  ; si es mayor a 16 nos salimos del loop
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
      mov ax,2d
      mul bx 
      mov bx,ax

      cmp cl,'2'
      je l32 
      
      cmp cl,'3'
      je l33 
      jmp l34
      l32:
         mov tablero[bx],2d
         jmp l34
      
      l33:
         mov tablero[bx],3d 
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