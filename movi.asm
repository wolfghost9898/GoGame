;##############################################################################
;########################## CONTROL CAPTURA           ###################
;##############################################################################
controlCaptura macro
    LOCAL posY,posX,forY,finY,forX,finX,noCapturado,capturarBlanco,capturarNegra,saltarCaptura
    mov bx,8d

    forY:
        cmp bx,0d
        jle finY 

        mov cx,1d

        forX:
            cmp cx,8d
            jg finX

                mov temp,cx
                mov temp2,bx

                mov cx,bx 
                mov bx,temp 
                mapeoLexico
                
                mov bl,[tablero + bx]
                xor bh,bh

               
                cmp bx,2d
                je capturarNegra
                cmp bx,3d
                je capturarBlanco
                capturaEsquina temp,temp2,0d
                jmp saltarCaptura
                capturarNegra:
                   capturaEsquina temp,temp2,2d
                   jmp saltarCaptura
                capturarBlanco:
                    capturaEsquina temp,temp2,3d
                    jmp saltarCaptura
                
                saltarCaptura:

                cmp bx,0d
                je noCapturado
                
                mov cx,temp2 
                mov bx,temp 
                mapeoLexico 
                mov [tablero + bx],0d



                noCapturado:
                    mov cx,temp 
                    mov bx,temp2
            inc cx 
            jmp forX

        finX:
        dec bx 
        jmp forY

    finY:

endm


;##############################################################################
;########################## CAPTURA EN ESQUINAS          ###################
;##############################################################################
capturaEsquina macro posX,posY,tipo
    LOCAL izquierda,derecha,arriba,arriba2,salida,abajo,abajo2
    
    
    cmp posX,1d 
    je izquierda
    
    cmp posX,8d
    je derecha

    capturarCuerpo posX,posY,tipo
    jmp salida
    
    izquierda:
        cmp posY,8d
        je arriba 

        cmp posY,1d
        je abajo 

        capturarCuerpo posX,posY,tipo
        jmp salida


        arriba:
            esquinas 2d,8d,1d,7d,tipo
            jmp salida
        
        abajo:
            esquinas 2d,1d,1d,2d,tipo 
            jmp salida


    derecha:       
        cmp posY,8d
        je arriba2

        cmp posY,1d
        je abajo2

        capturarCuerpo posX,posY,tipo
        jmp salida

        arriba2:
            esquinas 7d,8d,8d,7d,tipo
            jmp salida

        abajo2:
            esquinas 7d,1d,8d,2d,tipo
            jmp salida
    
    
   


    salida:
    

endm


;##############################################################################
;########################## CAPTURA ESQUINAS        ###################
;##############################################################################

esquinas macro posX,posY,posX2,posY2,tipo
    LOCAL libertad,salida,l0,l1,noLibertad
    mov bx,posX
    mov cx,posY

    mapeoLexico

    
    cmp [tablero + bx],0d
    je libertad
    
    
    mov bx,posX2
    mov cx,posY2
    mapeoLexico
        
    cmp [tablero + bx],0d
    je libertad

    
    mov bx,posX
    mov cx,posY
    mapeoLexico

       

    cmp [tablero + bx],tipo
    je libertad 

    mov bx,posX2
    mov cx,posY2
    mapeoLexico

        
    mov ax,tipo 
    xor ah,ah
    cmp [tablero + bx],tipo
    je libertad
        
    cmp [tablero + bx],0d
    je libertad

    noLibertad:
        mov bx,1d
        jmp salida


    ; Hay una libertad 
    libertad:
        mov bx,0d

    
    salida:
    
endm



;##############################################################################
;########################## CAPTURA CUERPO         ###################
;##############################################################################
capturarCuerpo macro posX,posY,tipo
    LOCAL libertad,salida

    mov bx,posY 
    mov cx,posX
    buscarLibertadNorte tipo 
    
    cmp bx,0d
    je libertad 

    mov bx,posY
    mov cx,posX
    buscarLibertadSur tipo

    cmp bx,0d 
    je libertad

    mov bx,posY
    mov cx,posX 
    buscarLibertadEste tipo 

    cmp bx,0d
    je libertad

    mov bx,posY
    mov cx,posX 
    buscarLibertadOeste tipo 
    
    cmp bx,0d
    je libertad

    mov bx,1d

    jmp salida


    libertad:
        mov bx,0d
    
    salida:
        


       
endm

;##############################################################################
;########################## BUSCAR LIBERTAD  NORTE       ###################
;##############################################################################
buscarLibertadNorte macro tipo 
    LOCAl posY,finY,libertad,salida,sinLibertad 

    posY:
        cmp bx,8d
        jg finY

        mov temp3,bx
        mov temp4,cx
        
        mov bx,cx 
        mov cx,temp3 
        mapeoLexico

        cmp [tablero + bx],0d
        je libertad

        cmp [tablero + bx],tipo 
        jne sinLibertad

        mov bx,temp3 
        mov cx,temp4


        inc bx
        jmp posY
    finY:
        mov bx,3d
        jmp salida 
    
    libertad:
        mov bx,0d
        jmp salida
    
    sinLibertad:
        mov bx,1d 
        jmp salida
    
    salida:
endm


;##############################################################################
;########################## BUSCAR LIBERTAD  SUR       ###################
;##############################################################################
buscarLibertadSur macro tipo 
    LOCAl posY,finY,libertad,salida,sinLibertad 

    posY:
        cmp bx,0d
        jle finY

        mov temp3,bx
        mov temp4,cx
        
        mov bx,cx 
        mov cx,temp3 
        mapeoLexico

        cmp [tablero + bx],0d
        je libertad

        cmp [tablero + bx],tipo 
        jne sinLibertad

        mov bx,temp3 
        mov cx,temp4


        dec bx
        jmp posY
    finY:
        mov bx,3d
        jmp salida 
    
    libertad:
        mov bx,0d
        jmp salida
    
    sinLibertad:
        mov bx,1d 
        jmp salida
    salida:
endm


;##############################################################################
;########################## BUSCAR LIBERTAD  ESTE       ###################
;##############################################################################
buscarLibertadEste macro tipo 
    LOCAl posX,finX,libertad,salida,sinLibertad 

    posX:
        cmp cx,8d
        jg finX

        mov temp3,bx
        mov temp4,cx
        
        mov bx,cx 
        mov cx,temp3 
        mapeoLexico

        cmp [tablero + bx],0d
        je libertad

        cmp [tablero + bx],tipo 
        jne sinLibertad

        mov bx,temp3 
        mov cx,temp4


        inc cx
        jmp posX
    finX:
        mov bx,3d
        jmp salida 
    
    libertad:
        mov bx,0d
        jmp salida
    
    sinLibertad:
        mov bx,1d 
        jmp salida
    salida:
endm


;##############################################################################
;########################## BUSCAR LIBERTAD  OESTE       ###################
;##############################################################################
buscarLibertadOeste macro tipo 
    LOCAl posX,finX,libertad,salida,sinLibertad 

    posX:
        cmp cx,0d
        jle finX

        mov temp3,bx
        mov temp4,cx
        
        mov bx,cx 
        mov cx,temp3 
        mapeoLexico

        cmp [tablero + bx],0d
        je libertad

        cmp [tablero + bx],tipo 
        jne sinLibertad

        mov bx,temp3 
        mov cx,temp4


        dec cx
        jmp posX
    finX:
        mov bx,3d
        jmp salida 
    
    libertad:
        mov bx,0d
        jmp salida
    
    sinLibertad:
        mov bx,1d 
        jmp salida
    salida:
endm