;##############################################################################
;########################## CONTROL CAPTURA           ###################
;##############################################################################
controlCaptura macro
    LOCAL posY,posX,forY,finY,forX,finX,noCapturado
    mov bx,8d

    forY:
        cmp bx,0d
        jle finY 

        mov cx,0d

        forX:
            cmp cx,7d
            jg finX

                mov temp,cx
                mov temp2,bx

                mov cx,bx 
                mov bx,temp 
                mapeoLexico
                
                mov bx,tablero[bx]
                 

               

                capturaEsquina temp,temp2,bx
                cmp bx,0d
                je noCapturado
                
                mov cx,temp2 
                mov bx,temp 
                mapeoLexico 
                mov tablero[bx],1d



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
    LOCAL izquierda,derecha,arriba,arriba2,salida,abajo
    
    
    cmp posX,0d 
    je izquierda
    
    cmp posX,7d
    je derecha



    mov bx,0d
    jmp salida
    
    izquierda:
        cmp posY,8d
        je arriba 

        cmp posY,1d
        je abajo 

        mov bx,0d 
        jmp salida


        arriba:
            esquinas 1d,8d,0d,7d,tipo
            jmp salida
        
        abajo:
            esquinas 0d,2d,1d,1d,tipo 
            jmp salida


    derecha:       
        cmp posY,8d
        je arriba2

        mov bx,0d 
        jmp salida

        arriba2:
            esquinas 6d,8d,7d,7d,tipo
            jmp salida
    
    
    salida:
    

endm


;##############################################################################
;########################## CAPTURA ESQUINA SUPERIOR IZQUIERDA         ###################
;##############################################################################

esquinas macro posX,posY,posX2,posY2,tipo
    LOCAL libertad,salida,l0,l1,noLibertad
    mov bx,posX
    mov cx,posY

    mapeoLexico

    cmp tablero[bx],2d
    je l0
    cmp tablero[bx],3d
    je l0

    jmp libertad
    l0:
        mov bx,posX2
        mov cx,posY2
        mapeoLexico
        
        cmp tablero[bx],2d
        je l1
        cmp tablero[bx],3d
        je l1

        jmp libertad

    l1:
        mov bx,posX
        mov cx,posY
        mapeoLexico

       


        cmp tablero[bx],tipo
        je libertad 

        mov bx,posX2
        mov cx,posY2
        mapeoLexico

        

        cmp tablero[bx],tipo 
        je libertad
        

        

        cmp tipo,1d
        je libertad
        
        
        noLibertad:
            mov bx,1d
            jmp salida


    ; Hay una libertad 
    libertad:
        mov bx,0d

    salida:
    
endm