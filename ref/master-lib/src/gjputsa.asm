; master library - PC98
;
; Description:
;	�e�L�X�g��ʂւ̊O��������̏�������
;	���w��Ȃ��E��������
;
; Function/Procedures:
;	void gaiji_putsa( unsigned x, unsigned y, char *strp, unsigned atrb ) ;
;
; Parameters:
;	unsigned x	���[�̍��W ( 0 �` 79 )
;	unsigned y	��[�̍��W ( 0 �` 24 )
;	char * strp	�O��������̐擪�A�h���X ( NULL�͋֎~ )
;	unsigned atrb	����
;
; Returns:
;	none
;
; Binding Target:
;	Microsoft-C / Turbo-C / Turbo Pascal
;
; Running Target:
;	PC-9801
;
; Requiring Resources:
;	CPU: 8086
;
; Notes:
;	
;
; Compiler/Assembler:
;	TASM 3.0
;	OPTASM 1.6
;
; Author:
;	���ˏ��F
;
; Revision History:
;	92/11/24 Initial
;	93/1/26 bugfix

	.MODEL SMALL

	include func.inc

	.DATA
	EXTRN TextVramSeg:WORD

	.CODE

func GAIJI_PUTSA
	mov	DX,BP	; push BP
	mov	BP,SP

	push	SI
	push	DI

	; ����
	x	= (RETSIZE+2+DATASIZE)*2
	y	= (RETSIZE+1+DATASIZE)*2
	strp	= (RETSIZE+1)*2
	atrb	= (RETSIZE+0)*2

	mov	AX,[BP + y]	; �A�h���X�v�Z
	mov	DI,AX
	shl	AX,1
	shl	AX,1
	add	DI,AX
	shl	DI,1		; DI = y * 10
	add	DI,TextVramSeg
	mov	ES,DI
	mov	DI,[BP + x]
	shl	DI,1

	_push	DS
	_lds	SI,[BP+strp]
	mov	CX,DI
	mov	BX,[BP+atrb]

	mov	BP,DX	; pop BP

	lodsb
	or	AL,AL
	je	short EXITLOOP
	EVEN
SLOOP:
	mov	AH,AL
	mov	AL,0
	rol	AX,1
	shr	AX,1
	adc	AL,56h
	stosw
	or	AH,80h
	stosw

	lodsb
	or	AL,AL
	jne	short SLOOP
EXITLOOP:

	; �����̏�������
	xchg	CX,DI
	sub	CX,DI
	shr	CX,1
	mov	AX,BX	; atrb
	add	DI,2000h
	rep	stosw

	_pop	DS
	pop	DI
	pop	SI
	ret	(3+datasize)*2
endfunc

END