;------------------------------------------------------------
    ; 完成了！
    ; 2019/8/2
;------------------------------------------------------------

DATA SEGMENT
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
     FILENAME DB        'mystu.txt',0
      HANDLE  DW        0
         BUF  DB        100 DUP(0)
     ERRMSG1  DB        13,10,'error a $'
     ERRMSG2  DB        13,10,'error b $'
     ERRMSG3  DB        13,10,'error c $'
         NUM  DW        0
     LOOPNUM  DW        0
        NINE  DW        9
MAIN:
    MOV AL, 12H
    CALL COUNT
    CALL RANDOM

    PUSH AX
    PUSH BX
    MOV BX, 9
    MUL BX
    MOV LOOPNUM, AX
    POP BX
    POP AX

    INC AL
    CALL CHANGE
    CALL PRINTSPACE
    CALL PRINTNUM

    JMP ENDMAIN
    

;------------------------------------------------------------
CHANGE: ; 把一个AL上的16进制数，转换成10进制输出
        ; 但是不进行十进制的储存，只是输出
    MOV BX, 0AH
    MOV CX, 0       ; cx表征这个数字以十进制表示的位数
    AND AX, 00FFH
PUSHLOOP:           ; 这个循环负责把模10得到的数字压入栈中
    MOV DX, 0       ; 清零，这是必要的操作
    DIV BX          ; div 10
    PUSH DX         ; 把第n次除以10得到的商压入栈中，即倒数第n位
    INC CX          ; 计数器+1
    CMP AX, 0       ; 把ax和0比较，如果ax不为0，说明还要继续除10
    JNE PUSHLOOP    ; 如果是0，那么就完成了压栈工作
POPLOOP:            ; 这个循环负责把栈中的数字弹出并且打印
    POP DX          ; 第n次弹出的就是这个数字从高位数的第n位
    ADD DX, '0'     ; 不能只是0~9的数字，还要加一个‘1’
    MOV AH, 02H     ; dx就是02功能调用的入口
    INT 21H         
    LOOP POPLOOP    ; 当计数器cx不为0，说明栈中还有数字，继续
    RET
;------------------------------------------------------------

;------------------------------------------------------------
RANDOM: ; 生成 0 ~ n-1 之间的随机数
        ; 把学生个数放在BL上，然后把取模得数的数字放在AX上
    MOV AH, 0
    INT 1AH         ; 得到的日时数在CX：DX上，我只取DX上的数字
    MOV AX, DX      ; 之后要进行div操作，先把dx移到ax上
    AND AX, 00FFH   ; 一种故意的处理，并非必要
    DIV BL          ; div就是取模的手段
                    ; 对于AX DIV AL，余数在AH，商在AL
    MOV AL, AH      ; 只是一种辅助ax高位清零的手段（我们需要AH
    AND AX, 00FFH   ; 把ax高位清0，低位不变
    RET
;------------------------------------------------------------

;------------------------------------------------------------
COUNT: ; 数清楚到底有多少个学号
       ; 需要把filename，handle，buf，num全部放在code区，返回bl
    PUSH CS         ; 由于代码是把filename，handle，buf全部放在
    POP DS          ; 代码区，所以代码区即为此数据区
    PUSH CS         ; 我也不知为何，数据会从076a而不是075a开始
    POP ES          ; 
 
    MOV AH,3DH      ; 打开文件      
    LEA DX,FILENAME ; 要把FILENAME给到dx
    MOV AL,0        ; 
    INT 21H         ;
    JC  ERROR1      ; 打开失败
    MOV HANDLE,AX   ; ax得到文件句柄，赋给handle
 
COUNTLOOP:
    MOV AH,3FH      ; 读文件
    MOV BX,HANDLE   ; 把文件句柄也给bx
    MOV CX,1        ; cx标志的是每次读取的个数，这里为单字读取
    LEA DX,BUF      ; dx得到buf缓冲区的地址
    INT 21H         ;
    JC  ERROR2      ; 读取失败
    CMP AX,1        ; 进行比较，如果没有读完，那么ax为1，不跳出
    JNE COUNTEND    ; 如果ax不为1，为0，那么not equal 跳出
    INC NUM         ; 对num计数器++操作
    JMP COUNTLOOP   ; 说明还没有读完文件，继续循环操作
 
COUNTEND:
    MOV AH,3EH      ; 关闭文件
    MOV BX,HANDLE   ;
    INT 21H         ;
    JC  ERROR3      ; 关闭失败
    MOV AX, NUM     ;
    CMP AX, 7
    JE  ONLYONE
    JMP NOTONE
NOTONE:
    MOV BL, 9       ;
    DIV BL          ;
    AND AX, 00FFH
    MOV BL, AL
    JMP RETURN
ONLYONE:
    MOV AL, 1
    MOV BL, 1
    JMP RETURN
RETURN:
    RET
;------------------------------------------------------------

;------------------------------------------------------------
PRINTNUM: ; 打印对应的学号
          ; 需要LOOPNUM上有对应的数字 （不能动dx
    PUSH CS         ; 由于代码是把filename，handle，buf全部放在
    POP DS          ; 代码区，所以代码区即为此数据区
    PUSH CS         ; 我也不知为何，数据会从076a而不是075a开始
    POP ES          ; 
 
    MOV AH,3DH      ; 打开文件      
    LEA DX,FILENAME ; 要把FILENAME给到dx
    MOV AL,0        ; 
    INT 21H         ;
    MOV HANDLE,AX   ; ax得到文件句柄，赋给handle

    CMP LOOPNUM, 0  ; 防止暴毙的操作，因为后面相仿的判断为1
    JE PRINTLOOP    ; 如果是0的话，应该正好打印第一个学号才对

JUMPLOOP:
    MOV AH,3FH      ; 读文件
    MOV BX,HANDLE   ; 把文件句柄也给bx
    MOV CX,1        ; cx标志的是每次读取的个数，这里为单字读取
    LEA DX,BUF      ; dx得到buf缓冲区的地址
    INT 21H         ;
    CMP LOOPNUM, 1  ;
    JE PRINTLOOP
    DEC LOOPNUM     ; 对num计数器++操作
    JMP JUMPLOOP   ; 说明还没有读完文件，继续循环操作
PRINTLOOP:
    MOV AH,3FH      ; 读文件
    MOV BX,HANDLE   ; 把文件句柄也给bx
    MOV CX,1        ; cx标志的是每次读取的个数，这里为单字读取
    LEA DX,BUF      ; dx得到buf缓冲区的地址
    INT 21H         ; 
    MOV AH,02H      ; 2号功能
    MOV DL,BUF[0]   ; buf区的第0个元素就是刚才读取的数字
    INT 21H         ;
    DEC NINE        ; 循环变量
    CMP NINE,0      ; 进行判断，如果读了9个，那么就读完了一个学号
    JE PRINTEND     ; 读完了就跳到下一个代码段
    JMP PRINTLOOP   ;

PRINTEND:
    MOV AH,3EH      ; 关闭文件
    MOV BX,HANDLE   ;
    INT 21H         ;
              
    MOV AX, NUM     ;
    MOV BL, 9       ;
    DIV BL          ;
    AND AX, 00FFH
    MOV BL, AL

    RET
;------------------------------------------------------------

;------------------------------------------------------------
PRINTSPACE:
    MOV AH, 02H
    MOV DL, 20H
    INT 21H

    RET
;------------------------------------------------------------

;------------------------------------------------------------
ERROR1:
    MOV AH, 09H
    LEA DX, ERRMSG1
    INT 21H
    MOV AX, 4C00H
    INT 21H
ERROR2:
    MOV AH, 09H
    LEA DX, ERRMSG2
    INT 21H
    MOV AX, 4C00H
    INT 21H
ERROR3:
    MOV AH, 09H
    LEA DX, ERRMSG3
    INT 21H
    MOV AX, 4C00H
    INT 21H
;------------------------------------------------------------

;------------------------------------------------------------
ENDMAIN:
    MOV AX, 4C00H
    INT 21H
;------------------------------------------------------------

CODE ENDS
END MAIN