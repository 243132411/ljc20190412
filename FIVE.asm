.386
PUBLIC	NUM1280,NUM64,FUZHU,N,GA1
    INCLUDE LMACRO.LIB
EXTRN	CalRecomdegree:NEAR,SORTGOOD:NEAR,PRINTGOOD:NEAR

DATA	SEGMENT	USE16	PARA    PUBLIC  'DATA'
SHOPNAME		DB	0AH,0DH,'Welcome to LJC Shop$'	;网店名称
TIPNAME			DB	0AH,0DH,'Please type username:$'	;提示输入用户名
TIPKEY			DB	0AH,0DH,'Please type keyword:$'	;提示输入密码
in_name			DB	11	;存储输入的用户名
				DB	0
				DB	11	DUP(0)
in_pwd			DB	7	;存储输入的密码
				DB	0
				DB	7	DUP(0)
AUTH			DB	?	;登陆状态表示符
BNAME			DB	'JIACHENG',0,0	;用户名
BPASS			DB	'123456'	;密码
Login_FAIL		DB	0AH,0DH,'WRONG NAME OR KEY$'	;提示用户名或者密码错误
RTTIP			DB	0AH,0DH,'Please type your information again$'	;提示再次输入用户名和密码
TIPGOOD			DB	0AH,0DH,'Please enter the good name you want to find:$'		;提示输入商品的名字
GA1				DB	'pen',7 DUP(0),10	;商品的名称 折扣
				DW	35,56,70,25,?	;进货价11 销售价13 进货数量15 已售数量17 推荐度19
GA2				DB	'book',6 DUP(0),9
				DW	12,30,25,5,?
GA3				DB	'WANZIQI11',1 DUP(0),9
				DW	50,40,60,4,?
in_good			DB	11	;存储输入的商品名
				DB	0
				DB	11 DUP(0)
CANFG			DB	0AH,0DH,'cant find goods,enter again$'	;提示再次输入商品名
FUZHU			DW	?	;辅助存储
NUM1280			DW	1280
NUM64			DW	64
DATA	ENDS

STACK	SEGMENT	USE16	PARA    STACK
	DB	200	DUP(0)
STACK	ENDS

CODE	SEGMENT	USE16	PARA    PUBLIC  'CODE'
	ASSUME	CS: CODE,DS: DATA,SS: STACK

START:	MOV	AX,DATA
	MOV	DS,AX
	LEA	DX,SHOPNAME	;显示商店名称
	MOV	AH,9
	INT	21H

FOUN1:	LEA	DX,TIPNAME	;功能1开始
	MOV	AH,9
	INT	21H
	LEA	DX,in_name	;输入用户名
	MOV	AH,10
	INT	21H
	MOV	AL,in_name+1	;读取用户输入字符数量
	SUB	AL,2	;如果字符数量大于等于2，则跳转到功能2预处理
	JNS	PFOUN2
	MOV	AL,in_name+2	;获取第一个字符
	SUB	AL,71H	;如果是q，跳转到结束
	JZ	OVER
	MOV	AL,in_name+2	;比较第一个字符是否是回车
	SUB	AL,0DH	;如果是回车，说明是未登录查看，并且跳转到功能3
	MOV	AUTH,0
	JZ	FOUN3
;功能1结束
PFOUN2:	LEA	DX,TIPKEY		;功能2预处理开始
	MOV	AH,9
	INT	21H
	LEA	DX,in_pwd	;输入密码
	MOV	AH,10
	INT	21H
	JMP	FOUN2	;进入功能2
;功能2预处理结束
FOU23:	LEA	DX,Login_FAIL		;登陆失败过程
	MOV	AH,9
	INT	21H
	LEA	DX,RTTIP	;提示再次输入
	MOV	AH,9
	INT	21H
	MOV	AUTH,0	;将登陆状态设为未登陆
	JMP	FOUN1	;跳转到功能1
;登陆失败过程结束
FOUN2:	MOV	CL,in_name+1		;功能2开始
	MOV CH,0
	CMP	CL,8	;如果用户输入用户名不是8个字符，跳转到FOU23进行失败过程
	JNZ	FOU23
	MOV	BX,0		
LOP21:	MOV	AH,BNAME[BX]		;AH记录正确用户名
	MOV	AL,in_name[BX+2]		;AL记录输入用户名
	INC	BX		;BX+1
	CMP	AH,AL	;如果不相同，跳转到FOU23
	JNZ	FOU23
	LOOP	LOP21	;循环
	MOV	CL,in_pwd+1
;用户名正确，开始判断密码
	MOV CH,0
	CMP	CL,6	;如果密码不是6个字符，跳转到FOU23
	JNZ	FOU23
	MOV	BX,0
LOP22:	MOV	AH,BPASS[BX]	;AH记录正确的密码
	MOV	AL,in_pwd[BX+2]	;AL记录输入的密码
	INC	BX
	CMP	AH,AL
	JNZ	FOU23	;如果不相同，跳转到FOU23
	LOOP	LOP22	;循环
;用户名密码都正确
	MOV	AUTH,1	;表示为已登录
	JMP	FOUN3	;跳转到功能3
;功能2结束


FOUN3:	
	CALL	CalRecomdegree
	CALL	SORTGOOD
	MOV	DL,1
	CALL	PRINTGOOD

OVER:	MOV	AH,4CH
	INT	21H
CODE	ENDS
	END	START
