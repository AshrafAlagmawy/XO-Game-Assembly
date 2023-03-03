
include "emu8086.inc"
org 100h

.data
arr_game db 9 DUP('*')
new_line db 13, 10, "$" 
board_draw db "  |  |  ", 13, 10
           db "==|==|==", 13, 10  
           db "  |  |  ", 13, 10
           db "==|==|==", 13, 10
           db "  |  |  ", 13, 10, "$" 
counter db 0
play2 db 2
is_full db 0
draw db 'X'
input db 0
player_message1 db "PLAYER 1 :", 13, 10, "$"  
player_message2 db "PLAYER 2 :", 13, 10, "$" 
try_again_message db "ERORR POSITION ,TRY AGAIN !", 13, 10, "$"
game_over_message db "*************** Game Over! ***************", 13, 10, "$"    
game_start_message db "********** (TIC TAC TOE) by XT MASTER Team **********", 13, 10, "$"   
win_message1 db "********** PLAYER 1 WIN !!!!!!! **********", 13, 10, "$"
win_message2 db "********** PLAYER 2 WIN !!!!!!! **********", 13, 10, "$"  
type_message db "ENTER YOUR POSITION: $" 

.code 
main proc
    lea     dx, game_start_message 
    call    PRINT
   
      lea     dx, new_line
      call    PRINT    
    
      lea     dx, board_draw
      call    PRINT    
        
      lea     dx, new_line
      call    PRINT    
    
      lea     dx, type_message    
      call    PRINT
      
      lea     dx, new_line
      call    PRINT 
      
      lea     dx, player_message1
      call    PRINT
      
       
   
      go:
      jmp    TAKE_input
  
  
ret

PRINT:      ; print from dx content  
    mov     ah, 9
    int     21h   
    ret 

TAKE_input:  ; take input& put it in ah
    mov     ax,0
    mov     ah, 01       
    int     21h  
    mov     input,al
    CBW
    ;check valid_index
    mov    di,offset input
    mov    si,offset arr_game 
    mov    bl,input
    sub    bx,48
    add    si,bx
    cmp    [si],'*'
    je     PUSH_ARR
    jmp    INVALID 

INVALID:
    lea     dx, new_line
    call    PRINT
    
    lea     dx, try_again_message    
    call    PRINT
     
    jmp     TAKE_input
     
         
PUSH_ARR:
    inc    is_full
    mov    al,draw
    mov    [si],al
    
    ;check position to draw X||O 
    jmp    CHECK_POSITION
     
    countinu1:
    pop    ds 
    lea    dx, new_line
    call   PRINT 
    
    jmp   CHECK_WINNER
    
    
    GAME_OVER:         ;check if game is over (array is full "No winners")
    cmp    is_full,9
    je     PRINT_END
    
    ;change player 
    mov al,counter
    mov bl,play2
    cmp al,bl
    je  PRINT_PLAYER1
    jmp PRINT_PLAYER2 
  
    jmp    TAKE_input
  


PRINT_END:
    lea     dx, game_over_message
    call    PRINT  
    ret
       
PRINT_PLAYER1:
    lea     dx, player_message1
    call    PRINT
    mov     counter,1
    mov     draw,'X'
    jmp     go
    
       
PRINT_PLAYER2:
    lea     dx, player_message2
    call    PRINT
    mov     counter,2
    mov     draw,'O'
    jmp     go
             

CHECK_WINNER: 
CKECK_COL1:              ;CHECK ARRAY COLUMNS
   mov    cl,arr_game[0]
   mov    bl,arr_game[3]
   cmp    cl,'*'
   je     CKECK_COL2
   cmp    cl,bl
   je     col_INDEX1 
   jmp    CKECK_COL2  
CKECK_COL2:
   mov    cl,arr_game[1]
   mov    bl,arr_game[4]
   cmp    cl,'*'
   je     CKECK_COL3
   cmp    cl,bl
   je     col_INDEX2 
   jmp    CKECK_COL3     
CKECK_COL3:
   mov    cl,arr_game[2]
   mov    bl,arr_game[5] 
   cmp    cl,'*'
   je     CKECK_line1
   cmp    cl,bl
   je     col_INDEX3 
   jmp    CKECK_line1   
   
CKECK_line1:             ;CHECK ARRAY LINES
   mov    cl,arr_game[0]
   mov    bl,arr_game[1]
   cmp    cl,'*'
   je     CKECK_line2
   cmp    cl,bl
   je     row_INDEX1 
   jmp    CKECK_line2  
CKECK_line2:
   mov    cl,arr_game[3]
   mov    bl,arr_game[4]
   cmp    cl,'*'
   je     CKECK_line3
   cmp    cl,bl
   je     row_INDEX2 
   jmp    CKECK_line3  
CKECK_line3:
   mov    cl,arr_game[6]
   mov    bl,arr_game[7] 
   cmp    cl,'*'
   je     CKECK_diag1
   cmp    cl,bl
   je     row_INDEX3 
   jmp    CKECK_diag1 
   
CKECK_diag1:             ;CHECK ARRAY DIAGONAL
   mov    cl,arr_game[0]
   mov    bl,arr_game[8]
   cmp    bl,'*'
   je     CKECK_diag2
   cmp    cl,bl
   je     diag_INDEX1 
   jmp    CKECK_diag2  
CKECK_diag2:
   mov    cl,arr_game[2]
   mov    bl,arr_game[6] 
   cmp    bl,'*'
   je     GAME_OVER
   cmp    cl,bl
   je     diag_INDEX2 
   jmp    GAME_OVER  
col_INDEX1:
    mov    bl,arr_game[6]
    cmp    bl,'*'
    je     CKECK_COL2
    cmp    cl,bl     
    je     winner
    jmp    CKECK_COL2 
col_INDEX2:
    mov    bl,arr_game[7]
    cmp    bl,'*'
    je     CKECK_COL3
    cmp    cl,bl     
    je     winner
    jmp    CKECK_COL3 
col_INDEX3:
    mov    bl,arr_game[8]
    cmp    bl,'*'
    je     CKECK_line1
    cmp    cl,bl     
    je     winner
    jmp    CKECK_line1 
    

row_INDEX1:
    mov    bl,arr_game[2]
    cmp    bl,'*'
    je     CKECK_line2
    cmp    cl,bl     
    je     winner
    jmp    CKECK_line2 
row_INDEX2:
    mov    bl,arr_game[5]
    cmp    bl,'*'
    je    CKECK_line3
    cmp    cl,bl     
    je     winner
    jmp    CKECK_line3 
row_INDEX3:
    mov    bl,arr_game[8]
    cmp    bl,'*'
    je    CKECK_diag1
    cmp    cl,bl     
    je     winner
    jmp    CKECK_diag1
    

diag_INDEX1:
    mov    bl,arr_game[4]
    cmp    bl,'*'
    je    CKECK_diag2
    cmp    cl,bl     
    je     winner
    jmp    CKECK_diag2 
diag_INDEX2:
    mov    bl,arr_game[4]
    cmp    bl,'*'
    je    GAME_OVER
    cmp    cl,bl     
    je     winner
    jmp    GAME_OVER 

    
winner:
    mov    al,counter
    mov    bl,play2
    cmp    al,bl
    je     PRINT_WINNER2
    jne    PRINT_WINNER1 
    
          
PRINT_WINNER1:
    lea     dx, win_message1    
    call    PRINT
      
    lea     dx, new_line
    call    PRINT   
    ret

PRINT_WINNER2:
    lea     dx, win_message2    
    call    PRINT
      
    lea     dx, new_line
    call    PRINT  
    ret

   
   
CHECK_POSITION:
POS_0:
   cmp    input,'0'
   je     DRAW_XO_0 
   jmp    POS_1
    
POS_1:
   cmp    input,'1'
   je     DRAW_XO_1 
   jmp    POS_2 
   
POS_2:
   cmp    input,'2'
   je     DRAW_XO_2 
   jmp    POS_3 
   
POS_3:
   cmp    input,'3'
   je     DRAW_XO_3 
   jmp    POS_4
   
POS_4:
   cmp    input,'4'
   je     DRAW_XO_4 
   jmp    POS_5
    
POS_5:
   cmp    input,'5'
   je     DRAW_XO_5 
   jmp    POS_6
      
POS_6:
   cmp    input,'6'
   je     DRAW_XO_6 
   jmp    POS_7
    
POS_7:
   cmp    input,'7'
   je     DRAW_XO_7 
   jmp    DRAW_XO_8 
    

     

DRAW_XO_0:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X0
    jne    DRAW_O0
    
DRAW_XO_1:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X1
    jne    DRAW_O1
DRAW_XO_2:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X2
    jne    DRAW_O2
DRAW_XO_3:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X3
    jne    DRAW_O3
DRAW_XO_4:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X4
    jne    DRAW_O4     
DRAW_XO_5:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X5
    jne    DRAW_O5
DRAW_XO_6:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X6
    jne    DRAW_O6
DRAW_XO_7:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X7
    jne    DRAW_O7     
DRAW_XO_8:       
    mov    bl,draw
    cmp    bl,'X'
    je     DRAW_X8
    jne    DRAW_O8

DRAW_X0:
    mov    ax,0b800h 
    push   ds
    mov    ds,ax
    mov    [322],'X'
    mov    ax,0
    jmp    countinu1 
        
DRAW_O0:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [322],'O'
    mov    ax,0
    jmp    countinu1
      

DRAW_X1:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [328],'X'
    jmp    countinu1 
           
DRAW_O1:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [328],'O'
    jmp    countinu1
      

DRAW_X2:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [334],'X'
    jmp    countinu1 
           
DRAW_O2:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [334],'O'
    jmp    countinu1
          

DRAW_X3:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [642],'X'
    jmp    countinu1 
           
DRAW_O3:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [642],'O'
    jmp    countinu1
      
    
DRAW_X4:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [648],'X'
    jmp    countinu1 
           
DRAW_O4:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [648],'O'
    jmp    countinu1
          

DRAW_X5:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [654],'X'
    jmp    countinu1 
           
DRAW_O5:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [654],'O'
    jmp    countinu1
      

DRAW_X6:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [962],'X'
    jmp    countinu1 
           
DRAW_O6:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [962],'O'
    jmp    countinu1
      

DRAW_X7:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [968],'X'
    jmp    countinu1 
          
DRAW_O7:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [968],'O'
    jmp    countinu1
      

DRAW_X8:
    mov    ax,0b800h
    push   ds
    mov    ds,ax
    mov    [974],'X'
    jmp    countinu1 
           
DRAW_O8:
    mov    ax,0b800h
    push   ds
    mov    ds,ax    
    mov    [974],'O'
    jmp    countinu1
      


   