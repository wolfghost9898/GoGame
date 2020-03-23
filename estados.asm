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
;########################## COMANDO SHOW            ###################
;##############################################################################
isShow macro palabra
   LOCAL l15,l16,l17,l18,l19,l20
   mov dl, [SI + 0]
   cmp dl,'S'
   je l15 ;Verdadera
   jmp l16 ;Falsa

   l15:
      mov dl, [SI + 1]
      cmp dl,'H'
      je l17 ;Verdadera
      jmp l16 ;Falsa

   l17:
      mov dl, [SI + 2]
      cmp dl,'O'
      je l18 ;Verdadera
      jmp l16 ;Falsa


   l18:
      mov dl, [SI + 3]
      cmp dl,'W'
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
;########################## COMANDO PASS            ###################
;##############################################################################
isPass macro palabra
   LOCAL l15,l16,l17,l18,l19,l20
   mov dl, [SI + 0]
   cmp dl,'P'
   je l15 ;Verdadera
   jmp l16 ;Falsa

   l15:
      mov dl, [SI + 1]
      cmp dl,'A'
      je l17 ;Verdadera
      jmp l16 ;Falsa

   l17:
      mov dl, [SI + 2]
      cmp dl,'S'
      je l18 ;Verdadera
      jmp l16 ;Falsa


   l18:
      mov dl, [SI + 3]
      cmp dl,'S'
      je l19 ;Verdadera
      jmp l16 ;Falsa

   l19: 
      mov bx,1d
      jmp l20

   l16:
      mov bx,0d
   
   l20:
endm 