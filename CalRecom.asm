        NAME CalRecom
;子模块 Change_goodinf
    ;功能：从头到尾依次将每个商品的推荐度计算出来。
    ;入口参数：无
    ;出口参数：无
    ;使用到的寄存器:BX
    ;              DX    
    ;              CX     
    ;              AX
    ;                     
.386                  
    PUBLIC  CalRecomdegree
    INCLUDE LMACRO.LIB
    EXTRN   NUM1280:WORD,NUM64:WORD,FUZHU:WORD,GA1:BYTE
CODE    SEGMENT USE16   PARA    PUBLIC  'CODE'
    ASSUME  CS:CODE
CalRecomdegree  PROC
    PUSH    BX
    PUSH    DX
    PUSH    CX
    PUSH    AX
    LEA BX,GA1
Cal1:    MOV	DX,0
	MOV CL,[BX+10]
	MOVSX	CX,CL		
	IMUL	CX,[BX+13]
	MOV	AX,[BX+11]		
	MUL NUM1280			
	DIV	CX			
	MOV	FUZHU,AX		
	MOV	AX,[BX+17]
	MUL NUM64
	DIV WORD PTR [BX+15]
	ADD	AX,FUZHU
	MOV	[BX+19],AX
	ADD BX,21
    CMP BX,OFFSET   GA1+N*21
    JNZ Cal1
    POP     AX
    POP     CX
    POP     DX
    POP     BX
    RET
CalRecomdegree  ENDP
CODE    ENDS
    END
