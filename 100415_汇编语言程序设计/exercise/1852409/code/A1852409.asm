DATA	SEGMENT
X	DW  	55, 127, 37, 512
Y	DW  	4 DUP (?)
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS: CODE, DS: DATA
START:	MOV  	AX, DATA
	MOV	DS, AX
	MOV	DI, 2		;������Ԫ���������ڵ�λ��
	MOV	AX, X[DI]	;ȡ��X���������Ԫ��
	MOV	Y[DI], AX	;����Y���������Ԫ����
	MOV	AX, X[DI+4]	;ȡ��X������ĸ�Ԫ��
	MOV	Y[DI+4], AX	;����Y������ĸ�Ԫ����
	MOV	AX, 4C00H
	MOV	AX,X[6]
	MOV	AX,X[5]
	MOV	AX,X[4]
	MOV	AX,X[3]
	MOV	AX,X[2]
	MOV	AX,X[1]
	MOV	AX,X[0]
	MOV	X[6],0
	MOV	X[2],0
	MOV	AX,X[6]
	MOV	AX,X[5]
	MOV	AX,X[4]
	MOV	AX,X[3]
	MOV	AX,X[2]
	MOV	AX,X[1]
	MOV	AX,X[0]
	INT  	21H
CODE	ENDS
	END	START
