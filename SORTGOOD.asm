NAME SORTGOOD
;子模块 SORTGOOD
;功能：将
;输入：无
;输出：无
;用到的寄存器：CX，DX，DI，SI，AX，BX，（S1是排序CX存储N）
.386
    PUBLIC  SORTGOOD,S1
    EXTRN   GA1:BYTE
    INCLUDE LMACRO.LIB
DATA   SEGMENT USE16   PARA    PUBLIC  'DATA'
    S1  SORTC   <>
DATA   ENDS
CODE    SEGMENT USE16   PARA    PUBLIC  'CODE'
    ASSUME  CS:CODE,DS:DATA
SORTGOOD    PROC
    PUSH    CX
    PUSH    DX
    PUSH    DI
    PUSH    SI
    PUSH    AX
    PUSH    BX
    MOV DI,0
    MOV AX,0
SLOP:    MOV S1.SORT[DI],AX    ;结构体内容为01234……
    ADD DI,2
    INC AX
    CMP AX,N
    JNZ SLOP
    MOV CX,N
    DEC CX;循环次数
    LEA BX,GA1
SO1:     MOV DX,CX;DX比较次数
    MOV SI,OFFSET S1    ;SI获得结构体基址
SO2:     MOV DI,[SI] ;DI获得商品的序号
    IMUL    DI,21
    MOV AX,[DI+BX+19]
    MOV DI,[SI+2]
    IMUL    DI,21
    CMP AX,[DI+BX+19]
    JNS NOXCH
    MOV AX,[SI]
    XCHG    AX,[SI+2]
    MOV [SI],AX
NOXCH:  
    ADD SI,2
    DEC DX
    JNE SO2
    LOOP SO1
    POP     BX
    POP     AX
    POP     SI
    POP     DI
    POP     DX
    POP     CX
    RET
SORTGOOD    ENDP
CODE    ENDS
    END



