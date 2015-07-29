
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rtc_status=R5
	.DEF _TOUCH_X=R6
	.DEF _TOUCH_Y=R8
	.DEF _TOUCH_X_LAST=R10
	.DEF _TOUCH_Y_LAST=R12
	.DEF _i=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr
	JMP  0x00
	JMP  0x00

_blank_symb:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_S_46:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x80,0x1,0x80,0x0,0x0,0x0,0x0
_S_UP:
	.DB  0x0,0x0,0x1,0x80,0x3,0xC0,0x7,0xE0
	.DB  0x6,0x60,0xC,0x30,0xC,0x30,0x18,0x18
	.DB  0x18,0x18,0x30,0xC,0x30,0xC,0x60,0x6
	.DB  0x60,0x6,0x7F,0xFE,0x7F,0xFE,0x0,0x0
_S_DOWN:
	.DB  0x0,0x0,0x7F,0xFE,0x7F,0xFE,0x60,0x6
	.DB  0x60,0x6,0x30,0xC,0x30,0xC,0x18,0x18
	.DB  0x18,0x18,0xC,0x30,0xC,0x30,0x6,0x60
	.DB  0x7,0xE0,0x3,0xC0,0x1,0x80,0x0,0x0
_S_48:
	.DB  0x0,0x0,0x7,0xE0,0xC,0x30,0x18,0x18
	.DB  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
	.DB  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
	.DB  0xC,0x30,0x7,0xE0,0x0,0x0,0x0,0x0
_S_49:
	.DB  0x0,0x0,0x1,0x80,0x3,0x80,0x7,0x80
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x3,0xC0,0x0,0x0,0x0,0x0
_S_50:
	.DB  0x0,0x0,0x7,0xE0,0xC,0x30,0x18,0x18
	.DB  0x10,0x8,0x0,0x18,0x0,0x30,0x0,0x60
	.DB  0x0,0xC0,0x1,0x80,0x3,0x0,0x6,0x0
	.DB  0xC,0x18,0x1F,0xF8,0x0,0x0,0x0,0x0
_S_51:
	.DB  0x0,0x0,0x7,0xE0,0x8,0x10,0x10,0x8
	.DB  0x10,0x8,0x0,0x10,0x0,0xE0,0x0,0x30
	.DB  0x0,0x18,0x0,0x8,0x0,0x8,0x18,0x18
	.DB  0xC,0x30,0x7,0xE0,0x0,0x0,0x0,0x0
_S_52:
	.DB  0x0,0x0,0x0,0x30,0x0,0x70,0x0,0xF0
	.DB  0x1,0xB0,0x3,0x30,0x6,0x30,0xC,0x30
	.DB  0x18,0x30,0x1F,0xF8,0x0,0x30,0x0,0x30
	.DB  0x0,0x30,0x0,0x78,0x0,0x0,0x0,0x0
_S_53:
	.DB  0x0,0x0,0xF,0xF8,0xF,0xF0,0x8,0x0
	.DB  0x10,0x0,0x10,0x0,0x1F,0xE0,0x0,0x30
	.DB  0x0,0x18,0x0,0x18,0x0,0x18,0x18,0x18
	.DB  0x1C,0x30,0xF,0xE0,0x0,0x0,0x0,0x0
_S_54:
	.DB  0x0,0x0,0x3,0xE0,0x6,0x10,0xC,0x0
	.DB  0x8,0x0,0x18,0x0,0x1F,0xE0,0x1C,0x30
	.DB  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
	.DB  0xC,0x30,0x7,0xE0,0x0,0x0,0x0,0x0
_S_55:
	.DB  0x0,0x0,0x1F,0xF8,0x10,0x18,0x0,0x10
	.DB  0x0,0x20,0x0,0x20,0x0,0x40,0x0,0x40
	.DB  0x0,0x80,0x0,0x80,0x1,0x0,0x1,0x0
	.DB  0x2,0x0,0x2,0x0,0x0,0x0,0x0,0x0
_S_56:
	.DB  0x0,0x0,0x7,0xE0,0xC,0x30,0x8,0x10
	.DB  0x8,0x10,0xC,0x30,0x7,0xE0,0xC,0x30
	.DB  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
	.DB  0xC,0x30,0x7,0xE0,0x0,0x0,0x0,0x0
_S_57:
	.DB  0x0,0x0,0x7,0xE0,0xC,0x30,0x18,0x18
	.DB  0x18,0x18,0x18,0x18,0xC,0x38,0x7,0xF8
	.DB  0x0,0x18,0x0,0x10,0x0,0x20,0x0,0x20
	.DB  0x0,0xC0,0x3,0x0,0x0,0x0,0x0,0x0
_S_32:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_S_33:
	.DB  0x0,0x0,0x1,0x80,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x0,0x0
	.DB  0x1,0x80,0x1,0x80,0x0,0x0,0x0,0x0
_S_40:
	.DB  0x0,0x0,0x0,0x60,0x0,0x80,0x1,0x0
	.DB  0x2,0x0,0x2,0x0,0x4,0x0,0x4,0x0
	.DB  0x4,0x0,0x2,0x0,0x2,0x0,0x1,0x0
	.DB  0x0,0x80,0x0,0x60,0x0,0x0,0x0,0x0
_S_41:
	.DB  0x0,0x0,0x6,0x0,0x1,0x0,0x0,0x80
	.DB  0x0,0x40,0x0,0x40,0x0,0x20,0x0,0x20
	.DB  0x0,0x20,0x0,0x40,0x0,0x40,0x0,0x80
	.DB  0x1,0x0,0x6,0x0,0x0,0x0,0x0,0x0
_S_47:
	.DB  0x0,0x0,0x0,0x0,0x0,0x8,0x0,0x18
	.DB  0x0,0x30,0x0,0x60,0x0,0xC0,0x1,0x80
	.DB  0x3,0x0,0x6,0x0,0xC,0x0,0x18,0x0
	.DB  0x10,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_S_43:
	.DB  0x0,0x0,0x0,0x0,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x3F,0xFC
	.DB  0x3F,0xFC,0x1,0x80,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x1,0x80,0x0,0x0,0x0,0x0
_S_45:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x3F,0xFC
	.DB  0x3F,0xFC,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_S_58:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x80
	.DB  0x1,0x80,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x80,0x1,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_S_60:
	.DB  0x0,0x0,0x0,0x30,0x0,0x60,0x0,0xC0
	.DB  0x1,0x80,0x3,0x0,0x6,0x0,0xC,0x0
	.DB  0x6,0x0,0x3,0x0,0x1,0x80,0x0,0xC0
	.DB  0x0,0x60,0x0,0x30,0x0,0x0,0x0,0x0
_S_61:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0xF,0xF0,0xF,0xF0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xF,0xF0,0xF,0xF0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_S_62:
	.DB  0x0,0x0,0xC,0x0,0x6,0x0,0x3,0x0
	.DB  0x1,0x80,0x0,0xC0,0x0,0x60,0x0,0x30
	.DB  0x0,0x60,0x0,0xC0,0x1,0x80,0x3,0x0
	.DB  0x6,0x0,0xC,0x0,0x0,0x0,0x0,0x0
_S_63:
	.DB  0x0,0x0,0x3,0xC0,0x6,0x60,0xC,0x30
	.DB  0xC,0x30,0x4,0x30,0x0,0x60,0x0,0xC0
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x0,0x0
	.DB  0x1,0x80,0x1,0x80,0x0,0x0,0x0,0x0
_S_192:
	.DB  0x0,0x0,0x0,0xE0,0x0,0xE0,0x1,0x20
	.DB  0x1,0x20,0x2,0x30,0x2,0x10,0x4,0x10
	.DB  0x4,0x18,0xF,0xF8,0x18,0x18,0x10,0xC
	.DB  0x30,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_S_193:
	.DB  0x0,0x0,0x7F,0xFE,0x30,0x1E,0x30,0x2
	.DB  0x30,0x0,0x30,0x0,0x3F,0xF8,0x3F,0xFC
	.DB  0x30,0xE,0x30,0x6,0x30,0x6,0x30,0xE
	.DB  0x3F,0xFC,0x7F,0xF8,0x0,0x0,0x0,0x0
_S_194:
	.DB  0x0,0x0,0x7F,0xF0,0x30,0x18,0x30,0xC
	.DB  0x30,0xC,0x30,0x18,0x3F,0xF8,0x3F,0xFC
	.DB  0x30,0xE,0x30,0x6,0x30,0x6,0x30,0xE
	.DB  0x3F,0xFC,0x7F,0xF8,0x0,0x0,0x0,0x0
_S_195:
	.DB  0x0,0x0,0x7F,0xFE,0x30,0x1E,0x30,0x2
	.DB  0x30,0x0,0x30,0x0,0x30,0x0,0x30,0x0
	.DB  0x30,0x0,0x30,0x0,0x30,0x0,0x30,0x0
	.DB  0x30,0x0,0x78,0x0,0x0,0x0,0x0,0x0
_S_196:
	.DB  0x0,0x0,0x3,0xFC,0x1,0x18,0x1,0x18
	.DB  0x1,0x18,0x1,0x18,0x1,0x18,0x1,0x18
	.DB  0x2,0x18,0x4,0x18,0x8,0x18,0x3F,0xFC
	.DB  0x38,0x3C,0x30,0xC,0x20,0x4,0x0,0x0
_S_197:
	.DB  0x0,0x0,0x7F,0xFC,0x30,0x1C,0x30,0x4
	.DB  0x30,0x0,0x30,0x80,0x3F,0x80,0x3F,0x80
	.DB  0x30,0x80,0x30,0x0,0x30,0x0,0x30,0x4
	.DB  0x30,0x1C,0x7F,0xFC,0x0,0x0,0x0,0x0
_S_198:
	.DB  0x0,0x0,0x63,0xC6,0x51,0x8A,0x11,0x88
	.DB  0x9,0x90,0x9,0x90,0x7,0xE0,0x7,0xE0
	.DB  0xD,0xB0,0x19,0x98,0x11,0x88,0x31,0x8C
	.DB  0x21,0x84,0x63,0xC6,0x0,0x0,0x0,0x0
_S_199:
	.DB  0x0,0x0,0xF,0xE0,0x38,0x38,0x60,0xC
	.DB  0x0,0x4,0x0,0xC,0x3,0xF8,0x0,0x8
	.DB  0x0,0x4,0x0,0x6,0x0,0x6,0x60,0xC
	.DB  0x3F,0xF8,0xF,0xE0,0x0,0x0,0x0,0x0
_S_200:
	.DB  0x0,0x0,0x78,0x1E,0x30,0xC,0x30,0x1C
	.DB  0x30,0x3C,0x30,0x6C,0x30,0xCC,0x31,0x8C
	.DB  0x33,0xC,0x36,0xC,0x3C,0xC,0x38,0xC
	.DB  0x30,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_S_201:
	.DB  0x3,0xC0,0x79,0x9E,0x30,0xC,0x30,0x1C
	.DB  0x30,0x3C,0x30,0x6C,0x30,0xCC,0x31,0x8C
	.DB  0x33,0xC,0x36,0xC,0x3C,0xC,0x38,0xC
	.DB  0x30,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_S_202:
	.DB  0x0,0x0,0x78,0x3C,0x30,0x6C,0x30,0xC0
	.DB  0x31,0x80,0x33,0x0,0x3F,0x0,0x39,0x80
	.DB  0x30,0xC0,0x30,0x60,0x30,0x30,0x30,0x18
	.DB  0x30,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_S_203:
	.DB  0x0,0x0,0x1,0xFE,0x0,0x8C,0x0,0x8C
	.DB  0x0,0x8C,0x0,0x8C,0x1,0xC,0x1,0xC
	.DB  0x1,0xC,0x2,0xC,0x2,0xC,0x4,0xC
	.DB  0x68,0xC,0x70,0x1E,0x0,0x0,0x0,0x0
_S_204:
	.DB  0x0,0x0,0x70,0xE,0x38,0x1C,0x38,0x1C
	.DB  0x34,0x2C,0x34,0x2C,0x34,0x2C,0x32,0x4C
	.DB  0x32,0x4C,0x32,0x4C,0x31,0x8C,0x31,0x8C
	.DB  0x31,0x8C,0x78,0x1E,0x0,0x0,0x0,0x0
_S_205:
	.DB  0x0,0x0,0x78,0x1E,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x30,0xC,0x3F,0xFC,0x3F,0xFC
	.DB  0x30,0xC,0x30,0xC,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_S_206:
	.DB  0x0,0x0,0x7,0xE0,0x1E,0x78,0x38,0x1C
	.DB  0x30,0xC,0x70,0xE,0x70,0xE,0x70,0xE
	.DB  0x70,0xE,0x70,0xE,0x30,0xC,0x38,0x1C
	.DB  0x1E,0x78,0x7,0xE0,0x0,0x0,0x0,0x0
_S_207:
	.DB  0x0,0x0,0x7F,0xFE,0x3F,0xFC,0x30,0xC
	.DB  0x30,0xC,0x30,0xC,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x30,0xC,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_S_208:
	.DB  0x0,0x0,0x7F,0xF8,0x30,0xC,0x30,0x6
	.DB  0x30,0x6,0x30,0x6,0x30,0xC,0x3F,0xF8
	.DB  0x30,0x0,0x30,0x0,0x30,0x0,0x30,0x0
	.DB  0x30,0x0,0x78,0x0,0x0,0x0,0x0,0x0
_S_209:
	.DB  0x0,0x0,0x7,0xE0,0x1E,0x78,0x38,0x1C
	.DB  0x30,0x4,0x70,0x0,0x70,0x0,0x70,0x0
	.DB  0x70,0x0,0x70,0x0,0x30,0x4,0x38,0x1C
	.DB  0x1E,0x78,0x7,0xE0,0x0,0x0,0x0,0x0
_S_210:
	.DB  0x0,0x0,0x7F,0xFE,0x61,0x86,0x41,0x82
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x1,0x80,0x1,0x80,0x1,0x80
	.DB  0x1,0x80,0x3,0xC0,0x0,0x0,0x0,0x0
_S_211:
	.DB  0x0,0x0,0x78,0xE,0x30,0x4,0x18,0x4
	.DB  0xC,0x8,0x6,0x8,0x3,0x10,0x1,0x90
	.DB  0x0,0xE0,0x0,0x60,0x0,0x40,0xC,0x40
	.DB  0xC,0x80,0x7,0x0,0x0,0x0,0x0,0x0
_S_212:
	.DB  0x0,0x0,0x3,0xC0,0x1,0x80,0xF,0xF0
	.DB  0x39,0x9C,0x61,0x86,0x41,0x82,0x41,0x82
	.DB  0x61,0x86,0x39,0x9C,0xF,0xF0,0x1,0x80
	.DB  0x1,0x80,0x3,0xC0,0x0,0x0,0x0,0x0
_S_213:
	.DB  0x0,0x0,0x78,0x1E,0x30,0x4,0x18,0x8
	.DB  0xC,0x10,0x6,0x20,0x3,0x40,0x1,0x80
	.DB  0x2,0xC0,0x4,0x60,0x8,0x30,0x10,0x18
	.DB  0x20,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_S_214:
	.DB  0x0,0x0,0x78,0x1E,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x30,0xC,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x30,0xC,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x7F,0xFE,0x0,0x6,0x0,0x2
_S_215:
	.DB  0x0,0x0,0x78,0x1E,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x30,0xC,0x38,0xC,0x1F,0xFC
	.DB  0x0,0xC,0x0,0xC,0x0,0xC,0x0,0xC
	.DB  0x0,0xC,0x0,0x1E,0x0,0x0,0x0,0x0
_S_216:
	.DB  0x0,0x0,0x7B,0xDE,0x31,0x8C,0x31,0x8C
	.DB  0x31,0x8C,0x31,0x8C,0x31,0x8C,0x31,0x8C
	.DB  0x31,0x8C,0x31,0x8C,0x31,0x8C,0x31,0x8C
	.DB  0x31,0x8C,0x7F,0xFE,0x0,0x0,0x0,0x0
_S_217:
	.DB  0x0,0x0,0x7B,0xDE,0x31,0x8C,0x31,0x8C
	.DB  0x31,0x8C,0x31,0x8C,0x31,0x8C,0x31,0x8C
	.DB  0x31,0x8C,0x31,0x8C,0x31,0x8C,0x31,0x8C
	.DB  0x31,0x8C,0x7F,0xFE,0x0,0x6,0x0,0x2
_S_218:
	.DB  0x0,0x0,0x7C,0x0,0x58,0x0,0x58,0x0
	.DB  0x58,0x0,0x18,0x0,0x18,0x0,0x1F,0xF8
	.DB  0x18,0xC,0x18,0x6,0x18,0x6,0x18,0x6
	.DB  0x18,0xC,0x3F,0xF8,0x0,0x0,0x0,0x0
_S_219:
	.DB  0x0,0x0,0x78,0x1E,0x30,0xC,0x30,0xC
	.DB  0x30,0xC,0x30,0xC,0x30,0xC,0x3F,0x8C
	.DB  0x30,0x4C,0x30,0x2C,0x30,0x2C,0x30,0x2C
	.DB  0x30,0x4C,0x7F,0x9E,0x0,0x0,0x0,0x0
_S_220:
	.DB  0x0,0x0,0x78,0x0,0x30,0x0,0x30,0x0
	.DB  0x30,0x0,0x30,0x0,0x30,0x0,0x3F,0xF8
	.DB  0x30,0xC,0x30,0x6,0x30,0x6,0x30,0x6
	.DB  0x30,0xC,0x7F,0xF8,0x0,0x0,0x0,0x0
_S_221:
	.DB  0x0,0x0,0x7,0xE0,0x1E,0x78,0x38,0x1C
	.DB  0x30,0xC,0x0,0xE,0x0,0xE,0x0,0xFE
	.DB  0x0,0xE,0x0,0xE,0x30,0xC,0x38,0x1C
	.DB  0x1E,0x78,0x7,0xE0,0x0,0x0,0x0,0x0
_S_222:
	.DB  0x0,0x0,0x79,0xF8,0x33,0xC,0x32,0x4
	.DB  0x36,0x6,0x36,0x6,0x36,0x6,0x3E,0x6
	.DB  0x36,0x6,0x36,0x6,0x36,0x6,0x32,0x4
	.DB  0x33,0xC,0x79,0xF8,0x0,0x0,0x0,0x0
_S_223:
	.DB  0x0,0x0,0x3,0xFE,0x6,0xC,0xC,0xC
	.DB  0xC,0xC,0xC,0xC,0x6,0xC,0x3,0xFC
	.DB  0x3,0xC,0x6,0xC,0xC,0xC,0x18,0xC
	.DB  0x30,0xC,0x78,0x1E,0x0,0x0,0x0,0x0
_Default_Parameters:
	.DB  0xF4,0x1,0xA,0x0,0x2C,0x1

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x186:
	.DB  0xF0
_0x187:
	.DB  0xE,0x1
_0x188:
	.DB  0x64
_0x189:
	.DB  0xF0
_0x18A:
	.DB  0xE,0x1
_0x18B:
	.DB  0x78
_0x18C:
	.DB  0xDC
_0x18D:
	.DB  0xF0
_0x18E:
	.DB  0xE,0x1
_0x18F:
	.DB  0xF0
_0x190:
	.DB  0x54,0x1
_0x191:
	.DB  0xF0
_0x192:
	.DB  0xE,0x1
_0x193:
	.DB  0x68,0x1
_0x194:
	.DB  0xCC,0x1
_0x195:
	.DB  0xB8,0xB
_0x196:
	.DB  0xFA
_0x197:
	.DB  0xE8,0x3
_0x1DB:
	.DB  0x32,0x0,0x32,0x0,0x32
_0x1DC:
	.DB  0x3C
_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xCC,0xC5
	.DB  0xCD,0xDE,0x0,0x20,0x20,0x2B,0x0,0x20
	.DB  0x20,0x2D,0x0,0xCF,0xC0,0xD3,0xC7,0xC0
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xCD,0xC0,0xCF,0xD0,0xDF,0xC6
	.DB  0xC5,0xCD,0xC8,0xC5,0x0,0xD4,0xC0,0xC7
	.DB  0x0,0xD2,0xCE,0xCA,0x0,0xCD,0xC0,0xCF
	.DB  0xD0,0xDF,0xC6,0xC5,0xCD,0xC8,0xC5,0x20
	.DB  0xC8,0x20,0xD2,0xCE,0xCA,0x0,0xC2,0xCE
	.DB  0xC7,0xC1,0xD3,0xC6,0xC4,0xC5,0xCD,0xC8
	.DB  0xDF,0x0,0xC4,0xC5,0xD1,0xCA,0xCE,0xCC
	.DB  0x0,0xD1,0xD2,0xC0,0xD0,0xD2,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _BTN1_Y_Begin
	.DW  _0x186*2

	.DW  0x02
	.DW  _BTN1_Y_End
	.DW  _0x187*2

	.DW  0x01
	.DW  _BTN1_X_End
	.DW  _0x188*2

	.DW  0x01
	.DW  _BTN2_Y_Begin
	.DW  _0x189*2

	.DW  0x02
	.DW  _BTN2_Y_End
	.DW  _0x18A*2

	.DW  0x01
	.DW  _BTN2_X_Begin
	.DW  _0x18B*2

	.DW  0x01
	.DW  _BTN2_X_End
	.DW  _0x18C*2

	.DW  0x01
	.DW  _BTN3_Y_Begin
	.DW  _0x18D*2

	.DW  0x02
	.DW  _BTN3_Y_End
	.DW  _0x18E*2

	.DW  0x01
	.DW  _BTN3_X_Begin
	.DW  _0x18F*2

	.DW  0x02
	.DW  _BTN3_X_End
	.DW  _0x190*2

	.DW  0x01
	.DW  _BTN4_Y_Begin
	.DW  _0x191*2

	.DW  0x02
	.DW  _BTN4_Y_End
	.DW  _0x192*2

	.DW  0x02
	.DW  _BTN4_X_Begin
	.DW  _0x193*2

	.DW  0x02
	.DW  _BTN4_X_End
	.DW  _0x194*2

	.DW  0x02
	.DW  _LEDGREEN_max
	.DW  _0x195*2

	.DW  0x01
	.DW  _LEDRED_max
	.DW  _0x196*2

	.DW  0x02
	.DW  _LEDBLUE_max
	.DW  _0x197*2

	.DW  0x06
	.DW  _0x1CA
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x1CA+6
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x1CA+12
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x1CA+18
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x1CE
	.DW  _0x0*2+6

	.DW  0x04
	.DW  _0x1CE+5
	.DW  _0x0*2+11

	.DW  0x04
	.DW  _0x1CE+9
	.DW  _0x0*2+15

	.DW  0x06
	.DW  _0x1CE+13
	.DW  _0x0*2+19

	.DW  0x05
	.DW  _ValueLast
	.DW  _0x1DB*2

	.DW  0x01
	.DW  _multiplier
	.DW  _0x1DC*2

	.DW  0x11
	.DW  _0x1F6
	.DW  _0x0*2+25

	.DW  0x11
	.DW  _0x1F6+17
	.DW  _0x0*2+25

	.DW  0x0B
	.DW  _0x1F6+34
	.DW  _0x0*2+42

	.DW  0x04
	.DW  _0x1F6+45
	.DW  _0x0*2+53

	.DW  0x04
	.DW  _0x1F6+49
	.DW  _0x0*2+57

	.DW  0x04
	.DW  _0x1F6+53
	.DW  _0x0*2+53

	.DW  0x11
	.DW  _0x1F6+57
	.DW  _0x0*2+61

	.DW  0x0C
	.DW  _0x1F6+74
	.DW  _0x0*2+78

	.DW  0x07
	.DW  _0x201
	.DW  _0x0*2+90

	.DW  0x07
	.DW  _0x201+7
	.DW  _0x0*2+90

	.DW  0x07
	.DW  _0x201+14
	.DW  _0x0*2+90

	.DW  0x07
	.DW  _0x201+21
	.DW  _0x0*2+35

	.DW  0x07
	.DW  _0x201+28
	.DW  _0x0*2+35

	.DW  0x07
	.DW  _0x201+35
	.DW  _0x0*2+35

	.DW  0x06
	.DW  _0x201+42
	.DW  _0x0*2+97

	.DW  0x06
	.DW  _0x201+48
	.DW  _0x0*2+19

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <math.h>
;#include <spi.h>
;#include <string.h>
;#include "PCF8583.h"
;unsigned char rtc_status;
;bit rtc_alarm;
;
;unsigned char rtc_read(unsigned char chip,unsigned char address)
; 0000 0006 {

	.CSEG
;unsigned char a;
;a=(chip<<1)|0xa0;
;	chip -> Y+2
;	address -> Y+1
;	a -> R17
;i2c_start();
;i2c_write(a);
;i2c_write(address);
;i2c_start();
;i2c_write(a|1);
;a=i2c_read(0);
;i2c_stop();
;return a;
;}
;
;void rtc_write(unsigned char chip, unsigned char address,unsigned char data)
;{
;i2c_start();
;	chip -> Y+2
;	address -> Y+1
;	data -> Y+0
;i2c_write((chip<<1)|0xa0);
;i2c_write(address);
;i2c_write(data);
;i2c_stop();
;}
;
;unsigned char rtc_get_status(unsigned char chip)
;{
;rtc_status=rtc_read(chip,0);
;	chip -> Y+0
;rtc_alarm=(rtc_status&2);
;return rtc_status;
;}
;
;void rtc_init(unsigned char chip, unsigned char dated_alarm)
;{
;unsigned char d;
;d=0x90;
;	chip -> Y+2
;	dated_alarm -> Y+1
;	d -> R17
;if (dated_alarm) d=0xb0;
;rtc_status=0;
;rtc_alarm=0;
;rtc_write(chip,0,0);
;rtc_write(chip,4,rtc_read(chip,4)&0x3f);
;rtc_write(chip,8,d);
;}
;
;void rtc_stop(unsigned char chip)
;{
;rtc_get_status(chip);
;	chip -> Y+0
;rtc_status|=0x80;
;rtc_write(chip,0,rtc_status);
;}
;
;void rtc_start(unsigned char chip)
;{
;rtc_get_status(chip);
;	chip -> Y+0
;rtc_status&=0x7f;
;rtc_write(chip,0,rtc_status);
;}
;
;void rtc_hold_off(unsigned char chip)
;{
;rtc_get_status(chip);
;	chip -> Y+0
;rtc_status&=0xbf;
;rtc_write(chip,0,rtc_status);
;}
;
;void rtc_hold_on(unsigned char chip)
;{
;rtc_get_status(chip);
;	chip -> Y+0
;rtc_status|=0x40;
;rtc_write(chip,0,rtc_status);
;}
;
;unsigned char rtc_read_bcd(unsigned char chip,unsigned char addr)
;{
;return bcd2bin(rtc_read(chip,addr));
;	chip -> Y+1
;	addr -> Y+0
;}
;
;void rtc_write_bcd(unsigned char chip,unsigned char addr,unsigned char data)
;{
;rtc_write(chip,addr,bin2bcd(data));
;	chip -> Y+2
;	addr -> Y+1
;	data -> Y+0
;}
;
;void rtc_write_word(unsigned char chip,unsigned char addr,unsigned data)
;{
;rtc_write(chip,addr,(unsigned char) data&0xff);
;	chip -> Y+3
;	addr -> Y+2
;	data -> Y+0
;rtc_write(chip,++addr,(unsigned char)(data>>8));
;}
;
;void rtc_write_date(unsigned char chip,unsigned char addr,unsigned char date,
;unsigned year)
;{
;rtc_write(chip,addr,bin2bcd(date)|(((unsigned char) year&3)<<6));
;	chip -> Y+4
;	addr -> Y+3
;	date -> Y+2
;	year -> Y+0
;}
;
;void rtc_get_time(unsigned char chip,unsigned char *hour,unsigned char *min,
;unsigned char *sec,unsigned char *hsec)
;{
;rtc_hold_on(chip);
;	chip -> Y+8
;	*hour -> Y+6
;	*min -> Y+4
;	*sec -> Y+2
;	*hsec -> Y+0
;*hsec=rtc_read_bcd(chip,1);
;*sec=rtc_read_bcd(chip,2);
;*min=rtc_read_bcd(chip,3);
;*hour=rtc_read_bcd(chip,4);
;rtc_hold_off(chip);
;}
;
;void rtc_set_time(unsigned char chip,unsigned char hour,unsigned char min,
;unsigned char sec,unsigned char hsec)
;{
;rtc_stop(chip);
;	chip -> Y+4
;	hour -> Y+3
;	min -> Y+2
;	sec -> Y+1
;	hsec -> Y+0
;rtc_write_bcd(chip,1,hsec);
;rtc_write_bcd(chip,2,sec);
;rtc_write_bcd(chip,3,min);
;rtc_write_bcd(chip,4,hour);
;rtc_start(chip);
;}
;
;void rtc_get_date(unsigned char chip,unsigned char *date,unsigned char *month,
;unsigned *year)
;{
;unsigned char dy;
;unsigned y1;
;rtc_hold_on(chip);
;	chip -> Y+10
;	*date -> Y+8
;	*month -> Y+6
;	*year -> Y+4
;	dy -> R17
;	y1 -> R18,R19
;dy=rtc_read(chip,5);
;*month=bcd2bin(rtc_read(chip,6)&0x1f);
;rtc_hold_off(chip);
;*date=bcd2bin(dy&0x3f);
;dy>>=6;
;y1=rtc_read(chip,0x10)|((unsigned) rtc_read(chip,0x11)<<8);
;if (((unsigned char) y1&3)!=dy) rtc_write_word(chip,0x10,++y1);
;*year=y1;
;}
;
;void rtc_set_date(unsigned char chip,unsigned char date,unsigned char month,
;unsigned year)
;{
;rtc_write_word(chip,0x10,year);
;	chip -> Y+4
;	date -> Y+3
;	month -> Y+2
;	year -> Y+0
;rtc_stop(chip);
;rtc_write_date(chip,5,date,year);
;rtc_write_bcd(chip,6,month);
;rtc_start(chip);
;}
;#include "Font16x16.c"
;flash char blank_symb[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_46[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_UP[32] =
;{
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000011, 0b11000000,
;0b00000111, 0b11100000,
;0b00000110, 0b01100000,
;0b00001100, 0b00110000,
;0b00001100, 0b00110000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b01100000, 0b00000110,
;0b01100000, 0b00000110,
;0b01111111, 0b11111110,
;0b01111111, 0b11111110,
;0b00000000, 0b00000000,
;};
;
;flash char S_DOWN[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11111110,
;0b01111111, 0b11111110,
;0b01100000, 0b00000110,
;0b01100000, 0b00000110,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00001100, 0b00110000,
;0b00001100, 0b00110000,
;0b00000110, 0b01100000,
;0b00000111, 0b11100000,
;0b00000011, 0b11000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;};
;
;// �����
;flash char S_48[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00001100, 0b00110000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00001100, 0b00110000,
;0b00000111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_49[32] =
;{
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000011, 0b10000000,
;0b00000111, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000011, 0b11000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_50[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00001100, 0b00110000,
;0b00011000, 0b00011000,
;0b00010000, 0b00001000,
;0b00000000, 0b00011000,
;0b00000000, 0b00110000,
;0b00000000, 0b01100000,
;0b00000000, 0b11000000,
;0b00000001, 0b10000000,
;0b00000011, 0b00000000,
;0b00000110, 0b00000000,
;0b00001100, 0b00011000,
;0b00011111, 0b11111000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_51[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00001000, 0b00010000,
;0b00010000, 0b00001000,
;0b00010000, 0b00001000,
;0b00000000, 0b00010000,
;0b00000000, 0b11100000,
;0b00000000, 0b00110000,
;0b00000000, 0b00011000,
;0b00000000, 0b00001000,
;0b00000000, 0b00001000,
;0b00011000, 0b00011000,
;0b00001100, 0b00110000,
;0b00000111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_52[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00110000,
;0b00000000, 0b01110000,
;0b00000000, 0b11110000,
;0b00000001, 0b10110000,
;0b00000011, 0b00110000,
;0b00000110, 0b00110000,
;0b00001100, 0b00110000,
;0b00011000, 0b00110000,
;0b00011111, 0b11111000,
;0b00000000, 0b00110000,
;0b00000000, 0b00110000,
;0b00000000, 0b00110000,
;0b00000000, 0b01111000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_53[32] =
;{
;0b00000000, 0b00000000,
;0b00001111, 0b11111000,
;0b00001111, 0b11110000,
;0b00001000, 0b00000000,
;0b00010000, 0b00000000,
;0b00010000, 0b00000000,
;0b00011111, 0b11100000,
;0b00000000, 0b00110000,
;0b00000000, 0b00011000,
;0b00000000, 0b00011000,
;0b00000000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011100, 0b00110000,
;0b00001111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_54[32] =
;{
;0b00000000, 0b00000000,
;0b00000011, 0b11100000,
;0b00000110, 0b00010000,
;0b00001100, 0b00000000,
;0b00001000, 0b00000000,
;0b00011000, 0b00000000,
;0b00011111, 0b11100000,
;0b00011100, 0b00110000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00001100, 0b00110000,
;0b00000111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_55[32] =
;{
;0b00000000, 0b00000000,
;0b00011111, 0b11111000,
;0b00010000, 0b00011000,
;0b00000000, 0b00010000,
;0b00000000, 0b00100000,
;0b00000000, 0b00100000,
;0b00000000, 0b01000000,
;0b00000000, 0b01000000,
;0b00000000, 0b10000000,
;0b00000000, 0b10000000,
;0b00000001, 0b00000000,
;0b00000001, 0b00000000,
;0b00000010, 0b00000000,
;0b00000010, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_56[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00001100, 0b00110000,
;0b00001000, 0b00010000,
;0b00001000, 0b00010000,
;0b00001100, 0b00110000,
;0b00000111, 0b11100000,
;0b00001100, 0b00110000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00001100, 0b00110000,
;0b00000111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_57[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00001100, 0b00110000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00011000, 0b00011000,
;0b00001100, 0b00111000,
;0b00000111, 0b11111000,
;0b00000000, 0b00011000,
;0b00000000, 0b00010000,
;0b00000000, 0b00100000,
;0b00000000, 0b00100000,
;0b00000000, 0b11000000,
;0b00000011, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;// ���� �������
;flash char S_32[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_33[32] =
;{
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_40[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b01100000,
;0b00000000, 0b10000000,
;0b00000001, 0b00000000,
;0b00000010, 0b00000000,
;0b00000010, 0b00000000,
;0b00000100, 0b00000000,
;0b00000100, 0b00000000,
;0b00000100, 0b00000000,
;0b00000010, 0b00000000,
;0b00000010, 0b00000000,
;0b00000001, 0b00000000,
;0b00000000, 0b10000000,
;0b00000000, 0b01100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_41[32] =
;{
;0b00000000, 0b00000000,
;0b00000110, 0b00000000,
;0b00000001, 0b00000000,
;0b00000000, 0b10000000,
;0b00000000, 0b01000000,
;0b00000000, 0b01000000,
;0b00000000, 0b00100000,
;0b00000000, 0b00100000,
;0b00000000, 0b00100000,
;0b00000000, 0b01000000,
;0b00000000, 0b01000000,
;0b00000000, 0b10000000,
;0b00000001, 0b00000000,
;0b00000110, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_47[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00001000,
;0b00000000, 0b00011000,
;0b00000000, 0b00110000,
;0b00000000, 0b01100000,
;0b00000000, 0b11000000,
;0b00000001, 0b10000000,
;0b00000011, 0b00000000,
;0b00000110, 0b00000000,
;0b00001100, 0b00000000,
;0b00011000, 0b00000000,
;0b00010000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_43[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00111111, 0b11111100,
;0b00111111, 0b11111100,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_45[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00111111, 0b11111100,
;0b00111111, 0b11111100,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_58[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_60[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00110000,
;0b00000000, 0b01100000,
;0b00000000, 0b11000000,
;0b00000001, 0b10000000,
;0b00000011, 0b00000000,
;0b00000110, 0b00000000,
;0b00001100, 0b00000000,
;0b00000110, 0b00000000,
;0b00000011, 0b00000000,
;0b00000001, 0b10000000,
;0b00000000, 0b11000000,
;0b00000000, 0b01100000,
;0b00000000, 0b00110000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_61[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00001111, 0b11110000,
;0b00001111, 0b11110000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00001111, 0b11110000,
;0b00001111, 0b11110000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_62[32] =
;{
;0b00000000, 0b00000000,
;0b00001100, 0b00000000,
;0b00000110, 0b00000000,
;0b00000011, 0b00000000,
;0b00000001, 0b10000000,
;0b00000000, 0b11000000,
;0b00000000, 0b01100000,
;0b00000000, 0b00110000,
;0b00000000, 0b01100000,
;0b00000000, 0b11000000,
;0b00000001, 0b10000000,
;0b00000011, 0b00000000,
;0b00000110, 0b00000000,
;0b00001100, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_63[32] =
;{
;0b00000000, 0b00000000,
;0b00000011, 0b11000000,
;0b00000110, 0b01100000,
;0b00001100, 0b00110000,
;0b00001100, 0b00110000,
;0b00000100, 0b00110000,
;0b00000000, 0b01100000,
;0b00000000, 0b11000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;// ������� ��������� �����
;flash char S_192[32] =
;{
;0b00000000, 0b00000000,
;0b00000000, 0b11100000,
;0b00000000, 0b11100000,
;0b00000001, 0b00100000,
;0b00000001, 0b00100000,
;0b00000010, 0b00110000,
;0b00000010, 0b00010000,
;0b00000100, 0b00010000,
;0b00000100, 0b00011000,
;0b00001111, 0b11111000,
;0b00011000, 0b00011000,
;0b00010000, 0b00001100,
;0b00110000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_193[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11111110,
;0b00110000, 0b00011110,
;0b00110000, 0b00000010,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00111111, 0b11111000,
;0b00111111, 0b11111100,
;0b00110000, 0b00001110,
;0b00110000, 0b00000110,
;0b00110000, 0b00000110,
;0b00110000, 0b00001110,
;0b00111111, 0b11111100,
;0b01111111, 0b11111000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_194[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11110000,
;0b00110000, 0b00011000,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00011000,
;0b00111111, 0b11111000,
;0b00111111, 0b11111100,
;0b00110000, 0b00001110,
;0b00110000, 0b00000110,
;0b00110000, 0b00000110,
;0b00110000, 0b00001110,
;0b00111111, 0b11111100,
;0b01111111, 0b11111000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_195[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11111110,
;0b00110000, 0b00011110,
;0b00110000, 0b00000010,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b01111000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_196[32] =
;{
;0b00000000, 0b00000000,
;0b00000011, 0b11111100,
;0b00000001, 0b00011000,
;0b00000001, 0b00011000,
;0b00000001, 0b00011000,
;0b00000001, 0b00011000,
;0b00000001, 0b00011000,
;0b00000001, 0b00011000,
;0b00000010, 0b00011000,
;0b00000100, 0b00011000,
;0b00001000, 0b00011000,
;0b00111111, 0b11111100,
;0b00111000, 0b00111100,
;0b00110000, 0b00001100,
;0b00100000, 0b00000100,
;0b00000000, 0b00000000,
;};
;
;flash char S_197[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11111100,
;0b00110000, 0b00011100,
;0b00110000, 0b00000100,
;0b00110000, 0b00000000,
;0b00110000, 0b10000000,
;0b00111111, 0b10000000,
;0b00111111, 0b10000000,
;0b00110000, 0b10000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000100,
;0b00110000, 0b00011100,
;0b01111111, 0b11111100,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_198[32] =
;{
;0b00000000, 0b00000000,
;0b01100011, 0b11000110,
;0b01010001, 0b10001010,
;0b00010001, 0b10001000,
;0b00001001, 0b10010000,
;0b00001001, 0b10010000,
;0b00000111, 0b11100000,
;0b00000111, 0b11100000,
;0b00001101, 0b10110000,
;0b00011001, 0b10011000,
;0b00010001, 0b10001000,
;0b00110001, 0b10001100,
;0b00100001, 0b10000100,
;0b01100011, 0b11000110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_199[32] =
;{
;0b00000000, 0b00000000,
;0b00001111, 0b11100000,
;0b00111000, 0b00111000,
;0b01100000, 0b00001100,
;0b00000000, 0b00000100,
;0b00000000, 0b00001100,
;0b00000011, 0b11111000,
;0b00000000, 0b00001000,
;0b00000000, 0b00000100,
;0b00000000, 0b00000110,
;0b00000000, 0b00000110,
;0b01100000, 0b00001100,
;0b00111111, 0b11111000,
;0b00001111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_200[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00011110,
;0b00110000, 0b00001100,
;0b00110000, 0b00011100,
;0b00110000, 0b00111100,
;0b00110000, 0b01101100,
;0b00110000, 0b11001100,
;0b00110001, 0b10001100,
;0b00110011, 0b00001100,
;0b00110110, 0b00001100,
;0b00111100, 0b00001100,
;0b00111000, 0b00001100,
;0b00110000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_201[32] =
;{
;0b00000011, 0b11000000,
;0b01111001, 0b10011110,
;0b00110000, 0b00001100,
;0b00110000, 0b00011100,
;0b00110000, 0b00111100,
;0b00110000, 0b01101100,
;0b00110000, 0b11001100,
;0b00110001, 0b10001100,
;0b00110011, 0b00001100,
;0b00110110, 0b00001100,
;0b00111100, 0b00001100,
;0b00111000, 0b00001100,
;0b00110000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_202[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00111100,
;0b00110000, 0b01101100,
;0b00110000, 0b11000000,
;0b00110001, 0b10000000,
;0b00110011, 0b00000000,
;0b00111111, 0b00000000,
;0b00111001, 0b10000000,
;0b00110000, 0b11000000,
;0b00110000, 0b01100000,
;0b00110000, 0b00110000,
;0b00110000, 0b00011000,
;0b00110000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_203[32] =
;{
;0b00000000, 0b00000000,
;0b00000001, 0b11111110,
;0b00000000, 0b10001100,
;0b00000000, 0b10001100,
;0b00000000, 0b10001100,
;0b00000000, 0b10001100,
;0b00000001, 0b00001100,
;0b00000001, 0b00001100,
;0b00000001, 0b00001100,
;0b00000010, 0b00001100,
;0b00000010, 0b00001100,
;0b00000100, 0b00001100,
;0b01101000, 0b00001100,
;0b01110000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_204[32] =
;{
;0b00000000, 0b00000000,
;0b01110000, 0b00001110,
;0b00111000, 0b00011100,
;0b00111000, 0b00011100,
;0b00110100, 0b00101100,
;0b00110100, 0b00101100,
;0b00110100, 0b00101100,
;0b00110010, 0b01001100,
;0b00110010, 0b01001100,
;0b00110010, 0b01001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_205[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00011110,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00111111, 0b11111100,
;0b00111111, 0b11111100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_206[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00011110, 0b01111000,
;0b00111000, 0b00011100,
;0b00110000, 0b00001100,
;0b01110000, 0b00001110,
;0b01110000, 0b00001110,
;0b01110000, 0b00001110,
;0b01110000, 0b00001110,
;0b01110000, 0b00001110,
;0b00110000, 0b00001100,
;0b00111000, 0b00011100,
;0b00011110, 0b01111000,
;0b00000111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_207[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11111110,
;0b00111111, 0b11111100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_208[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11111000,
;0b00110000, 0b00001100,
;0b00110000, 0b00000110,
;0b00110000, 0b00000110,
;0b00110000, 0b00000110,
;0b00110000, 0b00001100,
;0b00111111, 0b11111000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b01111000, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_209[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00011110, 0b01111000,
;0b00111000, 0b00011100,
;0b00110000, 0b00000100,
;0b01110000, 0b00000000,
;0b01110000, 0b00000000,
;0b01110000, 0b00000000,
;0b01110000, 0b00000000,
;0b01110000, 0b00000000,
;0b00110000, 0b00000100,
;0b00111000, 0b00011100,
;0b00011110, 0b01111000,
;0b00000111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_210[32] =
;{
;0b00000000, 0b00000000,
;0b01111111, 0b11111110,
;0b01100001, 0b10000110,
;0b01000001, 0b10000010,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000011, 0b11000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_211[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00001110,
;0b00110000, 0b00000100,
;0b00011000, 0b00000100,
;0b00001100, 0b00001000,
;0b00000110, 0b00001000,
;0b00000011, 0b00010000,
;0b00000001, 0b10010000,
;0b00000000, 0b11100000,
;0b00000000, 0b01100000,
;0b00000000, 0b01000000,
;0b00001100, 0b01000000,
;0b00001100, 0b10000000,
;0b00000111, 0b00000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_212[32] =
;{
;0b00000000, 0b00000000,
;0b00000011, 0b11000000,
;0b00000001, 0b10000000,
;0b00001111, 0b11110000,
;0b00111001, 0b10011100,
;0b01100001, 0b10000110,
;0b01000001, 0b10000010,
;0b01000001, 0b10000010,
;0b01100001, 0b10000110,
;0b00111001, 0b10011100,
;0b00001111, 0b11110000,
;0b00000001, 0b10000000,
;0b00000001, 0b10000000,
;0b00000011, 0b11000000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_213[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00011110,
;0b00110000, 0b00000100,
;0b00011000, 0b00001000,
;0b00001100, 0b00010000,
;0b00000110, 0b00100000,
;0b00000011, 0b01000000,
;0b00000001, 0b10000000,
;0b00000010, 0b11000000,
;0b00000100, 0b01100000,
;0b00001000, 0b00110000,
;0b00010000, 0b00011000,
;0b00100000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_214[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00011110,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b01111111, 0b11111110,
;0b00000000, 0b00000110,
;0b00000000, 0b00000010,
;};
;
;flash char S_215[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00011110,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00111000, 0b00001100,
;0b00011111, 0b11111100,
;0b00000000, 0b00001100,
;0b00000000, 0b00001100,
;0b00000000, 0b00001100,
;0b00000000, 0b00001100,
;0b00000000, 0b00001100,
;0b00000000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_216[32] =
;{
;0b00000000, 0b00000000,
;0b01111011, 0b11011110,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b01111111, 0b11111110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_217[32] =
;{
;0b00000000, 0b00000000,
;0b01111011, 0b11011110,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b00110001, 0b10001100,
;0b01111111, 0b11111110,
;0b00000000, 0b00000110,
;0b00000000, 0b00000010,
;};
;
;flash char S_218[32] =
;{
;0b00000000, 0b00000000,
;0b01111100, 0b00000000,
;0b01011000, 0b00000000,
;0b01011000, 0b00000000,
;0b01011000, 0b00000000,
;0b00011000, 0b00000000,
;0b00011000, 0b00000000,
;0b00011111, 0b11111000,
;0b00011000, 0b00001100,
;0b00011000, 0b00000110,
;0b00011000, 0b00000110,
;0b00011000, 0b00000110,
;0b00011000, 0b00001100,
;0b00111111, 0b11111000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_219[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00011110,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00110000, 0b00001100,
;0b00111111, 0b10001100,
;0b00110000, 0b01001100,
;0b00110000, 0b00101100,
;0b00110000, 0b00101100,
;0b00110000, 0b00101100,
;0b00110000, 0b01001100,
;0b01111111, 0b10011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_220[32] =
;{
;0b00000000, 0b00000000,
;0b01111000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00110000, 0b00000000,
;0b00111111, 0b11111000,
;0b00110000, 0b00001100,
;0b00110000, 0b00000110,
;0b00110000, 0b00000110,
;0b00110000, 0b00000110,
;0b00110000, 0b00001100,
;0b01111111, 0b11111000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_221[32] =
;{
;0b00000000, 0b00000000,
;0b00000111, 0b11100000,
;0b00011110, 0b01111000,
;0b00111000, 0b00011100,
;0b00110000, 0b00001100,
;0b00000000, 0b00001110,
;0b00000000, 0b00001110,
;0b00000000, 0b11111110,
;0b00000000, 0b00001110,
;0b00000000, 0b00001110,
;0b00110000, 0b00001100,
;0b00111000, 0b00011100,
;0b00011110, 0b01111000,
;0b00000111, 0b11100000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_222[32] =
;{
;0b00000000, 0b00000000,
;0b01111001, 0b11111000,
;0b00110011, 0b00001100,
;0b00110010, 0b00000100,
;0b00110110, 0b00000110,
;0b00110110, 0b00000110,
;0b00110110, 0b00000110,
;0b00111110, 0b00000110,
;0b00110110, 0b00000110,
;0b00110110, 0b00000110,
;0b00110110, 0b00000110,
;0b00110010, 0b00000100,
;0b00110011, 0b00001100,
;0b01111001, 0b11111000,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;flash char S_223[32] =
;{
;0b00000000, 0b00000000,
;0b00000011, 0b11111110,
;0b00000110, 0b00001100,
;0b00001100, 0b00001100,
;0b00001100, 0b00001100,
;0b00001100, 0b00001100,
;0b00000110, 0b00001100,
;0b00000011, 0b11111100,
;0b00000011, 0b00001100,
;0b00000110, 0b00001100,
;0b00001100, 0b00001100,
;0b00011000, 0b00001100,
;0b00110000, 0b00001100,
;0b01111000, 0b00011110,
;0b00000000, 0b00000000,
;0b00000000, 0b00000000,
;};
;
;
;
;#include "SSD1963.c"
;#define flipState       0x03
;#define DISP_WIDTH      480
;#define DISP_HEIGHT     272
;
;#define HDP    (DISP_WIDTH - 1)
;#define HT     900
;#define HPS    90
;#define LPS    8
;#define HPW    10
;
;#define VDP    (DISP_HEIGHT - 1)
;#define VT     300
;#define VPS    12
;#define FPS    4
;#define VPW    10
;
;#define SSD1963_SET_COLUMN_ADDRESS 0x2A
;#define SSD1963_SET_PAGE_ADDRESS 0x2B
;
;// ���� ������������ �� ������� RGB565
;// � ������ �������� ��� �� ���������
;// ������ 0bRRRRRGGGGGGBBBBB
;// 0bGGGRRRRRBBBBBGGG
;
;// 0bRRRRR GGGGGG BBBBB
;// 0b01111 011111 01111
;
;// 0bGGGRRRRRBBBBBGGG
;// 0b0010000100001000
;#define   BLACK        0x0000
;#define   NAVY         0b111100000000000
;#define   DGREEN       0x03E0
;#define   DCYAN        0x03EF
;#define   MAROON       0x7800
;#define   PURPLE       0x780F
;#define   OLIVE        0x7BE0
;#define   GREY         0xF7DE
;#define   LGRAY        0xC618
;#define   DGRAY        0b0010000100001000
;#define   BLUE         0b0000000011111000
;#define   GREEN        0b1110000000000111
;#define   CYAN         0x07FF
;#define   RED          0b0001111100000000
;#define   MAGENTA      0xF81F
;#define   YELLOW       0b1111111100000111
;#define   WHITE        0xFFFF
;
;#define  SSD1963_RS     PORTD.7
;#define  SSD1963_WR     PORTD.6
;#define  SSD1963_RD     PORTD.5
;#define  SSD1963_CS     PORTE.7
;#define  SSD1963_RESET  PORTE.5
;#define  SSD1963_PORT1  PORTA
;#define  SSD1963_PORT2  PORTC
;
;#define  BACKGROUND_COLOR 0x0000
;#define  FONT_WIDTH 16
;#define  FONT_HEIGHT 16
;
;/*flash char RotationByte[256] =
;{
;0b00000000, //0
;0b10000000, //128
;0b01000000, //64
;0b11000000, //192
;0b00100000, //32
;0b10100000, //160
;0b01100000, //96
;0b11100000, //224
;0b00010000, //16
;0b10010000, //144
;0b01010000, //80
;0b11010000, //208
;0b00110000, //48
;0b10110000, //176
;0b01110000, //112
;0b11110000, //240
;0b00001000, //8
;0b10001000, //136
;0b01001000, //72
;0b11001000, //200
;0b00101000, //40
;0b10101000, //168
;0b01101000, //104
;0b11101000, //232
;0b00011000, //24
;0b10011000, //152
;0b01011000, //88
;0b11011000, //216
;0b00111000, //56
;0b10111000, //184
;0b01111000, //120
;0b11111000, //248
;0b00000100, //4
;0b10000100, //132
;0b01000100, //68
;0b11000100, //196
;0b00100100, //36
;0b10100100, //164
;0b01100100, //100
;0b11100100, //228
;0b00010100, //20
;0b10010100, //148
;0b01010100, //84
;0b11010100, //212
;0b00110100, //52
;0b10110100, //180
;0b01110100, //116
;0b11110100, //244
;0b00001100, //12
;0b10001100, //140
;0b01001100, //76
;0b11001100, //204
;0b00101100, //44
;0b10101100, //172
;0b01101100, //108
;0b11101100, //236
;0b00011100, //28
;0b10011100, //156
;0b01011100, //92
;0b11011100, //220
;0b00111100, //60
;0b10111100, //188
;0b01111100, //124
;0b11111100, //252
;0b00000010, //2
;0b10000010, //130
;0b01000010, //66
;0b11000010, //194
;0b00100010, //34
;0b10100010, //162
;0b01100010, //98
;0b11100010, //226
;0b00010010, //18
;0b10010010, //146
;0b01010010, //82
;0b11010010, //210
;0b00110010, //50
;0b10110010, //178
;0b01110010, //114
;0b11110010, //242
;0b00001010, //10
;0b10001010, //138
;0b01001010, //74
;0b11001010, //202
;0b00101010, //42
;0b10101010, //170
;0b01101010, //106
;0b11101010, //234
;0b00011010, //26
;0b10011010, //154
;0b01011010, //90
;0b11011010, //218
;0b00111010, //58
;0b10111010, //186
;0b01111010, //122
;0b11111010, //250
;0b00000110, //6
;0b10000110, //134
;0b01000110, //70
;0b11000110, //198
;0b00100110, //38
;0b10100110, //166
;0b01100110, //102
;0b11100110, //230
;0b00010110, //22
;0b10010110, //150
;0b01010110, //86
;0b11010110, //214
;0b00110110, //54
;0b10110110, //182
;0b01110110, //118
;0b11110110, //246
;0b00001110, //14
;0b10001110, //142
;0b01001110, //78
;0b11001110, //206
;0b00101110, //46
;0b10101110, //174
;0b01101110, //110
;0b11101110, //238
;0b00011110, //30
;0b10011110, //158
;0b01011110, //94
;0b11011110, //222
;0b00111110, //62
;0b10111110, //190
;0b01111110, //126
;0b11111110, //254
;0b00000001, //1
;0b10000001, //129
;0b01000001, //65
;0b11000001, //193
;0b00100001, //33
;0b10100001, //161
;0b01100001, //97
;0b11100001, //225
;0b00010001, //17
;0b10010001, //145
;0b01010001, //81
;0b11010001, //209
;0b00110001, //49
;0b10110001, //177
;0b01110001, //113
;0b11110001, //241
;0b00001001, //9
;0b10001001, //137
;0b01001001, //73
;0b11001001, //201
;0b00101001, //41
;0b10101001, //169
;0b01101001, //105
;0b11101001, //233
;0b00011001, //25
;0b10011001, //153
;0b01011001, //89
;0b11011001, //217
;0b00111001, //57
;0b10111001, //185
;0b01111001, //121
;0b11111001, //249
;0b00000101, //5
;0b10000101, //133
;0b01000101, //69
;0b11000101, //197
;0b00100101, //37
;0b10100101, //165
;0b01100101, //101
;0b11100101, //229
;0b00010101, //21
;0b10010101, //149
;0b01010101, //85
;0b11010101, //213
;0b00110101, //53
;0b10110101, //181
;0b01110101, //117
;0b11110101, //245
;0b00001101, //13
;0b10001101, //141
;0b01001101, //77
;0b11001101, //205
;0b00101101, //45
;0b10101101, //173
;0b01101101, //109
;0b11101101, //237
;0b00011101, //29
;0b10011101, //157
;0b01011101, //93
;0b11011101, //221
;0b00111101, //61
;0b10111101, //189
;0b01111101, //125
;0b11111101, //253
;0b00000011, //3
;0b10000011, //131
;0b01000011, //67
;0b11000011, //195
;0b00100011, //35
;0b10100011, //163
;0b01100011, //99
;0b11100011, //227
;0b00010011, //19
;0b10010011, //147
;0b01010011, //83
;0b11010011, //211
;0b00110011, //51
;0b10110011, //179
;0b01110011, //115
;0b11110011, //243
;0b00001011, //11
;0b10001011, //139
;0b01001011, //75
;0b11001011, //203
;0b00101011, //43
;0b10101011, //171
;0b01101011, //107
;0b11101011, //235
;0b00011011, //27
;0b10011011, //155
;0b01011011, //91
;0b11011011, //219
;0b00111011, //59
;0b10111011, //187
;0b01111011, //123
;0b11111011, //251
;0b00000111, //7
;0b10000111, //135
;0b01000111, //71
;0b11000111, //199
;0b00100111, //39
;0b10100111, //167
;0b01100111, //103
;0b11100111, //231
;0b00010111, //23
;0b10010111, //151
;0b01010111, //87
;0b11010111, //215
;0b00110111, //55
;0b10110111, //183
;0b01110111, //119
;0b11110111, //247
;0b00001111, //15
;0b10001111, //143
;0b01001111, //79
;0b11001111, //207
;0b00101111, //47
;0b10101111, //175
;0b01101111, //111
;0b11101111, //239
;0b00011111, //31
;0b10011111, //159
;0b01011111, //95
;0b11011111, //223
;0b00111111, //63
;0b10111111, //191
;0b01111111, //127
;0b11111111, //255
;};
;*/
;unsigned char RotateByte(unsigned char Value)
; 0000 0008 {
_RotateByte:
;  //Value = RotationByte[Value];
;  Value = ((Value >> 1) & 0x55) | ((Value << 1) & 0xaa);
;	Value -> Y+0
	CALL SUBOPT_0x0
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x55)
	MOV  R26,R30
	LD   R30,Y
	LSL  R30
	ANDI R30,LOW(0xAA)
	OR   R30,R26
	ST   Y,R30
;  Value = ((Value >> 2) & 0x33) | ((Value << 2) & 0xcc);
	CALL SUBOPT_0x0
	CALL __ASRW2
	ANDI R30,LOW(0x33)
	MOV  R26,R30
	LD   R30,Y
	LSL  R30
	LSL  R30
	ANDI R30,LOW(0xCC)
	OR   R30,R26
	ST   Y,R30
;  Value = ((Value >> 4) & 0x0f) | ((Value << 4) & 0xf0);
	CALL SUBOPT_0x0
	CALL __ASRW4
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	ST   Y,R30
;  return Value;
	RJMP _0x20C0006
;}
;
;void SSD1963_Reset(void)
;{
_SSD1963_Reset:
;  SSD1963_RD = 0;
	CBI  0x12,5
;  SSD1963_RESET = 1;
	SBI  0x3,5
;  delay_ms(100);
	CALL SUBOPT_0x1
;  SSD1963_RESET = 0;
	CBI  0x3,5
;  delay_ms(100);
	CALL SUBOPT_0x1
;  SSD1963_RESET = 1;
	SBI  0x3,5
;  SSD1963_RD = 1;
	SBI  0x12,5
;  delay_ms(100);
	CALL SUBOPT_0x1
;}
	RET
;
;// ������ ������� � SSD1963
;inline void SSD1963_WriteCmd(unsigned char cmd)
;{
_SSD1963_WriteCmd:
;  SSD1963_RD = 1;
;	cmd -> Y+0
	SBI  0x12,5
;  SSD1963_RS = 0;                                                  //������ �������
	CBI  0x12,7
;  SSD1963_PORT1 = RotateByte(cmd);
	CALL SUBOPT_0x2
;  SSD1963_PORT2 = 0x00;
;  #asm("nop")
	nop
;  //delay_us(5);
;  SSD1963_CS = 0;
	CBI  0x3,7
;  SSD1963_WR = 0;
	CBI  0x12,6
;  #asm("nop")
	nop
;  //delay_us(5);
;  SSD1963_CS = 1;
	SBI  0x3,7
;  SSD1963_WR = 1;
	SBI  0x12,6
;  #asm("nop")
	nop
	RJMP _0x20C0005
;} // SSD1963_WriteCmd
;
;// ������ ������ � SSD1963
;inline void SSD1963_WriteData_b8(unsigned char data)
;{
_SSD1963_WriteData_b8:
;  SSD1963_RD = 1;
;	data -> Y+0
	SBI  0x12,5
;  SSD1963_RS = 1;                                                  //������ ������
	SBI  0x12,7
;  SSD1963_PORT1 = RotateByte(data);
	CALL SUBOPT_0x2
;  SSD1963_PORT2 = 0x00;
;  #asm("nop")
	nop
;  //delay_us(5);
;  SSD1963_CS = 0;
	CBI  0x3,7
;  SSD1963_WR = 0;
	CBI  0x12,6
;  #asm("nop")
	nop
;  //delay_us(5);
;  SSD1963_CS = 1;
	SBI  0x3,7
;  SSD1963_WR = 1;
	SBI  0x12,6
;  #asm("nop")
	nop
_0x20C0005:
;} // SSD1963_Writedata
_0x20C0006:
	ADIW R28,1
	RET
;
;// ������ ������ � SSD1963
;inline void SSD1963_WriteData_b16(unsigned int data)
;{
_SSD1963_WriteData_b16:
;  char a, b;
;  a = data;
	ST   -Y,R17
	ST   -Y,R16
;	data -> Y+2
;	a -> R17
;	b -> R16
	LDD  R17,Y+2
;  b = data >> 8;
	LDD  R16,Y+3
;  SSD1963_RD = 1;
	SBI  0x12,5
;  SSD1963_RS = 1;                                                  //������ ������
	SBI  0x12,7
;  SSD1963_PORT1 = a;
	OUT  0x1B,R17
;  SSD1963_PORT2 = b;
	OUT  0x15,R16
;  #asm("nop")
	nop
;  //delay_us(5);
;  SSD1963_CS = 0;
	CBI  0x3,7
;  SSD1963_WR = 0;
	CBI  0x12,6
;  #asm("nop")
	nop
;  //delay_us(5);
;  SSD1963_CS = 1;
	SBI  0x3,7
;  SSD1963_WR = 1;
	SBI  0x12,6
;  #asm("nop")
	nop
;} // SSD1963_Writedata
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
;// ������������� �������
;void SSD1963_Init(void)
;{
_SSD1963_Init:
;  SSD1963_Reset();
	RCALL _SSD1963_Reset
;  // Soft reset
;  SSD1963_WriteCmd(0x01); //software reset
	CALL SUBOPT_0x3
;  SSD1963_WriteCmd(0x01); //software reset
	CALL SUBOPT_0x3
;  SSD1963_WriteCmd(0x01); //software reset
	CALL SUBOPT_0x3
;  delay_ms(200); //��������
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x4
;
;  SSD1963_WriteCmd(0xE2); //PLLmultiplier, set PLL clock to 120M
	LDI  R30,LOW(226)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8(0x23); // ���������PLL(M)// N=0x36 for 6.5M, 0x23 for 10M crystal
	LDI  R30,LOW(35)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(0x02); // ��������PLL(N)
	LDI  R30,LOW(2)
	CALL SUBOPT_0x5
;  SSD1963_WriteData_b8(0x04); // ������� �� ������������� ���������� � �������� PLL
;  /*SSD1963_WriteData_b8(0x23); // ���������PLL(M)// N=0x36 for 6.5M, 0x23 for 10M crystal
;  SSD1963_WriteData_b8(0x02); // ��������PLL(N)
;  SSD1963_WriteData_b8(0x04); // ������� �� ������������� ���������� � �������� PLL*/
;  SSD1963_WriteCmd(0xE0); // ������ PLL
	LDI  R30,LOW(224)
	CALL SUBOPT_0x6
;  SSD1963_WriteData_b8(0x01); // PLL �������� � ������������ ���������� ��������� ��� ���������
;  delay_ms(1);//�������� ������� PLL
	CALL SUBOPT_0x7
;
;  SSD1963_WriteCmd(0xE0); // ������������ ������� � ����������� ���������� �� PLL
	LDI  R30,LOW(224)
	CALL SUBOPT_0x8
;  SSD1963_WriteData_b8(0x03);
;  SSD1963_WriteCmd(0x01); //software reset
	CALL SUBOPT_0x3
;  delay_ms(120); //� ����� ����� ������� 120 ������ 5
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x4
;
;  SSD1963_WriteCmd(0xE6); //��������� ������� ������������ �������
	LDI  R30,LOW(230)
	CALL SUBOPT_0x6
;  //PLL setting for PCLK, depends on resolution
;  SSD1963_WriteData_b8(0x01); //5,3��� = PLLfreqx ((�������������������+1)/2^20)
;  SSD1963_WriteData_b8(0xDA); // ��� 100��� ������ ���� 0�00D916
	LDI  R30,LOW(218)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(0x73);
	LDI  R30,LOW(115)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;
;  SSD1963_WriteCmd(0xB0); //Set LCD mode
	LDI  R30,LOW(176)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8(0x24); //24bit
	LDI  R30,LOW(36)
	CALL SUBOPT_0x9
;  SSD1963_WriteData_b8(0x00); //0x0000 � 20 - TFT �����, 40 serial RGB �����
;  SSD1963_WriteData_b8((HDP>>8)&0xFF); //���������� �� ����������� //SetHDP
	CALL SUBOPT_0xA
;  SSD1963_WriteData_b8(HDP&0xFF);
	LDI  R30,LOW(223)
	CALL SUBOPT_0xB
;  SSD1963_WriteData_b8((VDP>>8)&0xFF); // ���������� �� ��������� //SetVDP
;  SSD1963_WriteData_b8(VDP&0xFF);
	LDI  R30,LOW(15)
	CALL SUBOPT_0x9
;  SSD1963_WriteData_b8(0x00); // � ����� �������� ��������� 0�2D � ����� �� ���� ������ 36 �������
;  //00101101-G[5..3]=101
;  //G[2..0]=101-BGR
;
;  //�4 � �6 ������� ���������� �� ����������� � ��������� (����������)
;  SSD1963_WriteCmd(0xB4); //Sethorizontalperiod
	LDI  R30,LOW(180)
	CALL SUBOPT_0x8
;  SSD1963_WriteData_b8((HT>>8)&0xFF); //SetHT
;  SSD1963_WriteData_b8(HT&0xFF);
	LDI  R30,LOW(132)
	CALL SUBOPT_0x9
;  SSD1963_WriteData_b8((HPS>>8)&0XFF); //SetHPS
;  SSD1963_WriteData_b8(HPS&0xFF);
	LDI  R30,LOW(90)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(HPW); //SetHPW
	LDI  R30,LOW(10)
	CALL SUBOPT_0x9
;  SSD1963_WriteData_b8((LPS>>8)&0XFF); //SetHPS
;  SSD1963_WriteData_b8(LPS&0XFF);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x9
;  SSD1963_WriteData_b8(0x00);
;
;  SSD1963_WriteCmd(0xB6); //Set vertical period
	LDI  R30,LOW(182)
	CALL SUBOPT_0x6
;  SSD1963_WriteData_b8((VT>>8)&0xFF); //SetVT
;  SSD1963_WriteData_b8(VT&0xFF);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x9
;  SSD1963_WriteData_b8((VPS>>8)&0xFF); //SetVPS
;  SSD1963_WriteData_b8(VPS&0xFF);
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(VPW); //SetVPW
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8((FPS>>8)&0xFF); //SetFPS
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
;  SSD1963_WriteData_b8(FPS&0xFF);
;
;  //�� � �8 ������������ ������ ����� SSD1963 � ��������
;  SSD1963_WriteCmd(0xBA);
	LDI  R30,LOW(186)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8(0x0F); //GPIO[3:0]out1
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteCmd(0xB8);
	LDI  R30,LOW(184)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8(0x07); //0x07 GPIO3 = input, GPIO[2:0] = output
	LDI  R30,LOW(7)
	CALL SUBOPT_0xB
;  SSD1963_WriteData_b8(0x01); //0x01 GPIO0 normal
;
;  SSD1963_WriteCmd(0x36); //Set Address mode - rotation
	LDI  R30,LOW(54)
	CALL SUBOPT_0x8
;  SSD1963_WriteData_b8(flipState); //���0 - flipvertical ���1 - fliphorizontal
;
;  SSD1963_WriteCmd(0xBC); //��������� ������� � ��
	LDI  R30,LOW(188)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8(0x50); //��������
	LDI  R30,LOW(80)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(0x90); //�������
	LDI  R30,LOW(144)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(0x50); //����������� �����
	LDI  R30,LOW(80)
	CALL SUBOPT_0xB
;  SSD1963_WriteData_b8(0x01); //������������� (1 - ��� ���������, 0 - ����)
;
;  SSD1963_WriteCmd(0xF0); //pixel data interface
	LDI  R30,LOW(240)
	CALL SUBOPT_0x8
;  SSD1963_WriteData_b8(0x03); //03h - RGB565
;
;  delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
;
;  SSD1963_WriteCmd(0x29); //display on
	LDI  R30,LOW(41)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;
;  SSD1963_WriteCmd(0xD0); //��������� ������ ���������� �������� //Dynamic Bright Control
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8(0x0D); //����� ���������������� - �����������
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;} // SSD1963_Init
	RET
;
;void SSD1963_SetArea(unsigned int StartX, unsigned int EndX, unsigned int StartY, unsigned int EndY)
;{
_SSD1963_SetArea:
;  SSD1963_WriteCmd(SSD1963_SET_COLUMN_ADDRESS);
;	StartX -> Y+6
;	EndX -> Y+4
;	StartY -> Y+2
;	EndY -> Y+0
	LDI  R30,LOW(42)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8(StartX >> 8);
	LDD  R30,Y+7
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(StartX);
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8((EndX >> 8));
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(EndX);
	LDD  R30,Y+4
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;
;  SSD1963_WriteCmd(SSD1963_SET_PAGE_ADDRESS);
	LDI  R30,LOW(43)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_WriteData_b8((StartY >> 8));
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(StartY);
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8((EndY >> 8));
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;  SSD1963_WriteData_b8(EndY);
	LD   R30,Y
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b8
;}
	ADIW R28,8
	RET
;
;void SSD1963_ClearScreen(unsigned int color)
;{
_SSD1963_ClearScreen:
;  unsigned int x,y;
;  SSD1963_WriteCmd(0x28);
	CALL __SAVELOCR4
;	color -> Y+4
;	x -> R16,R17
;	y -> R18,R19
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  SSD1963_SetArea(0, HDP , 0, VDP);
	CALL SUBOPT_0xC
	LDI  R30,LOW(479)
	LDI  R31,HIGH(479)
	CALL SUBOPT_0xD
	LDI  R30,LOW(271)
	LDI  R31,HIGH(271)
	CALL SUBOPT_0xE
;  SSD1963_WriteCmd(0x2c);
;  x=0;
	__GETWRN 16,17,0
;  while(x <= VDP)
_0x33:
	__CPWRN 16,17,272
	BRSH _0x35
;  {
;    y=0;
	__GETWRN 18,19,0
;    while(y <= HDP)
_0x36:
	__CPWRN 18,19,480
	BRSH _0x38
;    {
;      SSD1963_WriteData_b16(color);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0xF
;      y++;
	__ADDWRN 18,19,1
;    }
	RJMP _0x36
_0x38:
;  x++;
	__ADDWRN 16,17,1
;  }
	RJMP _0x33
_0x35:
;  SSD1963_WriteCmd(0x29);
	LDI  R30,LOW(41)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;}
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;void SSD1963_PrintSymbol16(flash char Symb[32], unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
;{
_SSD1963_PrintSymbol16:
;  char i, j;
;  SSD1963_SetArea(X, X + FONT_WIDTH - 1, Y, Y + FONT_HEIGHT - 1);
	ST   -Y,R17
	ST   -Y,R16
;	X -> Y+8
;	Y -> Y+6
;	Color -> Y+4
;	BackColor -> Y+2
;	i -> R17
;	j -> R16
	CALL SUBOPT_0x10
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADIW R26,16
	SBIW R26,1
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x11
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,16
	SBIW R26,1
	ST   -Y,R27
	ST   -Y,R26
	RCALL _SSD1963_SetArea
;  SSD1963_WriteCmd(0x2c);
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _SSD1963_WriteCmd
;  for (i = 0; i < 32; i++)
	LDI  R17,LOW(0)
_0x3A:
	CPI  R17,32
	BRSH _0x3B
;  {
;    for (j = 0; j < 8; j++)
	LDI  R16,LOW(0)
_0x3D:
	CPI  R16,8
	BRSH _0x3E
;    {
;      if ((Symb[i] & (0b10000000 >> j)) > 0) SSD1963_WriteData_b16(Color);
	MOV  R30,R17
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R1,Z
	MOV  R30,R16
	LDI  R26,LOW(128)
	CALL __LSRB12
	AND  R30,R1
	CPI  R30,LOW(0x1)
	BRLO _0x3F
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x236
;      else SSD1963_WriteData_b16(BackColor);
_0x3F:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
_0x236:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SSD1963_WriteData_b16
;    }
	SUBI R16,-1
	RJMP _0x3D
_0x3E:
;  }
	SUBI R17,-1
	RJMP _0x3A
_0x3B:
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0004
;
;void SSD1963_PutChar16(char Value, unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
;{
_SSD1963_PutChar16:
;  switch(Value)
;	Value -> Y+8
;	X -> Y+6
;	Y -> Y+4
;	Color -> Y+2
;	BackColor -> Y+0
	LDD  R30,Y+8
	LDI  R31,0
;  {
;    case '0' : SSD1963_PrintSymbol16(S_48, X, Y, Color, BackColor);
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x44
	LDI  R30,LOW(_S_48*2)
	LDI  R31,HIGH(_S_48*2)
	RJMP _0x237
;    break;
;    case '1' : SSD1963_PrintSymbol16(S_49, X, Y, Color, BackColor);
_0x44:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x45
	LDI  R30,LOW(_S_49*2)
	LDI  R31,HIGH(_S_49*2)
	RJMP _0x237
;    break;
;    case '2' : SSD1963_PrintSymbol16(S_50, X, Y, Color, BackColor);
_0x45:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x46
	LDI  R30,LOW(_S_50*2)
	LDI  R31,HIGH(_S_50*2)
	RJMP _0x237
;    break;
;    case '3' : SSD1963_PrintSymbol16(S_51, X, Y, Color, BackColor);
_0x46:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x47
	LDI  R30,LOW(_S_51*2)
	LDI  R31,HIGH(_S_51*2)
	RJMP _0x237
;    break;
;    case '4' : SSD1963_PrintSymbol16(S_52, X, Y, Color, BackColor);
_0x47:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x48
	LDI  R30,LOW(_S_52*2)
	LDI  R31,HIGH(_S_52*2)
	RJMP _0x237
;    break;
;    case '5' : SSD1963_PrintSymbol16(S_53, X, Y, Color, BackColor);
_0x48:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0x49
	LDI  R30,LOW(_S_53*2)
	LDI  R31,HIGH(_S_53*2)
	RJMP _0x237
;    break;
;    case '6' : SSD1963_PrintSymbol16(S_54, X, Y, Color, BackColor);
_0x49:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0x4A
	LDI  R30,LOW(_S_54*2)
	LDI  R31,HIGH(_S_54*2)
	RJMP _0x237
;    break;
;    case '7' : SSD1963_PrintSymbol16(S_55, X, Y, Color, BackColor);
_0x4A:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0x4B
	LDI  R30,LOW(_S_55*2)
	LDI  R31,HIGH(_S_55*2)
	RJMP _0x237
;    break;
;    case '8' : SSD1963_PrintSymbol16(S_56, X, Y, Color, BackColor);
_0x4B:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x4C
	LDI  R30,LOW(_S_56*2)
	LDI  R31,HIGH(_S_56*2)
	RJMP _0x237
;    break;
;    case '9' : SSD1963_PrintSymbol16(S_57, X, Y, Color, BackColor);
_0x4C:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0x4D
	LDI  R30,LOW(_S_57*2)
	LDI  R31,HIGH(_S_57*2)
	RJMP _0x237
;    break;
;
;    case '!' : SSD1963_PrintSymbol16(S_33, X, Y, Color, BackColor);
_0x4D:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x4E
	LDI  R30,LOW(_S_33*2)
	LDI  R31,HIGH(_S_33*2)
	RJMP _0x237
;    break;
;    case '(' : SSD1963_PrintSymbol16(S_40, X, Y, Color, BackColor);
_0x4E:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x4F
	LDI  R30,LOW(_S_40*2)
	LDI  R31,HIGH(_S_40*2)
	RJMP _0x237
;    break;
;    case ')' : SSD1963_PrintSymbol16(S_41, X, Y, Color, BackColor);
_0x4F:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x50
	LDI  R30,LOW(_S_41*2)
	LDI  R31,HIGH(_S_41*2)
	RJMP _0x237
;    break;
;    case '/' : SSD1963_PrintSymbol16(S_47, X, Y, Color, BackColor);
_0x50:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0x51
	LDI  R30,LOW(_S_47*2)
	LDI  R31,HIGH(_S_47*2)
	RJMP _0x237
;    break;
;    case ':' : SSD1963_PrintSymbol16(S_58, X, Y, Color, BackColor);
_0x51:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0x52
	LDI  R30,LOW(_S_58*2)
	LDI  R31,HIGH(_S_58*2)
	RJMP _0x237
;    break;
;    case '<' : SSD1963_PrintSymbol16(S_60, X, Y, Color, BackColor);
_0x52:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0x53
	LDI  R30,LOW(_S_60*2)
	LDI  R31,HIGH(_S_60*2)
	RJMP _0x237
;    break;
;    case '=' : SSD1963_PrintSymbol16(S_61, X, Y, Color, BackColor);
_0x53:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0x54
	LDI  R30,LOW(_S_61*2)
	LDI  R31,HIGH(_S_61*2)
	RJMP _0x237
;    break;
;    case '>' : SSD1963_PrintSymbol16(S_62, X, Y, Color, BackColor);
_0x54:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0x55
	LDI  R30,LOW(_S_62*2)
	LDI  R31,HIGH(_S_62*2)
	RJMP _0x237
;    break;
;    case '?' : SSD1963_PrintSymbol16(S_63, X, Y, Color, BackColor);
_0x55:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0x56
	LDI  R30,LOW(_S_63*2)
	LDI  R31,HIGH(_S_63*2)
	RJMP _0x237
;    break;
;    case '+' : SSD1963_PrintSymbol16(S_43, X, Y, Color, BackColor);
_0x56:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0x57
	LDI  R30,LOW(_S_43*2)
	LDI  R31,HIGH(_S_43*2)
	RJMP _0x237
;    break;
;    case '-' : SSD1963_PrintSymbol16(S_45, X, Y, Color, BackColor);
_0x57:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0x58
	LDI  R30,LOW(_S_45*2)
	LDI  R31,HIGH(_S_45*2)
	RJMP _0x237
;    break;
;
;    case '�' : SSD1963_PrintSymbol16(S_192, X, Y, Color, BackColor);
_0x58:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BRNE _0x59
	LDI  R30,LOW(_S_192*2)
	LDI  R31,HIGH(_S_192*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_193, X, Y, Color, BackColor);
_0x59:
	CPI  R30,LOW(0xC1)
	LDI  R26,HIGH(0xC1)
	CPC  R31,R26
	BRNE _0x5A
	LDI  R30,LOW(_S_193*2)
	LDI  R31,HIGH(_S_193*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_194, X, Y, Color, BackColor);
_0x5A:
	CPI  R30,LOW(0xC2)
	LDI  R26,HIGH(0xC2)
	CPC  R31,R26
	BRNE _0x5B
	LDI  R30,LOW(_S_194*2)
	LDI  R31,HIGH(_S_194*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_195, X, Y, Color, BackColor);
_0x5B:
	CPI  R30,LOW(0xC3)
	LDI  R26,HIGH(0xC3)
	CPC  R31,R26
	BRNE _0x5C
	LDI  R30,LOW(_S_195*2)
	LDI  R31,HIGH(_S_195*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_196, X, Y, Color, BackColor);
_0x5C:
	CPI  R30,LOW(0xC4)
	LDI  R26,HIGH(0xC4)
	CPC  R31,R26
	BRNE _0x5D
	LDI  R30,LOW(_S_196*2)
	LDI  R31,HIGH(_S_196*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_197, X, Y, Color, BackColor);
_0x5D:
	CPI  R30,LOW(0xC5)
	LDI  R26,HIGH(0xC5)
	CPC  R31,R26
	BRNE _0x5E
	LDI  R30,LOW(_S_197*2)
	LDI  R31,HIGH(_S_197*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_198, X, Y, Color, BackColor);
_0x5E:
	CPI  R30,LOW(0xC6)
	LDI  R26,HIGH(0xC6)
	CPC  R31,R26
	BRNE _0x5F
	LDI  R30,LOW(_S_198*2)
	LDI  R31,HIGH(_S_198*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_199, X, Y, Color, BackColor);
_0x5F:
	CPI  R30,LOW(0xC7)
	LDI  R26,HIGH(0xC7)
	CPC  R31,R26
	BRNE _0x60
	LDI  R30,LOW(_S_199*2)
	LDI  R31,HIGH(_S_199*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_200, X, Y, Color, BackColor);
_0x60:
	CPI  R30,LOW(0xC8)
	LDI  R26,HIGH(0xC8)
	CPC  R31,R26
	BRNE _0x61
	LDI  R30,LOW(_S_200*2)
	LDI  R31,HIGH(_S_200*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_201, X, Y, Color, BackColor);
_0x61:
	CPI  R30,LOW(0xC9)
	LDI  R26,HIGH(0xC9)
	CPC  R31,R26
	BRNE _0x62
	LDI  R30,LOW(_S_201*2)
	LDI  R31,HIGH(_S_201*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_202, X, Y, Color, BackColor);
_0x62:
	CPI  R30,LOW(0xCA)
	LDI  R26,HIGH(0xCA)
	CPC  R31,R26
	BRNE _0x63
	LDI  R30,LOW(_S_202*2)
	LDI  R31,HIGH(_S_202*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_203, X, Y, Color, BackColor);
_0x63:
	CPI  R30,LOW(0xCB)
	LDI  R26,HIGH(0xCB)
	CPC  R31,R26
	BRNE _0x64
	LDI  R30,LOW(_S_203*2)
	LDI  R31,HIGH(_S_203*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_204, X, Y, Color, BackColor);
_0x64:
	CPI  R30,LOW(0xCC)
	LDI  R26,HIGH(0xCC)
	CPC  R31,R26
	BRNE _0x65
	LDI  R30,LOW(_S_204*2)
	LDI  R31,HIGH(_S_204*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_205, X, Y, Color, BackColor);
_0x65:
	CPI  R30,LOW(0xCD)
	LDI  R26,HIGH(0xCD)
	CPC  R31,R26
	BRNE _0x66
	LDI  R30,LOW(_S_205*2)
	LDI  R31,HIGH(_S_205*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_206, X, Y, Color, BackColor);
_0x66:
	CPI  R30,LOW(0xCE)
	LDI  R26,HIGH(0xCE)
	CPC  R31,R26
	BRNE _0x67
	LDI  R30,LOW(_S_206*2)
	LDI  R31,HIGH(_S_206*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_207, X, Y, Color, BackColor);
_0x67:
	CPI  R30,LOW(0xCF)
	LDI  R26,HIGH(0xCF)
	CPC  R31,R26
	BRNE _0x68
	LDI  R30,LOW(_S_207*2)
	LDI  R31,HIGH(_S_207*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_208, X, Y, Color, BackColor);
_0x68:
	CPI  R30,LOW(0xD0)
	LDI  R26,HIGH(0xD0)
	CPC  R31,R26
	BRNE _0x69
	LDI  R30,LOW(_S_208*2)
	LDI  R31,HIGH(_S_208*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_209, X, Y, Color, BackColor);
_0x69:
	CPI  R30,LOW(0xD1)
	LDI  R26,HIGH(0xD1)
	CPC  R31,R26
	BRNE _0x6A
	LDI  R30,LOW(_S_209*2)
	LDI  R31,HIGH(_S_209*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_210, X, Y, Color, BackColor);
_0x6A:
	CPI  R30,LOW(0xD2)
	LDI  R26,HIGH(0xD2)
	CPC  R31,R26
	BRNE _0x6B
	LDI  R30,LOW(_S_210*2)
	LDI  R31,HIGH(_S_210*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_211, X, Y, Color, BackColor);
_0x6B:
	CPI  R30,LOW(0xD3)
	LDI  R26,HIGH(0xD3)
	CPC  R31,R26
	BRNE _0x6C
	LDI  R30,LOW(_S_211*2)
	LDI  R31,HIGH(_S_211*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_212, X, Y, Color, BackColor);
_0x6C:
	CPI  R30,LOW(0xD4)
	LDI  R26,HIGH(0xD4)
	CPC  R31,R26
	BRNE _0x6D
	LDI  R30,LOW(_S_212*2)
	LDI  R31,HIGH(_S_212*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_213, X, Y, Color, BackColor);
_0x6D:
	CPI  R30,LOW(0xD5)
	LDI  R26,HIGH(0xD5)
	CPC  R31,R26
	BRNE _0x6E
	LDI  R30,LOW(_S_213*2)
	LDI  R31,HIGH(_S_213*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_214, X, Y, Color, BackColor);
_0x6E:
	CPI  R30,LOW(0xD6)
	LDI  R26,HIGH(0xD6)
	CPC  R31,R26
	BRNE _0x6F
	LDI  R30,LOW(_S_214*2)
	LDI  R31,HIGH(_S_214*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_215, X, Y, Color, BackColor);
_0x6F:
	CPI  R30,LOW(0xD7)
	LDI  R26,HIGH(0xD7)
	CPC  R31,R26
	BRNE _0x70
	LDI  R30,LOW(_S_215*2)
	LDI  R31,HIGH(_S_215*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_216, X, Y, Color, BackColor);
_0x70:
	CPI  R30,LOW(0xD8)
	LDI  R26,HIGH(0xD8)
	CPC  R31,R26
	BRNE _0x71
	LDI  R30,LOW(_S_216*2)
	LDI  R31,HIGH(_S_216*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_217, X, Y, Color, BackColor);
_0x71:
	CPI  R30,LOW(0xD9)
	LDI  R26,HIGH(0xD9)
	CPC  R31,R26
	BRNE _0x72
	LDI  R30,LOW(_S_217*2)
	LDI  R31,HIGH(_S_217*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_218, X, Y, Color, BackColor);
_0x72:
	CPI  R30,LOW(0xDA)
	LDI  R26,HIGH(0xDA)
	CPC  R31,R26
	BRNE _0x73
	LDI  R30,LOW(_S_218*2)
	LDI  R31,HIGH(_S_218*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_219, X, Y, Color, BackColor);
_0x73:
	CPI  R30,LOW(0xDB)
	LDI  R26,HIGH(0xDB)
	CPC  R31,R26
	BRNE _0x74
	LDI  R30,LOW(_S_219*2)
	LDI  R31,HIGH(_S_219*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_220, X, Y, Color, BackColor);
_0x74:
	CPI  R30,LOW(0xDC)
	LDI  R26,HIGH(0xDC)
	CPC  R31,R26
	BRNE _0x75
	LDI  R30,LOW(_S_220*2)
	LDI  R31,HIGH(_S_220*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_221, X, Y, Color, BackColor);
_0x75:
	CPI  R30,LOW(0xDD)
	LDI  R26,HIGH(0xDD)
	CPC  R31,R26
	BRNE _0x76
	LDI  R30,LOW(_S_221*2)
	LDI  R31,HIGH(_S_221*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_222, X, Y, Color, BackColor);
_0x76:
	CPI  R30,LOW(0xDE)
	LDI  R26,HIGH(0xDE)
	CPC  R31,R26
	BRNE _0x77
	LDI  R30,LOW(_S_222*2)
	LDI  R31,HIGH(_S_222*2)
	RJMP _0x237
;    break;
;    case '�' : SSD1963_PrintSymbol16(S_223, X, Y, Color, BackColor);
_0x77:
	CPI  R30,LOW(0xDF)
	LDI  R26,HIGH(0xDF)
	CPC  R31,R26
	BRNE _0x78
	LDI  R30,LOW(_S_223*2)
	LDI  R31,HIGH(_S_223*2)
	RJMP _0x237
;    break;
;
;    case '.' : SSD1963_PrintSymbol16(S_46, X, Y, Color, BackColor);
_0x78:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0x79
	LDI  R30,LOW(_S_46*2)
	LDI  R31,HIGH(_S_46*2)
	RJMP _0x237
;    break;
;    case ' ' : SSD1963_PrintSymbol16(S_32, X, Y, Color, BackColor);
_0x79:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x7A
	LDI  R30,LOW(_S_32*2)
	LDI  R31,HIGH(_S_32*2)
	RJMP _0x237
;    break;
;    case 1 : SSD1963_PrintSymbol16(S_UP, X, Y, Color, BackColor);
_0x7A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7B
	LDI  R30,LOW(_S_UP*2)
	LDI  R31,HIGH(_S_UP*2)
	RJMP _0x237
;    break;
;    case 2 : SSD1963_PrintSymbol16(S_DOWN, X, Y, Color, BackColor);
_0x7B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7C
	LDI  R30,LOW(_S_DOWN*2)
	LDI  R31,HIGH(_S_DOWN*2)
	RJMP _0x237
;    break;
;    case 3 : SSD1963_PrintSymbol16(blank_symb, X, Y, Color, BackColor);
_0x7C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x43
	LDI  R30,LOW(_blank_symb*2)
	LDI  R31,HIGH(_blank_symb*2)
_0x237:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	RCALL _SSD1963_PrintSymbol16
;    break;
;  }
_0x43:
;}
	ADIW R28,9
	RET
;
;void SSD1963_PutString16(unsigned char* string, unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
;{
_SSD1963_PutString16:
;  while (*string) {SSD1963_PutChar16(*string++, X, Y, Color, BackColor); X += FONT_WIDTH;}
;	*string -> Y+8
;	X -> Y+6
;	Y -> Y+4
;	Color -> Y+2
;	BackColor -> Y+0
_0x7E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x80
	LD   R30,X+
	STD  Y+8,R26
	STD  Y+8+1,R27
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	RCALL _SSD1963_PutChar16
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,16
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x7E
_0x80:
;}
	ADIW R28,10
	RET
;
;void SSD1963_PutValue16(unsigned int Value, unsigned int X, unsigned int Y, char N, unsigned int Color, unsigned int BackColor)
;{
;  switch(N)
;	Value -> Y+9
;	X -> Y+7
;	Y -> Y+5
;	N -> Y+4
;	Color -> Y+2
;	BackColor -> Y+0
;  {
;    case 5 :
;      SSD1963_PutChar16(Value / 10000 + 48, X, Y, Color, BackColor);
;      Value %= 10000;
;      X += FONT_WIDTH;
;    case 4 :
;      SSD1963_PutChar16(Value / 1000 + 48, X, Y, Color, BackColor);
;      Value %= 1000;
;      X += FONT_WIDTH;
;    case 3 :
;      SSD1963_PutChar16(Value / 100 + 48, X, Y, Color, BackColor);
;      Value %= 100;
;      X += FONT_WIDTH;
;    case 2 :
;      SSD1963_PutChar16(Value / 10 + 48, X, Y, Color, BackColor);
;      Value %= 10;
;      X += FONT_WIDTH;
;    case 1 :
;      SSD1963_PutChar16(Value + 48, X, Y, Color, BackColor);
;    break;
;  }
;}
;
;void SSD1963_DrawFastLine(unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Color)
;{
_SSD1963_DrawFastLine:
;  signed int j;
;  long i, k;
;  SSD1963_SetArea(StartX, StopX, StartY, StopY);
	CALL SUBOPT_0x13
;	StartX -> Y+18
;	StopX -> Y+16
;	StartY -> Y+14
;	StopY -> Y+12
;	Color -> Y+10
;	j -> R16,R17
;	i -> Y+6
;	k -> Y+2
;  SSD1963_WriteCmd(0x2c);
;  j = StopX - StartX + 1;
	CALL SUBOPT_0x14
;  if (j < 0) j *= -1;
	BRPL _0x8D
	CALL SUBOPT_0x15
;  k = StopY - StartY + 1;
_0x8D:
	CALL SUBOPT_0x16
;  if (k < 0) k *= -1;
	BRPL _0x8E
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
;  k = k * j;
_0x8E:
	CALL SUBOPT_0x19
;  for (i = 0; i < k; i++) SSD1963_WriteData_b16(Color);
_0x90:
	CALL SUBOPT_0x1A
	BRGE _0x91
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1B
	RJMP _0x90
_0x91:
	RJMP _0x20C0003
;
;void SSD1963_DrawLine (unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Color, char Width)
;{
_SSD1963_DrawLine:
;	int i, k;
;  int deltaX, deltaY, signX, signY, error, error2;
;  deltaX = (StopX - StartX);
	SBIW R28,10
	CALL __SAVELOCR6
;	StartX -> Y+25
;	StopX -> Y+23
;	StartY -> Y+21
;	StopY -> Y+19
;	Color -> Y+17
;	Width -> Y+16
;	i -> R16,R17
;	k -> R18,R19
;	deltaX -> R20,R21
;	deltaY -> Y+14
;	signX -> Y+12
;	signY -> Y+10
;	error -> Y+8
;	error2 -> Y+6
	LDD  R26,Y+25
	LDD  R27,Y+25+1
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R20,R30
;  if (deltaX < 0) deltaX *= -1;
	TST  R21
	BRPL _0x92
	MOVW R30,R20
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	MOVW R20,R30
;	deltaY = (StopY - StartY);
_0x92:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+14,R30
	STD  Y+14+1,R31
;  if (deltaY < 0) deltaY *= -1;
	LDD  R26,Y+15
	TST  R26
	BRPL _0x93
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	STD  Y+14,R30
	STD  Y+14+1,R31
;	signX = StartX < StopX ? 1 : -1;
_0x93:
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	LDD  R26,Y+25
	LDD  R27,Y+25+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x94
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x95
_0x94:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x95:
	STD  Y+12,R30
	STD  Y+12+1,R31
;	signY = StartY < StopY ? 1 : -1;
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x97
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x98
_0x97:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x98:
	STD  Y+10,R30
	STD  Y+10+1,R31
;	error = deltaX - deltaY;
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	MOVW R30,R20
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
;
;	while(1)
_0x9A:
;	{
;	  SSD1963_SetArea(StartX, StartX + Width, StartY, StartY + Width);
	LDD  R30,Y+25
	LDD  R31,Y+25+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+18
	CALL SUBOPT_0x1C
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+25
	LDD  R31,Y+25+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+22
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xE
;    SSD1963_WriteCmd(0x2c);
;    k = Width * Width;
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+16
	LDI  R31,0
	CALL __MULW12
	MOVW R18,R30
;    for (i = 0; i <= k; i++) SSD1963_WriteData_b16(Color);
	__GETWRN 16,17,0
_0x9E:
	__CPWRR 18,19,16,17
	BRLT _0x9F
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	CALL SUBOPT_0xF
	__ADDWRN 16,17,1
	RJMP _0x9E
_0x9F:
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	LDD  R26,Y+25
	LDD  R27,Y+25+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xA1
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xA2
_0xA1:
	RJMP _0xA0
_0xA2:
;		break;
	RJMP _0x9C
;
;		error2 = error * 2;
_0xA0:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LSL  R30
	ROL  R31
	STD  Y+6,R30
	STD  Y+6+1,R31
;
;		if(error2 > -deltaY)
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CALL __ANEGW1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xA3
;		{
;			error -= deltaY;
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x1D
	STD  Y+8,R30
	STD  Y+8+1,R31
;			StartX += signX;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDD  R26,Y+25
	LDD  R27,Y+25+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+25,R30
	STD  Y+25+1,R31
;		}
;
;		if(error2 < deltaX)
_0xA3:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R20
	CPC  R27,R21
	BRGE _0xA4
;		{
;			error += deltaX;
	MOVW R30,R20
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
;			StartY += signY;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+21,R30
	STD  Y+21+1,R31
;		}
;	}
_0xA4:
	RJMP _0x9A
_0x9C:
;}
	CALL __LOADLOCR6
	ADIW R28,27
	RET
;
;void SSD1963_DrawRect(unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Width, unsigned int Color)
;{
_SSD1963_DrawRect:
;  SSD1963_DrawFastLine(StartX, StopX, StartY, StartY + Width, Color);
;	StartX -> Y+10
;	StopX -> Y+8
;	StartY -> Y+6
;	StopY -> Y+4
;	Width -> Y+2
;	Color -> Y+0
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x10
	RCALL _SSD1963_DrawFastLine
;  SSD1963_DrawFastLine(StartX, StartX + Width, StartY, StopY, Color);
	CALL SUBOPT_0x11
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	RCALL _SSD1963_DrawFastLine
;  SSD1963_DrawFastLine(StartX, StopX, StopY - Width, StopY, Color);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x1D
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	RCALL _SSD1963_DrawFastLine
;  SSD1963_DrawFastLine(StopX - Width, StopX, StartY, StopY, Color);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x1D
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	RCALL _SSD1963_DrawFastLine
;}
_0x20C0004:
	ADIW R28,12
	RET
;
;void SSD1963_DrawFillRect(unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Color)
;{
_SSD1963_DrawFillRect:
;  signed int j;
;  long i, k;
;  SSD1963_SetArea(StartX, StopX, StartY, StopY);
	CALL SUBOPT_0x13
;	StartX -> Y+18
;	StopX -> Y+16
;	StartY -> Y+14
;	StopY -> Y+12
;	Color -> Y+10
;	j -> R16,R17
;	i -> Y+6
;	k -> Y+2
;  SSD1963_WriteCmd(0x2c);
;  j = StopX - StartX + 1;
	CALL SUBOPT_0x14
;  if (j < 0) j *= -1;
	BRPL _0xA5
	CALL SUBOPT_0x15
;  k = StopY - StartY + 1;
_0xA5:
	CALL SUBOPT_0x16
;  if (k < 0) k *= -1;
	BRPL _0xA6
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
;  k = k * j;
_0xA6:
	CALL SUBOPT_0x19
;  for (i = 0; i < k; i++) SSD1963_WriteData_b16(Color);
_0xA8:
	CALL SUBOPT_0x1A
	BRGE _0xA9
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1B
	RJMP _0xA8
_0xA9:
_0x20C0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,20
	RET
;
;void SSD1963_PutFloatValue16(unsigned int Value, unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
;{
;  SSD1963_PutChar16(Value / 10000 + 48, X, Y, Color, BackColor);
;	Value -> Y+8
;	X -> Y+6
;	Y -> Y+4
;	Color -> Y+2
;	BackColor -> Y+0
;  Value %= 10000;
;  X += FONT_WIDTH;
;  SSD1963_PutChar16(Value / 1000 + 48, X, Y, Color, BackColor);
;  Value %= 1000;
;  X += FONT_WIDTH;
;  SSD1963_PutChar16('.', X, Y, Color, BackColor);
;  X += FONT_WIDTH;
;  SSD1963_PutChar16(Value / 100 + 48, X, Y, Color, BackColor);
;  Value %= 100;
;  X += FONT_WIDTH;
;  SSD1963_PutChar16(Value / 10 + 48, X, Y, Color, BackColor);
;  Value %= 10;
;  X += FONT_WIDTH;
;  SSD1963_PutChar16(Value + 48, X, Y, Color, BackColor);
;}
;
;#include "TSC2046.c"
;#include <spi.h>
;#include <delay.h>
;
;#define TOUCH_CS PORTE.2
;#define TOUCH_IRQ_PORT PORTE.3
;#define TOUCH_IRQ PINE.3
;
;#define ADC_X_MIN 1300
;#define ADC_Y_MIN 2100
;#define ADC_X_K 61.458333333333333333333333333333
;#define ADC_Y_K 103.30882352941176470588235294118
;
;#define TOUCH_Calc_Max 16
;
;long tempX, tempY;
;unsigned int TOUCH_X, TOUCH_Y, TOUCH_X_LAST, TOUCH_Y_LAST;
;char i;
;
;unsigned int TSC2046_getADC_Bat(void)
; 0000 0009 {
;  unsigned int res;
;  TOUCH_CS = 0;
;	res -> R16,R17
;  delay_ms(1);
;  spi(0b10100011);
;  delay_us(100);
;  res = spi(0x00);
;  res = res << 8;
;  res += spi(0x00);
;  //res = res >> 3;
;  TOUCH_CS = 1;
;  return res;
;}
;
;unsigned int TSC2046_getADC_X(void)
;{
_TSC2046_getADC_X:
;  unsigned int res;
;  TOUCH_CS = 0;
	ST   -Y,R17
	ST   -Y,R16
;	res -> R16,R17
	CBI  0x3,2
;  delay_ms(1);
	CALL SUBOPT_0x7
;  spi(0b11010011);
	LDI  R30,LOW(211)
	CALL SUBOPT_0x1F
;  delay_us(100);
;  res = spi(0x00);
;  res = res << 8;
;  res += spi(0x00);
;  //res = res >> 3;
;  TOUCH_CS = 1;
;  return res;
	RJMP _0x20C0002
;}
;
;unsigned int TSC2046_getADC_Y(void)
;{
_TSC2046_getADC_Y:
;  unsigned int res;
;  TOUCH_CS = 0;
	ST   -Y,R17
	ST   -Y,R16
;	res -> R16,R17
	CBI  0x3,2
;  delay_ms(1);
	CALL SUBOPT_0x7
;  spi(0b10010011);
	LDI  R30,LOW(147)
	CALL SUBOPT_0x1F
;  delay_us(100);
;  res = spi(0x00);
;  res = res << 8;
;  res += spi(0x00);
;  //res = res >> 3;
;  TOUCH_CS = 1;
;  return res;
	RJMP _0x20C0002
;}
;
;void TSC2046_Stop()
;{
_TSC2046_Stop:
;  TOUCH_CS = 0;
	CBI  0x3,2
;  delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
;  spi(0b10010000);
	LDI  R30,LOW(144)
	ST   -Y,R30
	CALL _spi
;  delay_us(100);
	__DELAY_USW 400
;  spi(0x00);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
;  spi(0x00);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
;  TOUCH_CS = 1;
	SBI  0x3,2
;}
	RET
;
;unsigned int TSC2046_getX(void)
;{
_TSC2046_getX:
;  signed int res;
;  res = TSC2046_getADC_X() - ADC_X_MIN;
	ST   -Y,R17
	ST   -Y,R16
;	res -> R16,R17
	RCALL _TSC2046_getADC_X
	SUBI R30,LOW(1300)
	SBCI R31,HIGH(1300)
	MOVW R16,R30
;  if (res < 0) res = 0;
	TST  R17
	BRPL _0xBA
	__GETWRN 16,17,0
;  res = res / ADC_X_K;
_0xBA:
	CALL SUBOPT_0x20
	__GETD1N 0x4275D555
	CALL SUBOPT_0x21
;  return res;
	RJMP _0x20C0002
;}
;
;unsigned int TSC2046_getY(void)
;{
_TSC2046_getY:
;  signed int res;
;  res = TSC2046_getADC_Y() - ADC_Y_MIN;
	ST   -Y,R17
	ST   -Y,R16
;	res -> R16,R17
	RCALL _TSC2046_getADC_Y
	SUBI R30,LOW(2100)
	SBCI R31,HIGH(2100)
	MOVW R16,R30
;  if (res < 0) res = 0;
	TST  R17
	BRPL _0xBB
	__GETWRN 16,17,0
;  res = res / ADC_Y_K;
_0xBB:
	CALL SUBOPT_0x20
	__GETD1N 0x42CE9E1E
	CALL SUBOPT_0x21
;  return res;
	RJMP _0x20C0002
;}
;
;char TSC2046_GetCoordinates(void)
;{
_TSC2046_GetCoordinates:
;  char res = 0, i;
;  //TOUCH_CS = 0;
;  //TOUCH_IRQ_PORT = 0;
;  //delay_us(10);
;  //TOUCH_IRQ_PORT = 1;
;  //TOUCH_CS = 1;
;  if (TOUCH_IRQ < 1)
	ST   -Y,R17
	ST   -Y,R16
;	res -> R17
;	i -> R16
	LDI  R17,0
	LDI  R26,0
	SBIC 0x1,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRSH _0xBC
;  {
;    tempX = 0;
	CALL SUBOPT_0x22
;    tempY = 0;
;    for (i = 0; i < TOUCH_Calc_Max; i++)
	LDI  R16,LOW(0)
_0xBE:
	CPI  R16,16
	BRSH _0xBF
;    {
;      tempX += TSC2046_getX();
	CALL SUBOPT_0x23
;      tempY += TSC2046_getY();
;    }
	SUBI R16,-1
	RJMP _0xBE
_0xBF:
;    TOUCH_X = tempX / TOUCH_Calc_Max;
	CALL SUBOPT_0x24
;    TOUCH_Y = tempY / TOUCH_Calc_Max;
;    TSC2046_Stop();
;    res = 1;
	LDI  R17,LOW(1)
;  }
;  //TOUCH_IRQ_PORT = 0;
;  return res;
_0xBC:
	MOV  R30,R17
_0x20C0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
;}
;
;void TSC2046_Init(void)
;{
_TSC2046_Init:
;  TOUCH_CS = 0;
	CBI  0x3,2
;  TOUCH_IRQ_PORT = 0;
	CBI  0x3,3
;  delay_us(10);
	__DELAY_USB 53
;  TOUCH_CS = 1;
	SBI  0x3,2
;  TOUCH_IRQ_PORT = 1;
	SBI  0x3,3
;  tempX = 0;
	CALL SUBOPT_0x22
;    tempY = 0;
;    for (i = 0; i < TOUCH_Calc_Max; i++)
	CLR  R4
_0xC9:
	LDI  R30,LOW(16)
	CP   R4,R30
	BRSH _0xCA
;    {
;      tempX += TSC2046_getX();
	CALL SUBOPT_0x23
;      tempY += TSC2046_getY();
;    }
	INC  R4
	RJMP _0xC9
_0xCA:
;    TOUCH_X = tempX / TOUCH_Calc_Max;
	CALL SUBOPT_0x24
;    TOUCH_Y = tempY / TOUCH_Calc_Max;
;    TSC2046_Stop();
;}
	RET
;#include "SPI_routines.c"
;//**************************************************
;// ***** SOURCE FILE : SPI_routines.c ******
;//**************************************************
;#include "SPI_routines.h"
;
;unsigned char SPI_transmit(unsigned char data)
; 0000 000A {
;// Start transmission
;SPDR = data;
;	data -> Y+0
;
;// Wait for transmission complete
;while(!(SPSR & (1<<SPIF)));
;  data = SPDR;
;
;return(data);
;}
;
;unsigned char SPI_receive(void)
;{
;unsigned char data;
;// Wait for reception complete
;
;SPDR = 0xff;
;	data -> R17
;while(!(SPSR & (1<<SPIF)));
;  data = SPDR;
;
;// Return data register
;return data;
;}
;#include "SD_routines.c"
;//**************************************************
;// ***** SOURCE FILE : SD_routines.c ******
;//**************************************************
;#include "SPI_routines.h"
;#include "SD_routines.h"
;
;//******************************************************************
;//Function: to initialize the SD card in SPI mode
;//Arguments: none
;//return: unsigned char; will be 0 if no error,
;// otherwise the response byte will be sent
;//******************************************************************
;unsigned char SD_init(void)
; 0000 000B {
;  unsigned char i, response, retry = 0;
;
;  SD_CS_ASSERT;
;	i -> R17
;	response -> R16
;	retry -> R19
;  do
;  {
;    for(i=0;i<10;i++) SPI_transmit(0xff);
;    retry++;
;    if(retry>0xfe) return 1; //time out
;  }
;  while(response != 0x01);
;
;  SD_CS_DEASSERT;
;
;  SPI_transmit (0xff);
;  SPI_transmit (0xff);
;
;  retry = 0;
;
;  do
;  {
;    response = SD_sendCommand(SEND_OP_COND, 0); //activate card's initialization process
;    response = SD_sendCommand(SEND_OP_COND, 0); //resend command (for compatibility with some cards)
;    retry++;
;    if(retry>0xfe) return 1; //time out
;  }
;  while(response);
;
;
;  SD_sendCommand(CRC_ON_OFF, OFF); //disable CRC; deafault - CRC disabled in SPI mode
;  SD_sendCommand(SET_BLOCK_LEN, 512); //set block size to 512
;
;  return 0; //normal return
;}
;
;//******************************************************************
;//Function: to send a command to SD card
;//Arguments: unsigned char (8-bit command value)
;// & unsigned long (32-bit command argument)
;//return: unsigned char; response byte
;//******************************************************************
;unsigned char SD_sendCommand(unsigned char cmd, unsigned long arg)
;{
;unsigned char response, retry=0;
;
;
;SD_CS_ASSERT;
;	cmd -> Y+6
;	arg -> Y+2
;	response -> R17
;	retry -> R16
;
;
;SPI_transmit(cmd | 0x40); //send command, first two bits always '01'
;SPI_transmit(arg>>24);
;SPI_transmit(arg>>16);
;SPI_transmit(arg>>8);
;SPI_transmit(arg);
;SPI_transmit(0x95);
;
;
;while((response = SPI_receive()) == 0xff) //wait response
;   if(retry++ > 0xfe) break; //time out error
;
;
;SPI_receive(); //extra 8 CLK
;SD_CS_DEASSERT;
;
;
;return response; //return state
;}
;
;
;//******************************************************************
;//Function: to read a single block from SD card
;//Arguments: none
;//return: unsigned char; will be 0 if no error,
;// otherwise the response byte will be sent
;//******************************************************************
;unsigned char SD_readSingleBlock(unsigned long startBlock)
;{
;unsigned char response;
;unsigned int i, retry=0;
;
;response = SD_sendCommand(READ_SINGLE_BLOCK, startBlock<<9); //read a Block command
;	startBlock -> Y+6
;	response -> R17
;	i -> R18,R19
;	retry -> R20,R21
;//block address converted to starting address of 512 byte Block
;if(response != 0x00) //check for SD status: 0x00 - OK (No flags set)
;  return response;
;
;SD_CS_ASSERT;
;
;while(SPI_receive() != 0xfe) //wait for start block token 0xfe (0x11111110)
;  if(retry++ > 0xfffe){SD_CS_DEASSERT; return 1;} //return if time-out
;
;  for(i=0; i<512; i++) //read 512 bytes
;  buffer[i] = SPI_receive();
;SPI_receive();
;
;
;SPI_receive(); //extra 8 clock pulses
;SD_CS_DEASSERT;
;return 0;
;}
;
;//******************************************************************
;//Function: to write to a single block of SD card
;//Arguments: none
;//return: unsigned char; will be 0 if no error,
;// otherwise the response byte will be sent
;//******************************************************************
;unsigned char SD_writeSingleBlock(unsigned long startBlock)
;{
;unsigned char response;
;unsigned int i, retry=0;
;
;
;response = SD_sendCommand(WRITE_SINGLE_BLOCK, startBlock<<9); //write a Block command
;	startBlock -> Y+6
;	response -> R17
;	i -> R18,R19
;	retry -> R20,R21
;if(response != 0x00) //check for SD status: 0x00 - OK (No flags set)
;return response;
;
;
;SD_CS_ASSERT;
;
;
;SPI_transmit(0xfe);     //Send start block token 0xfe (0x11111110)
;
;
;for(i=0; i<512; i++)    //send 512 bytes data
;  SPI_transmit(buffer[i]);
;SPI_transmit(0xff);
;
;
;response = SPI_receive();
;
;
;if( (response & 0x1f) != 0x05) //response= 0xXXX0AAA1 ; AAA='010' - data accepted
;{                              //AAA='101'-data rejected due to CRC error
;  SD_CS_DEASSERT;              //AAA='110'-data rejected due to write error
;  return response;
;}
;
;
;while(!SPI_receive()) //wait for SD card to complete writing and get idle
;if(retry++ > 0xfffe){SD_CS_DEASSERT; return 1;}
;
;
;SD_CS_DEASSERT;
;SPI_transmit(0xff);   //just spend 8 clock cycle delay before reasserting the CS line
;SD_CS_ASSERT;         //re-asserting the CS line to verify if card is still busy
;
;
;while(!SPI_receive()) //wait for SD card to complete writing and get idle
;   if(retry++ > 0xfffe){SD_CS_DEASSERT; return 1;}
;SD_CS_DEASSERT;
;
;
;return 0;
;}
;#include "FAT32.c"
;//**************************************************
;// ***** SOURCE FILE : FAT32.c ******
;//**************************************************
;#include "FAT32.h"
;#include "SD_routines.h"
;
;//***************************************************************************
;//Function: to read data from boot sector of SD card, to determine important
;//parameters like bytesPerSector, sectorsPerCluster etc.
;//Arguments: none
;//return: none
;//***************************************************************************
;unsigned char getBootSectorData (void)
; 0000 000C {
;  struct BS_Structure *bpb; //mapping the buffer onto the structure
;  struct MBRinfo_Structure *mbr;
;  struct partitionInfo_Structure *partition;
;  unsigned long dataSectors;
;
;  unusedSectors = 0;
;	*bpb -> R16,R17
;	*mbr -> R18,R19
;	*partition -> R20,R21
;	dataSectors -> Y+6
;
;  SD_readSingleBlock(0);
;  bpb = (struct BS_Structure *)buffer;
;
;  if(bpb->jumpBoot[0]!=0xE9 && bpb->jumpBoot[0]!=0xEB) //check if it is boot sector
;  {
;    mbr = (struct MBRinfo_Structure *) buffer;         //if it is not boot sector, it must be MBR
;    if(mbr->signature != 0xaa55) return 1;            //if it is not even MBR then it's not FAT32
;    partition = (struct partitionInfo_Structure *)(mbr->partitionData);//first partition
;    unusedSectors = partition->firstSector; //the unused sectors, hidden to the FAT
;    SD_readSingleBlock(partition->firstSector);//read the bpb sector
;    bpb = (struct BS_Structure *)buffer;
;    if(bpb->jumpBoot[0]!=0xE9 && bpb->jumpBoot[0]!=0xEB)  return 1;
;  }
;
;  bytesPerSector      = bpb->bytesPerSector;
;  sectorPerCluster    = bpb->sectorPerCluster;
;  reservedSectorCount = bpb->reservedSectorCount;
;  rootCluster         = bpb->rootCluster;// + (sector / sectorPerCluster) +1;
;  firstDataSector     = bpb->hiddenSectors + reservedSectorCount + (bpb->numberofFATs * bpb->FATsize_F32);
;  dataSectors         = bpb->totalSectors_F32 - bpb->reservedSectorCount - ( bpb->numberofFATs * bpb->FATsize_F32);
;  totalClusters       = dataSectors / sectorPerCluster;
;
;  if((getSetFreeCluster (TOTAL_FREE, GET, 0)) > totalClusters)  //check if FSinfo free clusters count is valid
;    freeClusterCountUpdated = 0;
;  else freeClusterCountUpdated = 1;
;
;  return 0;
;}
;
;//***************************************************************************
;//Function: to calculate first sector address of any given cluster
;//Arguments: cluster number for which first sector is to be found
;//return: first sector address
;//***************************************************************************
;unsigned long getFirstSector(unsigned long clusterNumber)
;{
;  return (((clusterNumber - 2) * sectorPerCluster) + firstDataSector);
;	clusterNumber -> Y+0
;}
;
;//***************************************************************************
;//Function: get cluster entry value from FAT to find out the next cluster in the chain
;//or set new cluster entry in FAT
;//Arguments: 1. current cluster number, 2. get_set (=GET, if next cluster is to be found or = SET,
;//if next cluster is to be set 3. next cluster number, if argument#2 = SET, else 0
;//return: next cluster number, if if argument#2 = GET, else 0
;//****************************************************************************
;unsigned long getSetNextCluster (unsigned long clusterNumber,
;                                 unsigned char get_set,
;                                 unsigned long clusterEntry)
;{
;  unsigned int  FATEntryOffset;
;  unsigned long *FATEntryValue;
;  unsigned long FATEntrySector;
;  unsigned char retry = 0;
;
;  //get sector number of the cluster entry in the FAT
;  FATEntrySector = unusedSectors + reservedSectorCount + ((clusterNumber * 4) / bytesPerSector) ;
;	clusterNumber -> Y+15
;	get_set -> Y+14
;	clusterEntry -> Y+10
;	FATEntryOffset -> R16,R17
;	*FATEntryValue -> R18,R19
;	FATEntrySector -> Y+6
;	retry -> R21
;  //get the offset address in that sector number
;  FATEntryOffset = (unsigned int) ((clusterNumber * 4) % bytesPerSector);
;  //read the sector into a buffer
;  while(retry <10)
;  {
;    if(!SD_readSingleBlock(FATEntrySector)) break;
;    retry++;
;  }
;
;  //get the cluster address from the buffer
;  FATEntryValue = (unsigned long *) &buffer[FATEntryOffset];
;
;  if(get_set == GET) return ((*FATEntryValue) & 0x0fffffff);
;
;  *FATEntryValue = clusterEntry;   //for setting new value in cluster entry in FAT
;
;  SD_writeSingleBlock(FATEntrySector);
;
;  return 0;
;}
;
;//********************************************************************************************
;//Function: to get or set next free cluster or total free clusters in FSinfo sector of SD card
;//Arguments: 1.flag:TOTAL_FREE or NEXT_FREE,
;//           2.flag: GET or SET
;//           3.new FS entry, when argument2 is SET; or 0, when argument2 is GET
;//return: -next free cluster, if arg1 is NEXT_FREE & arg2 is GET
;//        -total number of free clusters, if arg1 is TOTAL_FREE & arg2 is GET
;//        -0xffffffff, if any error or if arg2 is SET
;//********************************************************************************************
;unsigned long getSetFreeCluster(unsigned char totOrNext, unsigned char get_set, unsigned long FSEntry)
;{
;  struct FSInfo_Structure *FS = (struct FSInfo_Structure *) &buffer;
;  unsigned char error;
;
;  SD_readSingleBlock(unusedSectors + 1);
;	totOrNext -> Y+9
;	get_set -> Y+8
;	FSEntry -> Y+4
;	*FS -> R16,R17
;	error -> R19
;
;  if((FS->leadSignature != 0x41615252) || (FS->structureSignature != 0x61417272) || (FS->trailSignature !=0xaa550000))
;    return 0xffffffff;
;
;
;  if(get_set == GET)
;  {
;    if(totOrNext == TOTAL_FREE) return(FS->freeClusterCount);
;    else // when totOrNext = NEXT_FREE
;    return(FS->nextFreeCluster);
;  }
;  else
;  {
;    if(totOrNext == TOTAL_FREE) FS->freeClusterCount = FSEntry;
;    else // when totOrNext = NEXT_FREE
;      FS->nextFreeCluster = FSEntry;
;    error = SD_writeSingleBlock(unusedSectors + 1); return error;   //update FSinfo
;  }
;  return 0xffffffff;
;}
;
;//***************************************************************************
;//Function: to convert normal short file name into FAT format
;//Arguments: pointer to the file name
;//return: 0-if no error, 1-if error
;//****************************************************************************
;unsigned char convertFileName (unsigned char *fileName)
;{
;  unsigned char fileNameFAT[11];
;  unsigned char j, k, dot;
;
;  for(j = 0; j < 11; j++)
;	*fileName -> Y+15
;	fileNameFAT -> Y+4
;	j -> R17
;	k -> R16
;	dot -> R19
;    if (fileName[j] == '.') dot = j;
;
;  if(dot>8) return dot;
;
;  for(k=0; k<dot; k++) //setting file name
;    fileNameFAT[k] = fileName[k];
;    fileNameFAT[k] = ' ';
;  for(k=8; k<11; k++) //setting file extention
;  {
;    if (fileName[dot] != 0)
;      fileNameFAT[k] = fileName[dot++];
;    else //filling extension trail with blanks
;      while( k < 11)
;        fileNameFAT[k++] = ' ';
;
;  for(j = 0; j < 11; j++) //converting small letters to caps
;    if ((fileNameFAT[j] >= 0x61) && (fileNameFAT[j] <= 0x7a))
;      fileNameFAT[j] -= 0x20;
;
;  for(j = 0; j < 11; j++)
;    fileName[j] = fileNameFAT[j];
;}
;
;//***************************************************************************
;//Function: to get DIR/FILE list or a single file address (cluster number) or to delete a specified file
;//Arguments: #1 - flag: GET_LIST, GET_FILE or DELETE #2 - pointer to file name (0 if arg#1 is GET_LIST)
;//return: first cluster of the file, if flag = GET_FILE
;//        print file/dir list of the root directory, if flag = GET_LIST
;//        Delete the file mentioned in arg#2, if flag = DELETE
;//****************************************************************************
;struct dir_Structure* findFiles (unsigned char flag, unsigned char *fileName)
;{
;unsigned long cluster, sector, firstSector;
;struct dir_Structure *dir;
;unsigned int i;
;unsigned char j;
;
;cluster = rootCluster; //root cluster
;	flag -> Y+20
;	*fileName -> Y+18
;	cluster -> Y+14
;	sector -> Y+10
;	firstSector -> Y+6
;	*dir -> R16,R17
;	i -> R18,R19
;	j -> R21
;
;while(1)
;{
;   firstSector = getFirstSector (cluster);
;
;   for(sector = 0; sector < sectorPerCluster; sector++)
;   {
;     SD_readSingleBlock (firstSector + sector);
;
;     for(i=0; i<bytesPerSector; i+=32)
;     {
;            dir = (struct dir_Structure *) &buffer[i];
;
;        if(dir->name[0] == EMPTY) //indicates end of the file list of the directory
;        {
;          if((flag == GET_FILE) || (flag == DELETE))
;          //transmitString("File does not exist!");
;          return 0;
;        }
;
;        else if((dir->name[0] != DELETED) && (dir->attrib != ATTR_LONG_NAME))
;        {
;          if((flag == GET_FILE) || (flag == DELETE))
;          {
;            for(j=0; j<11; j++)
;              if(dir->name[j] != fileName[j]) break;
;            if(j == 11)
;            {
;              if(flag == GET_FILE)
;              return (dir);
;            }
;          }
;       }
;     }
;   }
;   cluster = (getSetNextCluster (cluster, GET, 0));
;   if(cluster > 0x0ffffff6) return 0;
;   if(cluster == 0)
;   {
;   //transmitString("Error in getting cluster");
;   return 0;}
; }
;return 0;
;}
;
;#define M_PI 3.14159265
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0015 #endasm
;#include <i2c.h>
;
;
;#define sinf sin
;unsigned int k;
;unsigned C_H, C_L;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 240
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 004F {
_usart0_rx_isr:
	CALL SUBOPT_0x25
; 0000 0050 char status,data;
; 0000 0051 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0052 data=UDR0;
	IN   R16,12
; 0000 0053 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x160
; 0000 0054    {
; 0000 0055    rx_buffer0[rx_wr_index0++]=data;
	LDS  R30,_rx_wr_index0
	SUBI R30,-LOW(1)
	STS  _rx_wr_index0,R30
	CALL SUBOPT_0x26
	ST   Z,R16
; 0000 0056 #if RX_BUFFER_SIZE0 == 256
; 0000 0057    // special case for receiver buffer size=256
; 0000 0058    if (++rx_counter0 == 0)
; 0000 0059       {
; 0000 005A #else
; 0000 005B    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDS  R26,_rx_wr_index0
	CPI  R26,LOW(0xF0)
	BRNE _0x161
	LDI  R30,LOW(0)
	STS  _rx_wr_index0,R30
; 0000 005C    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x161:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0xF0)
	BRNE _0x162
; 0000 005D       {
; 0000 005E       rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 005F #endif
; 0000 0060       rx_buffer_overflow0=1;
	SET
	BLD  R2,1
; 0000 0061       }
; 0000 0062    }
_0x162:
; 0000 0063 }
_0x160:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x23F
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar0(void)
; 0000 006A {
_getchar0:
; 0000 006B char data;
; 0000 006C while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x163:
	LDS  R30,_rx_counter0
	CPI  R30,0
	BREQ _0x163
; 0000 006D data=rx_buffer0[rx_rd_index0++];
	LDS  R30,_rx_rd_index0
	SUBI R30,-LOW(1)
	STS  _rx_rd_index0,R30
	CALL SUBOPT_0x26
	LD   R17,Z
; 0000 006E #if RX_BUFFER_SIZE0 != 256
; 0000 006F if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDS  R26,_rx_rd_index0
	CPI  R26,LOW(0xF0)
	BRNE _0x166
	LDI  R30,LOW(0)
	STS  _rx_rd_index0,R30
; 0000 0070 #endif
; 0000 0071 #asm("cli")
_0x166:
	cli
; 0000 0072 --rx_counter0;
	LDS  R30,_rx_counter0
	SUBI R30,LOW(1)
	STS  _rx_counter0,R30
; 0000 0073 #asm("sei")
	sei
; 0000 0074 return data;
	RJMP _0x20C0001
; 0000 0075 }
;#pragma used-
;#endif
;
;void getclear0(void)
; 0000 007A {
_getclear0:
; 0000 007B while (rx_counter0 > 0)
_0x167:
	LDS  R26,_rx_counter0
	CPI  R26,LOW(0x1)
	BRLO _0x169
; 0000 007C {
; 0000 007D    rx_rd_index0++;
	LDS  R30,_rx_rd_index0
	SUBI R30,-LOW(1)
	STS  _rx_rd_index0,R30
; 0000 007E    #if RX_BUFFER_SIZE0 != 256
; 0000 007F    if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDS  R26,_rx_rd_index0
	CPI  R26,LOW(0xF0)
	BRNE _0x16A
	LDI  R30,LOW(0)
	STS  _rx_rd_index0,R30
; 0000 0080    #endif
; 0000 0081    #asm("cli")
_0x16A:
	cli
; 0000 0082    --rx_counter0;
	LDS  R30,_rx_counter0
	SUBI R30,LOW(1)
	STS  _rx_counter0,R30
; 0000 0083    #asm("sei")
	sei
; 0000 0084 }
	RJMP _0x167
_0x169:
; 0000 0085 }
	RET
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0093 {
_usart0_tx_isr:
	CALL SUBOPT_0x25
; 0000 0094 if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x16B
; 0000 0095    {
; 0000 0096    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 0097    UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	CALL SUBOPT_0x27
	LD   R30,Z
	OUT  0xC,R30
; 0000 0098 #if TX_BUFFER_SIZE0 != 256
; 0000 0099    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x8)
	BRNE _0x16C
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 009A #endif
; 0000 009B    }
_0x16C:
; 0000 009C }
_0x16B:
	RJMP _0x23F
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar0(char c)
; 0000 00A3 {
_putchar0:
; 0000 00A4 while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0x16D:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x8)
	BREQ _0x16D
; 0000 00A5 #asm("cli")
	cli
; 0000 00A6 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x171
	SBIC 0xB,5
	RJMP _0x170
_0x171:
; 0000 00A7    {
; 0000 00A8    tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	CALL SUBOPT_0x27
	LD   R26,Y
	STD  Z+0,R26
; 0000 00A9 #if TX_BUFFER_SIZE0 != 256
; 0000 00AA    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDS  R26,_tx_wr_index0
	CPI  R26,LOW(0x8)
	BRNE _0x173
	LDI  R30,LOW(0)
	STS  _tx_wr_index0,R30
; 0000 00AB #endif
; 0000 00AC    ++tx_counter0;
_0x173:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00AD    }
; 0000 00AE else
	RJMP _0x174
_0x170:
; 0000 00AF    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00B0 #asm("sei")
_0x174:
	sei
; 0000 00B1 }
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 32
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
;#else
;unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
;#endif
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 00C4 {
_usart1_rx_isr:
	CALL SUBOPT_0x25
; 0000 00C5 char status,data;
; 0000 00C6 status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 00C7 data=UDR1;
	LDS  R16,156
; 0000 00C8 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x175
; 0000 00C9    {
; 0000 00CA    rx_buffer1[rx_wr_index1++]=data;
	LDS  R30,_rx_wr_index1
	SUBI R30,-LOW(1)
	STS  _rx_wr_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 00CB #if RX_BUFFER_SIZE1 == 256
; 0000 00CC    // special case for receiver buffer size=256
; 0000 00CD    if (++rx_counter1 == 0)
; 0000 00CE       {
; 0000 00CF #else
; 0000 00D0    if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDS  R26,_rx_wr_index1
	CPI  R26,LOW(0x20)
	BRNE _0x176
	LDI  R30,LOW(0)
	STS  _rx_wr_index1,R30
; 0000 00D1    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x176:
	LDS  R26,_rx_counter1
	SUBI R26,-LOW(1)
	STS  _rx_counter1,R26
	CPI  R26,LOW(0x20)
	BRNE _0x177
; 0000 00D2       {
; 0000 00D3       rx_counter1=0;
	LDI  R30,LOW(0)
	STS  _rx_counter1,R30
; 0000 00D4 #endif
; 0000 00D5       rx_buffer_overflow1=1;
	SET
	BLD  R2,2
; 0000 00D6       }
; 0000 00D7    }
_0x177:
; 0000 00D8 }
_0x175:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x23F
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 00DD {
; 0000 00DE char data;
; 0000 00DF while (rx_counter1==0);
;	data -> R17
; 0000 00E0 data=rx_buffer1[rx_rd_index1++];
; 0000 00E1 #if RX_BUFFER_SIZE1 != 256
; 0000 00E2 if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 00E3 #endif
; 0000 00E4 #asm("cli")
; 0000 00E5 --rx_counter1;
; 0000 00E6 #asm("sei")
; 0000 00E7 return data;
; 0000 00E8 }
;#pragma used-
;// USART1 Transmitter buffer
;#define TX_BUFFER_SIZE1 128
;char tx_buffer1[TX_BUFFER_SIZE1];
;
;#if TX_BUFFER_SIZE1 <= 256
;unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
;#else
;unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
;#endif
;
;// USART1 Transmitter interrupt service routine
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0000 00F6 {
_usart1_tx_isr:
	CALL SUBOPT_0x25
; 0000 00F7 if (tx_counter1)
	LDS  R30,_tx_counter1
	CPI  R30,0
	BREQ _0x17C
; 0000 00F8    {
; 0000 00F9    --tx_counter1;
	SUBI R30,LOW(1)
	STS  _tx_counter1,R30
; 0000 00FA    UDR1=tx_buffer1[tx_rd_index1++];
	LDS  R30,_tx_rd_index1
	SUBI R30,-LOW(1)
	STS  _tx_rd_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R30,Z
	STS  156,R30
; 0000 00FB #if TX_BUFFER_SIZE1 != 256
; 0000 00FC    if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
	LDS  R26,_tx_rd_index1
	CPI  R26,LOW(0x80)
	BRNE _0x17D
	LDI  R30,LOW(0)
	STS  _tx_rd_index1,R30
; 0000 00FD #endif
; 0000 00FE    }
_0x17D:
; 0000 00FF }
_0x17C:
_0x23F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Write a character to the USART1 Transmitter buffer
;#pragma used+
;void putchar1(char c)
; 0000 0104 {
; 0000 0105 while (tx_counter1 == TX_BUFFER_SIZE1);
;	c -> Y+0
; 0000 0106 #asm("cli")
; 0000 0107 if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
; 0000 0108    {
; 0000 0109    tx_buffer1[tx_wr_index1++]=c;
; 0000 010A #if TX_BUFFER_SIZE1 != 256
; 0000 010B    if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
; 0000 010C #endif
; 0000 010D    ++tx_counter1;
; 0000 010E    }
; 0000 010F else
; 0000 0110    UDR1=c;
; 0000 0111 #asm("sei")
; 0000 0112 }
;#pragma used-
;
;
;
;#define BTN_StartX 0
;#define BTN_StartY 240
;#define BTN_Width 100
;#define BTN_Height 30
;#define BTN_Between 20
;
;unsigned int BTN1_Y_Begin = BTN_StartY;

	.DSEG
;unsigned int BTN1_Y_End = BTN_StartY + BTN_Height;
;unsigned int BTN1_X_Begin = BTN_StartX;
;unsigned int BTN1_X_End = BTN_StartX + BTN_Width;
;
;unsigned int BTN2_Y_Begin = BTN_StartY;
;unsigned int BTN2_Y_End = BTN_StartY + BTN_Height;
;unsigned int BTN2_X_Begin = BTN_StartX + BTN_Width + BTN_Between;
;unsigned int BTN2_X_End = BTN_StartX + (BTN_Width * 2) + BTN_Between;
;
;unsigned int BTN3_Y_Begin = BTN_StartY;
;unsigned int BTN3_Y_End = BTN_StartY + BTN_Height;
;unsigned int BTN3_X_Begin = BTN_StartX + (BTN_Width * 2) + (BTN_Between * 2);
;unsigned int BTN3_X_End = BTN_StartX + (BTN_Width * 3) + (BTN_Between * 2);
;
;unsigned int BTN4_Y_Begin = BTN_StartY;
;unsigned int BTN4_Y_End = BTN_StartY + BTN_Height;
;unsigned int BTN4_X_Begin = BTN_StartX + (BTN_Width * 3) + (BTN_Between * 3);
;unsigned int BTN4_X_End = BTN_StartX + (BTN_Width * 4) + (BTN_Between * 3);
;
;volatile char Button_Pressed;
;
;#define BACKLIGHT 6
;#define LEDGREEN 3
;#define LEDRED 4
;#define LEDBLUE 5
;
;volatile char Hour, Minute, Seconds, mSeconds, Day, Month;
;volatile unsigned int Year;
;
;#define DateTime_X 300
;#define DateTime_Y 256
;
;volatile unsigned int mSec;
;
;char SD_Ready;
;unsigned char error, FAT32_active;
;volatile long cluster, firstSector, nextSector;
;volatile unsigned char buffer[512];
;volatile long firstDataSector, rootCluster, totalClusters, byteCounter, fileSize;
;volatile unsigned int bytesPerSector, sectorPerCluster, reservedSectorCount;
;
;volatile unsigned int LEDGREEN_mSec, LEDRED_mSec, LEDBLUE_mSec, LEDGREEN_max = 3000, LEDRED_max = 250, LEDBLUE_max = 1000;
;
;#define Pulse_X_Min 270
;#define Pulse_X_Max 430
;#define Pulse_Y_Min 0
;#define Pulse_Y_Max 48
;volatile unsigned int Pulse_X, Pulse_Y_Last, Pulse_mSec, Pulse_Value, Pulse_Counter, Pulse_ScreenValue;
;volatile char Pulse_Flag, Pulse_ScreenFlag;
;
;#define Pulse_Value_X 430
;#define Pulse_Value_Y 0
;
;#define Pulse_Enable PORTB.0
;
;#define Cardio_X_Min 0
;#define Cardio_X_Max 480
;#define Cardio_Y_Min 50
;#define Cardio_Y_Max 232
;volatile unsigned int Cardio_X, Cardio_Y_Last, Cardio_mSec, Cardio_Value, Cardio_Counter;
;volatile float Cardio_Divider;
;volatile int CardioMassive[128], CardioMassive_Counter;
;
;// 0 - ������ �������������
;// 1 - ����� ���� �������������
;// 2 - ������ ������������� ������
;eeprom unsigned int WorkParameters[3] = {500, 10, 300};
;flash unsigned int Default_Parameters[3] = {500, 10, 300};
;eeprom char EEPROM_FLAG;
;char Parameter_Counter;
;
;// ������� ��������� - ��� ����� � ������
;// ����� ��������� - ������ ����� �������
;// ������� ��������� - ���������� ������
;
;volatile char Alarm, Battery_Discharged, State;
;
;#define Battery_Width 24
;#define Battery_Height 50
;#define Battery_X 0
;#define Battery_Y 0
;
;#define RS485 PORTD.4
;
;#define ScanLine_Length 25
;unsigned int ScanLine_X;
;
;volatile unsigned int Refresh_mSec, Battery_Value, ADC0, ADC1, ADC2, Sleep_mSec;
;volatile long longADC;
;unsigned int Alarm_mSec;
;
;#define Address_Slave 'G'
;
;void SwitchPORTF(char Number, char Value)
; 0000 017C {

	.CSEG
_SwitchPORTF:
; 0000 017D   switch(Value)
;	Number -> Y+1
;	Value -> Y+0
	CALL SUBOPT_0x0
; 0000 017E   {
; 0000 017F     case 0 :
	SBIW R30,0
	BRNE _0x19B
; 0000 0180       PORTF &= ~(0b00000001 << Number);
	CALL SUBOPT_0x28
	COM  R30
	AND  R30,R1
	RJMP _0x239
; 0000 0181     break;
; 0000 0182     case 1 :
_0x19B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x19A
; 0000 0183       PORTF |= 0b00000001 << Number;
	CALL SUBOPT_0x28
	OR   R30,R1
_0x239:
	MOV  R26,R22
	ST   X,R30
; 0000 0184     break;
; 0000 0185   }
_0x19A:
; 0000 0186 }
	ADIW R28,2
	RET
;
;unsigned int WaitADC_mSec;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 018C {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 018D   TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 018E   mSec++;
	LDI  R26,LOW(_mSec)
	LDI  R27,HIGH(_mSec)
	CALL SUBOPT_0x29
; 0000 018F   WaitADC_mSec++;
	LDI  R26,LOW(_WaitADC_mSec)
	LDI  R27,HIGH(_WaitADC_mSec)
	CALL SUBOPT_0x29
; 0000 0190   Pulse_mSec++;
	LDI  R26,LOW(_Pulse_mSec)
	LDI  R27,HIGH(_Pulse_mSec)
	CALL SUBOPT_0x29
; 0000 0191   Refresh_mSec++;
	LDI  R26,LOW(_Refresh_mSec)
	LDI  R27,HIGH(_Refresh_mSec)
	CALL SUBOPT_0x29
; 0000 0192   Sleep_mSec++;
	LDI  R26,LOW(_Sleep_mSec)
	LDI  R27,HIGH(_Sleep_mSec)
	CALL SUBOPT_0x29
; 0000 0193   Alarm_mSec++;
	LDI  R26,LOW(_Alarm_mSec)
	LDI  R27,HIGH(_Alarm_mSec)
	CALL SUBOPT_0x29
; 0000 0194   if (Alarm < 1)
	LDS  R26,_Alarm
	CPI  R26,LOW(0x1)
	BRLO PC+3
	JMP _0x19D
; 0000 0195   {
; 0000 0196     if (Battery_Discharged < 1)
	LDS  R26,_Battery_Discharged
	CPI  R26,LOW(0x1)
	BRSH _0x19E
; 0000 0197     {
; 0000 0198       SwitchPORTF(LEDRED, 1);
	CALL SUBOPT_0x2A
; 0000 0199       SwitchPORTF(LEDBLUE, 1);
	CALL SUBOPT_0x2B
; 0000 019A       LEDGREEN_mSec++;
	LDI  R26,LOW(_LEDGREEN_mSec)
	LDI  R27,HIGH(_LEDGREEN_mSec)
	CALL SUBOPT_0x29
; 0000 019B       if (LEDGREEN_mSec > 30) SwitchPORTF(LEDGREEN, 1);
	LDS  R26,_LEDGREEN_mSec
	LDS  R27,_LEDGREEN_mSec+1
	SBIW R26,31
	BRLO _0x19F
	CALL SUBOPT_0x2C
; 0000 019C       if (LEDGREEN_mSec > LEDGREEN_max) {LEDGREEN_mSec = 0; SwitchPORTF(LEDGREEN, 0);}
_0x19F:
	LDS  R30,_LEDGREEN_max
	LDS  R31,_LEDGREEN_max+1
	LDS  R26,_LEDGREEN_mSec
	LDS  R27,_LEDGREEN_mSec+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x1A0
	LDI  R30,LOW(0)
	STS  _LEDGREEN_mSec,R30
	STS  _LEDGREEN_mSec+1,R30
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2D
; 0000 019D     }
_0x1A0:
; 0000 019E     else
	RJMP _0x1A1
_0x19E:
; 0000 019F     {
; 0000 01A0       SwitchPORTF(LEDGREEN, 1);
	CALL SUBOPT_0x2C
; 0000 01A1       SwitchPORTF(LEDRED, 1);
	CALL SUBOPT_0x2A
; 0000 01A2       LEDBLUE_mSec++;
	LDI  R26,LOW(_LEDBLUE_mSec)
	LDI  R27,HIGH(_LEDBLUE_mSec)
	CALL SUBOPT_0x29
; 0000 01A3       if (LEDBLUE_mSec > 30) SwitchPORTF(LEDBLUE, 1);
	LDS  R26,_LEDBLUE_mSec
	LDS  R27,_LEDBLUE_mSec+1
	SBIW R26,31
	BRLO _0x1A2
	CALL SUBOPT_0x2B
; 0000 01A4       if (LEDBLUE_mSec > LEDBLUE_max) {LEDBLUE_mSec = 0; SwitchPORTF(LEDBLUE, 0);}
_0x1A2:
	LDS  R30,_LEDBLUE_max
	LDS  R31,_LEDBLUE_max+1
	LDS  R26,_LEDBLUE_mSec
	LDS  R27,_LEDBLUE_mSec+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x1A3
	LDI  R30,LOW(0)
	STS  _LEDBLUE_mSec,R30
	STS  _LEDBLUE_mSec+1,R30
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2D
; 0000 01A5     }
_0x1A3:
_0x1A1:
; 0000 01A6   }
; 0000 01A7   else
	RJMP _0x1A4
_0x19D:
; 0000 01A8   {
; 0000 01A9     SwitchPORTF(LEDGREEN, 1);
	CALL SUBOPT_0x2C
; 0000 01AA     SwitchPORTF(LEDBLUE, 1);
	CALL SUBOPT_0x2B
; 0000 01AB     LEDRED_mSec++;
	LDI  R26,LOW(_LEDRED_mSec)
	LDI  R27,HIGH(_LEDRED_mSec)
	CALL SUBOPT_0x29
; 0000 01AC     if (LEDRED_mSec > 30) SwitchPORTF(LEDRED, 1);
	LDS  R26,_LEDRED_mSec
	LDS  R27,_LEDRED_mSec+1
	SBIW R26,31
	BRLO _0x1A5
	CALL SUBOPT_0x2A
; 0000 01AD     if (LEDRED_mSec > LEDRED_max) {LEDRED_mSec = 0; SwitchPORTF(LEDRED, 0);}
_0x1A5:
	LDS  R30,_LEDRED_max
	LDS  R31,_LEDRED_max+1
	LDS  R26,_LEDRED_mSec
	LDS  R27,_LEDRED_mSec+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x1A6
	LDI  R30,LOW(0)
	STS  _LEDRED_mSec,R30
	STS  _LEDRED_mSec+1,R30
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2D
; 0000 01AE   }
_0x1A6:
_0x1A4:
; 0000 01AF }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 01B5 {
; 0000 01B6 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 01B7 // Delay needed for the stabilization of the ADC input voltage
; 0000 01B8 delay_us(10);
; 0000 01B9 // Start the AD conversion
; 0000 01BA ADCSRA|=0x40;
; 0000 01BB // Wait for the AD conversion to complete
; 0000 01BC while ((ADCSRA & 0x10)==0);
; 0000 01BD ADCSRA|=0x10;
; 0000 01BE return ADCW;
; 0000 01BF }
;
;char SDCardInit(void)
; 0000 01C2 {
; 0000 01C3   delay_ms(50);
; 0000 01C4   if (SD_init() == 1)
; 0000 01C5   {
; 0000 01C6     SD_Ready = 0;
; 0000 01C7     //PutString(SDAbsent, 199);
; 0000 01C8   }
; 0000 01C9   else
; 0000 01CA   {
; 0000 01CB     SD_Ready = 1;
; 0000 01CC     //PutString(SDReady, 99);
; 0000 01CD     //Minute_mSec = 0;
; 0000 01CE     //while (Minute_mSec < 999)
; 0000 01CF     //{
; 0000 01D0 //      PutAntAnimation(49); // �������� ��������
; 0000 01D1 //      RefreshLEDDisplay();
; 0000 01D2     //}
; 0000 01D3   }
; 0000 01D4   delay_ms(1);
; 0000 01D5 
; 0000 01D6   FAT32_active = 1;
; 0000 01D7   error = getBootSectorData (); //read boot sector and keep necessary data in global variables
; 0000 01D8   if(error)
; 0000 01D9   {
; 0000 01DA //    PutString(SDnoFAT32, 199); // FAT32 incompatible drive
; 0000 01DB     FAT32_active = 0;
; 0000 01DC     SD_Ready = 0;
; 0000 01DD   }
; 0000 01DE   return SD_Ready;
; 0000 01DF }
;
;char GetButton(void)
; 0000 01E2 {
_GetButton:
; 0000 01E3   char res = 0;
; 0000 01E4   if (TSC2046_GetCoordinates())
	ST   -Y,R17
;	res -> R17
	LDI  R17,0
	RCALL _TSC2046_GetCoordinates
	CPI  R30,0
	BRNE PC+3
	JMP _0x1AD
; 0000 01E5   {
; 0000 01E6     if ((TOUCH_X > BTN1_X_Begin) && (TOUCH_X < BTN1_X_End)) // ���� X ������ ��������� ���������
	CALL SUBOPT_0x2E
	CP   R30,R6
	CPC  R31,R7
	BRSH _0x1AF
	CALL SUBOPT_0x2F
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x1B0
_0x1AF:
	RJMP _0x1AE
_0x1B0:
; 0000 01E7     {
; 0000 01E8       if ((TOUCH_Y > BTN1_Y_Begin) && (TOUCH_Y < BTN1_Y_End)) res = 1;
	CALL SUBOPT_0x30
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1B2
	CALL SUBOPT_0x31
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x1B3
_0x1B2:
	RJMP _0x1B1
_0x1B3:
	LDI  R17,LOW(1)
; 0000 01E9     }
_0x1B1:
; 0000 01EA     if ((TOUCH_X > BTN2_X_Begin) && (TOUCH_X < BTN2_X_End)) // ���� X ������ ��������� ���������
_0x1AE:
	CALL SUBOPT_0x32
	CP   R30,R6
	CPC  R31,R7
	BRSH _0x1B5
	CALL SUBOPT_0x33
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x1B6
_0x1B5:
	RJMP _0x1B4
_0x1B6:
; 0000 01EB     {
; 0000 01EC       if ((TOUCH_Y > BTN2_Y_Begin) && (TOUCH_Y < BTN2_Y_End)) res = 2;
	CALL SUBOPT_0x34
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1B8
	CALL SUBOPT_0x35
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x1B9
_0x1B8:
	RJMP _0x1B7
_0x1B9:
	LDI  R17,LOW(2)
; 0000 01ED     }
_0x1B7:
; 0000 01EE     if ((TOUCH_X > BTN3_X_Begin) && (TOUCH_X < BTN3_X_End)) // ���� X ������ ��������� ���������
_0x1B4:
	CALL SUBOPT_0x36
	CP   R30,R6
	CPC  R31,R7
	BRSH _0x1BB
	CALL SUBOPT_0x37
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x1BC
_0x1BB:
	RJMP _0x1BA
_0x1BC:
; 0000 01EF     {
; 0000 01F0       if ((TOUCH_Y > BTN3_Y_Begin) && (TOUCH_Y < BTN3_Y_End)) res = 3;
	CALL SUBOPT_0x38
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1BE
	CALL SUBOPT_0x39
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x1BF
_0x1BE:
	RJMP _0x1BD
_0x1BF:
	LDI  R17,LOW(3)
; 0000 01F1     }
_0x1BD:
; 0000 01F2     if ((TOUCH_X > BTN4_X_Begin) && (TOUCH_X < BTN4_X_End)) // ���� X ������ ��������� ���������
_0x1BA:
	CALL SUBOPT_0x3A
	CP   R30,R6
	CPC  R31,R7
	BRSH _0x1C1
	CALL SUBOPT_0x3B
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x1C2
_0x1C1:
	RJMP _0x1C0
_0x1C2:
; 0000 01F3     {
; 0000 01F4       if ((TOUCH_Y > BTN4_Y_Begin) && (TOUCH_Y < BTN4_Y_End)) res = 4;
	CALL SUBOPT_0x3C
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1C4
	CALL SUBOPT_0x3D
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x1C5
_0x1C4:
	RJMP _0x1C3
_0x1C5:
	LDI  R17,LOW(4)
; 0000 01F5     }
_0x1C3:
; 0000 01F6 
; 0000 01F7   }
_0x1C0:
; 0000 01F8   return res;
_0x1AD:
_0x20C0001:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 01F9 }
;
;long CalcLongValue(long Value1, unsigned int Value2)
; 0000 01FC {
; 0000 01FD   return (Value1 * Value2) / 1000;
;	Value1 -> Y+2
;	Value2 -> Y+0
; 0000 01FE }
;
;void Repaint_Button(unsigned char* String, char Number, unsigned int Color, unsigned int BackColor)
; 0000 0201 {
_Repaint_Button:
; 0000 0202   switch(Number)
;	*String -> Y+5
;	Number -> Y+4
;	Color -> Y+2
;	BackColor -> Y+0
	LDD  R30,Y+4
	CALL SUBOPT_0x3E
; 0000 0203   {
; 0000 0204     case 1 :
	BRNE _0x1C9
; 0000 0205       SSD1963_PutString16("     ", BTN1_X_Begin + 10, BTN1_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	__POINTW1MN _0x1CA,0
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	CALL SUBOPT_0x10
	CALL SUBOPT_0x41
; 0000 0206       SSD1963_PutString16(String, BTN1_X_Begin + 10, BTN1_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	CALL SUBOPT_0x3F
	RJMP _0x23B
; 0000 0207     break;
; 0000 0208     case 2 :
_0x1C9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1CB
; 0000 0209       SSD1963_PutString16("     ", BTN2_X_Begin + 10, BTN2_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	__POINTW1MN _0x1CA,6
	CALL SUBOPT_0x42
	CALL SUBOPT_0x40
	CALL SUBOPT_0x10
	CALL SUBOPT_0x41
; 0000 020A       SSD1963_PutString16(String, BTN2_X_Begin + 10, BTN2_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	CALL SUBOPT_0x42
	RJMP _0x23B
; 0000 020B     break;
; 0000 020C     case 3 :
_0x1CB:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1CC
; 0000 020D       SSD1963_PutString16("     ", BTN3_X_Begin + 10, BTN3_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	__POINTW1MN _0x1CA,12
	CALL SUBOPT_0x43
	CALL SUBOPT_0x40
	CALL SUBOPT_0x10
	CALL SUBOPT_0x41
; 0000 020E       SSD1963_PutString16(String, BTN3_X_Begin + 10, BTN3_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	CALL SUBOPT_0x43
	RJMP _0x23B
; 0000 020F     break;
; 0000 0210     case 4 :
_0x1CC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1C8
; 0000 0211       SSD1963_PutString16("     ", BTN4_X_Begin + 10, BTN4_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	__POINTW1MN _0x1CA,18
	CALL SUBOPT_0x44
	CALL SUBOPT_0x40
	CALL SUBOPT_0x10
	CALL SUBOPT_0x41
; 0000 0212       SSD1963_PutString16(String, BTN4_X_Begin + 10, BTN4_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
	CALL SUBOPT_0x44
_0x23B:
	ADIW R30,15
	SBIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL _SSD1963_PutString16
; 0000 0213     break;
; 0000 0214   }
_0x1C8:
; 0000 0215 }
	ADIW R28,7
	RET

	.DSEG
_0x1CA:
	.BYTE 0x18
;
;void Prepare_Screen(void)
; 0000 0218 {

	.CSEG
_Prepare_Screen:
; 0000 0219   // ������ ������ ��� �������
; 0000 021A // SSD1963_DrawFillRect(Battery_X + 3, Battery_Width - 3, Battery_Y, Battery_Y + 2, GREEN);
; 0000 021B // SSD1963_DrawRect(Battery_X, Battery_Width, Battery_Y + 2, Battery_Height, 1, GREEN);
; 0000 021C   // ������ ������
; 0000 021D   SSD1963_DrawFillRect(BTN1_X_Begin, BTN1_X_End, BTN1_Y_Begin, BTN1_Y_End, WHITE);
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2F
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x30
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x45
; 0000 021E   SSD1963_DrawFillRect(BTN2_X_Begin, BTN2_X_End, BTN2_Y_Begin, BTN2_Y_End, WHITE);
	CALL SUBOPT_0x32
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x33
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x34
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x45
; 0000 021F   SSD1963_DrawFillRect(BTN3_X_Begin, BTN3_X_End, BTN3_Y_Begin, BTN3_Y_End, WHITE);
	CALL SUBOPT_0x36
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x37
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x38
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x39
	CALL SUBOPT_0x45
; 0000 0220   SSD1963_DrawFillRect(BTN4_X_Begin, BTN4_X_End, BTN4_Y_Begin, BTN4_Y_End, WHITE);
	CALL SUBOPT_0x3A
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3B
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3C
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x45
; 0000 0221   // ������ ���������
; 0000 0222   SSD1963_DrawRect(BTN1_X_Begin + 1, BTN1_X_End - 1, BTN1_Y_Begin + 1, BTN1_Y_End - 1, 1, BLACK);
	CALL SUBOPT_0x2E
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2F
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x30
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x46
	CALL _SSD1963_DrawRect
; 0000 0223   SSD1963_DrawRect(BTN2_X_Begin + 1, BTN2_X_End - 1, BTN2_Y_Begin + 1, BTN2_Y_End - 1, 1, BLACK);
	CALL SUBOPT_0x32
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x33
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x34
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x46
	CALL _SSD1963_DrawRect
; 0000 0224   SSD1963_DrawRect(BTN3_X_Begin + 1, BTN3_X_End - 1, BTN3_Y_Begin + 1, BTN3_Y_End - 1, 1, BLACK);
	CALL SUBOPT_0x36
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x37
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x38
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x39
	CALL SUBOPT_0x46
	CALL _SSD1963_DrawRect
; 0000 0225   SSD1963_DrawRect(BTN4_X_Begin + 1, BTN4_X_End - 1, BTN4_Y_Begin + 1, BTN4_Y_End - 1, 1, BLACK);
	CALL SUBOPT_0x3A
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3B
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3C
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x46
	CALL _SSD1963_DrawRect
; 0000 0226 
; 0000 0227   Repaint_Button("����", 1, BLACK, WHITE);
	__POINTW1MN _0x1CE,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0x47
; 0000 0228   Repaint_Button("  +", 2, BLACK, WHITE);
	__POINTW1MN _0x1CE,5
	CALL SUBOPT_0x48
	CALL SUBOPT_0xC
	CALL SUBOPT_0x47
; 0000 0229   Repaint_Button("  -", 3, BLACK, WHITE);
	__POINTW1MN _0x1CE,9
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0x47
; 0000 022A   Repaint_Button("�����", 4, BLACK, WHITE);
	__POINTW1MN _0x1CE,13
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
; 0000 022B   /*SSD1963_PutChar16('�', 0, 136, WHITE, BLACK);
; 0000 022C   SSD1963_PutChar16('�', 0, 152, WHITE, BLACK);
; 0000 022D   SSD1963_PutChar16('�', 0, 168, WHITE, BLACK);
; 0000 022E   SSD1963_PutChar16('�', 0, 184, WHITE, BLACK);
; 0000 022F   SSD1963_PutChar16('�', 0, 200, WHITE, BLACK);
; 0000 0230   SSD1963_PutChar16('�', 0, 216, WHITE, BLACK);      */
; 0000 0231 }
	RET

	.DSEG
_0x1CE:
	.BYTE 0x13
;
;void Paint_ScanLine(unsigned int X_Min, unsigned int X_Max, unsigned int Y_Min, unsigned int Y_Max, unsigned int Color, unsigned int Length)
; 0000 0234 {

	.CSEG
; 0000 0235   signed int ScanLine_NetHeight, ScanLine_NetWidth;
; 0000 0236   if (ScanLine_X == 0) ScanLine_X = X_Min;
;	X_Min -> Y+14
;	X_Max -> Y+12
;	Y_Min -> Y+10
;	Y_Max -> Y+8
;	Color -> Y+6
;	Length -> Y+4
;	ScanLine_NetHeight -> R16,R17
;	ScanLine_NetWidth -> R18,R19
; 0000 0237   ScanLine_NetHeight = (Y_Max - Y_Min) - Length;
; 0000 0238   ScanLine_NetWidth = (X_Max - X_Min) - Length;
; 0000 0239   while (ScanLine_NetHeight > 0)
; 0000 023A   {
; 0000 023B     SSD1963_DrawFastLine(X_Min, X_Max, Y_Min + ScanLine_NetHeight, Y_Min + ScanLine_NetHeight, Color);
; 0000 023C     ScanLine_NetHeight -= Length;
; 0000 023D   }
; 0000 023E   while (ScanLine_NetWidth > 0)
; 0000 023F   {
; 0000 0240     SSD1963_DrawFastLine(X_Min + ScanLine_NetWidth, X_Min + ScanLine_NetWidth, Y_Min, Y_Max, Color);
; 0000 0241     ScanLine_NetWidth -= Length;
; 0000 0242   }
; 0000 0243 
; 0000 0244 //  if ((ScanLine_X % Length) < 1)  SSD1963_DrawFastLine(ScanLine_X, ScanLine_X, Y_Min, Y_Max, Color);
; 0000 0245   //if ((Counter % Length) < 1)  SSD1963_DrawFastLine(Counter, Counter, Y_Min, Y_Max, Color);
; 0000 0246 //  ScanLine_X += Counter; // ����������� � �����
; 0000 0247 //  if (ScanLine_X > X_Max - Length - 1) // ���� �������� �� ����� ���������� ������������
; 0000 0248 //  {
; 0000 0249 //    ScanLine_X = X_Min; // ������ �������
; 0000 024A //  }
; 0000 024B }
;
;void Paint_Pulse(unsigned int Value, unsigned int Color)
; 0000 024E {
; 0000 024F   if (Pulse_ScreenFlag != Pulse_Flag)
;	Value -> Y+2
;	Color -> Y+0
; 0000 0250   {
; 0000 0251     if (Pulse_Flag == 1) Pulse_ScreenValue = Pulse_Y_Min + 5;
; 0000 0252     else if (Pulse_Flag == 0) Pulse_ScreenValue = Pulse_Y_Max - 5;
; 0000 0253     Pulse_ScreenFlag = Pulse_Flag;
; 0000 0254     Alarm_mSec = 0;
; 0000 0255     Alarm = 0;
; 0000 0256   }
; 0000 0257 
; 0000 0258   SSD1963_DrawFastLine(Pulse_X, Pulse_X + Value, Pulse_Y_Min, Pulse_Y_Max, BLACK); // ������� �� ����� ������� ��������
; 0000 0259   SSD1963_DrawLine(Pulse_X, Pulse_X + Value, Pulse_Y_Last, Pulse_ScreenValue, Color, 1); // ����� ����� � �������
; 0000 025A   Pulse_X += Value; // ����������� � ������
; 0000 025B   Pulse_Y_Last = Pulse_ScreenValue; // ���������� ���������� ����� ������
; 0000 025C   Pulse_ScreenValue = Pulse_Y_Max / 2;
; 0000 025D   if (Pulse_X > Pulse_X_Max - (2 * Value)) // ���� �������� �� ����� ���������� ������������
; 0000 025E   {
; 0000 025F     SSD1963_DrawFastLine(Pulse_X, Pulse_X_Max, Pulse_Y_Min, Pulse_Y_Max, BLACK); // ������� ������� � ������ ��� ������� ������
; 0000 0260     Pulse_X = Pulse_X_Min; // ������ �������
; 0000 0261     SSD1963_DrawFastLine(Pulse_X - Value, Pulse_X, Pulse_Y_Min, Pulse_Y_Max, BLACK); // ������� ������� � ������ ��� ������� ������
; 0000 0262   }
; 0000 0263 }
;
;signed int ValueLast[3]={Cardio_Y_Min,Cardio_Y_Min,Cardio_Y_Min};

	.DSEG
;signed int multiplier = 60;
;
;void Paint_3phase(char a, char b, char c)
; 0000 0269 {

	.CSEG
_Paint_3phase:
; 0000 026A     signed int Value[3];
; 0000 026B     unsigned int Color[] = {GREEN, YELLOW, RED};
; 0000 026C     unsigned int Length = WorkParameters[1];
; 0000 026D     signed int mid = ((Cardio_Y_Max - Cardio_Y_Min)>>1) + Cardio_Y_Min;
; 0000 026E     unsigned int temp;
; 0000 026F     char i;
; 0000 0270 
; 0000 0271     Value[0] = a;
	CALL SUBOPT_0x4A
;	a -> Y+21
;	b -> Y+20
;	c -> Y+19
;	Value -> Y+13
;	Color -> Y+7
;	Length -> R16,R17
;	mid -> R18,R19
;	temp -> R20,R21
;	i -> Y+6
	LDD  R30,Y+21
	LDI  R31,0
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 0272     Value[1] = b;
	LDD  R30,Y+20
	LDI  R31,0
	STD  Y+15,R30
	STD  Y+15+1,R31
; 0000 0273     Value[2] = c;
	LDD  R30,Y+19
	LDI  R31,0
	STD  Y+17,R30
	STD  Y+17+1,R31
; 0000 0274 
; 0000 0275     // ������� �� ����� ������� ��������
; 0000 0276     SSD1963_DrawFillRect(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK);
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	CALL _SSD1963_DrawFillRect
; 0000 0277 
; 0000 0278     //����� ����
; 0000 0279     SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, mid, mid, DGRAY);
	CALL SUBOPT_0x4B
	ST   -Y,R19
	ST   -Y,R18
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x4D
; 0000 027A     SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, mid+50, mid+50, DGRAY);
	MOVW R30,R18
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4D
; 0000 027B     SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, mid-50, mid-50, DGRAY);
	MOVW R30,R18
	SBIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SBIW R30,50
	CALL SUBOPT_0x4E
; 0000 027C 
; 0000 027D     for(i=0; i<3; i++)
_0x1DE:
	LDD  R26,Y+6
	CPI  R26,LOW(0x3)
	BRLO PC+3
	JMP _0x1DF
; 0000 027E     {
; 0000 027F         Value[i] -= 128;
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0280         Value[i] *= multiplier;
	CALL SUBOPT_0x52
; 0000 0281         Value[i] >>= 7;
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 0282         if(Value[i]&0x0100) Value[i] |= 0xFF00;
	CALL SUBOPT_0x54
	ANDI R31,HIGH(0x100)
	BREQ _0x1E0
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	ORI  R31,HIGH(0xFF00)
	ST   -X,R31
	ST   -X,R30
; 0000 0283 
; 0000 0284         Value[i] += mid;
_0x1E0:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	ADD  R30,R18
	ADC  R31,R19
	ST   -X,R31
	ST   -X,R30
; 0000 0285         if(Value[i] >= Cardio_Y_Max) Value[i] = Cardio_Y_Max - 1;
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x54
	CPI  R30,LOW(0xE8)
	LDI  R26,HIGH(0xE8)
	CPC  R31,R26
	BRLT _0x1E1
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x55
; 0000 0286         if(Value[i] < Cardio_Y_Min) Value[i] = Cardio_Y_Min;
_0x1E1:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x54
	SBIW R30,50
	BRGE _0x1E2
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x56
; 0000 0287 
; 0000 0288         // ����� ����� � �������
; 0000 0289         SSD1963_DrawLine(Cardio_X, Cardio_X + Length, ValueLast[i], Value[i], Color[i], 2);
_0x1E2:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
	CALL SUBOPT_0x48
	CALL SUBOPT_0x5A
; 0000 028A         ValueLast[i] = Value[i]; // ���������� ���������� ����� ������������
	CALL SUBOPT_0x54
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 028B     }
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RJMP _0x1DE
_0x1DF:
; 0000 028C 
; 0000 028D     Cardio_X += Length; // ����������� � ������������
	CALL SUBOPT_0x5B
; 0000 028E 
; 0000 028F   if (Cardio_X > Cardio_X_Max - Length) // ���� �������� �� ����� ���������� ������������
	BRSH _0x1E3
; 0000 0290   {
; 0000 0291     SSD1963_DrawFillRect(Cardio_X, Cardio_X_Max, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK); // ������� ������� � ������ ��� ������� ������
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 0292     Cardio_X = Cardio_X_Min; // ������ �������
; 0000 0293     SSD1963_DrawFillRect(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK); // ������� ������� � ������ ��� ������� ������
	CALL SUBOPT_0x4C
	CALL _SSD1963_DrawFillRect
; 0000 0294   }
; 0000 0295 }
_0x1E3:
	CALL __LOADLOCR6
	ADIW R28,22
	RET
;
;void Paint_2phase(char a, char b)
; 0000 0298 {
_Paint_2phase:
; 0000 0299     signed int Value[3];
; 0000 029A     unsigned int Color[] = {GREEN, YELLOW, RED};
; 0000 029B     unsigned int Length = WorkParameters[1];
; 0000 029C     signed int mid = ((Cardio_Y_Max - Cardio_Y_Min)>>1) + Cardio_Y_Min;
; 0000 029D     unsigned int temp;
; 0000 029E     char i;
; 0000 029F 
; 0000 02A0     Value[0] = a;
	CALL SUBOPT_0x4A
;	a -> Y+20
;	b -> Y+19
;	Value -> Y+13
;	Color -> Y+7
;	Length -> R16,R17
;	mid -> R18,R19
;	temp -> R20,R21
;	i -> Y+6
	LDD  R30,Y+20
	LDI  R31,0
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 02A1     Value[1] = b;
	LDD  R30,Y+19
	LDI  R31,0
	STD  Y+15,R30
	STD  Y+15+1,R31
; 0000 02A2     //Value[2] = c;
; 0000 02A3 
; 0000 02A4     // ������� �� ����� ������� ��������
; 0000 02A5     SSD1963_DrawFillRect(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK);
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	CALL _SSD1963_DrawFillRect
; 0000 02A6 
; 0000 02A7     //����� ����
; 0000 02A8     //SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, mid, mid, DGRAY);
; 0000 02A9     SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, mid+40, mid+40, DGRAY);
	CALL SUBOPT_0x4B
	MOVW R30,R18
	ADIW R30,40
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,40
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4D
; 0000 02AA     SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, mid-40, mid-40, DGRAY);
	MOVW R30,R18
	SBIW R30,40
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SBIW R30,40
	CALL SUBOPT_0x4E
; 0000 02AB 
; 0000 02AC     for(i=0; i<2; i++)
_0x1E5:
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BRLO PC+3
	JMP _0x1E6
; 0000 02AD     {
; 0000 02AE         Value[i] -= 128;
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 02AF         Value[i] *= multiplier;
	CALL SUBOPT_0x52
; 0000 02B0         Value[i] >>= 7;
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 02B1         if(Value[i]&0x0100) Value[i] |= 0xFF00;
	CALL SUBOPT_0x54
	ANDI R31,HIGH(0x100)
	BREQ _0x1E7
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	ORI  R31,HIGH(0xFF00)
	ST   -X,R31
	ST   -X,R30
; 0000 02B2 
; 0000 02B3         if(i==0) Value[i] += mid+40;
_0x1E7:
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0x1E8
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x5E
	ADIW R30,40
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 02B4         if(i==1) Value[i] += mid-40;
_0x1E8:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x1E9
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x5E
	SBIW R30,40
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 02B5         if(Value[i] >= Cardio_Y_Max) Value[i] = Cardio_Y_Max - 1;
_0x1E9:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x54
	CPI  R30,LOW(0xE8)
	LDI  R26,HIGH(0xE8)
	CPC  R31,R26
	BRLT _0x1EA
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x55
; 0000 02B6         if(Value[i] < Cardio_Y_Min) Value[i] = Cardio_Y_Min;
_0x1EA:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x54
	SBIW R30,50
	BRGE _0x1EB
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x56
; 0000 02B7 
; 0000 02B8         // ����� ����� � �������
; 0000 02B9         SSD1963_DrawLine(Cardio_X, Cardio_X + Length, ValueLast[i], Value[i], Color[i], 2);
_0x1EB:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
	CALL SUBOPT_0x48
	CALL SUBOPT_0x5A
; 0000 02BA         ValueLast[i] = Value[i]; // ���������� ���������� ����� ������������
	CALL SUBOPT_0x54
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 02BB     }
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RJMP _0x1E5
_0x1E6:
; 0000 02BC 
; 0000 02BD     Cardio_X += Length; // ����������� � ������������
	CALL SUBOPT_0x5B
; 0000 02BE 
; 0000 02BF   if (Cardio_X > Cardio_X_Max - Length) // ���� �������� �� ����� ���������� ������������
	BRSH _0x1EC
; 0000 02C0   {
; 0000 02C1     SSD1963_DrawFillRect(Cardio_X, Cardio_X_Max, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK); // ������� ������� � ������ ��� ������� ������
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02C2     Cardio_X = Cardio_X_Min; // ������ �������
; 0000 02C3     SSD1963_DrawFillRect(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK); // ������� ������� � ������ ��� ������� ������
	CALL SUBOPT_0x4C
	CALL _SSD1963_DrawFillRect
; 0000 02C4   }
; 0000 02C5 }
_0x1EC:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
;
;
;void Paint_Cardio(unsigned int Value, unsigned int Color, unsigned int Length)
; 0000 02C9 {
; 0000 02CA   signed int temp, temp2;
; 0000 02CB   temp = Cardio_Y_Max - (Value / Cardio_Divider);
;	Value -> Y+8
;	Color -> Y+6
;	Length -> Y+4
;	temp -> R16,R17
;	temp2 -> R18,R19
; 0000 02CC   if (temp < Cardio_Y_Min) temp = Cardio_Y_Min;
; 0000 02CD   if (temp > Cardio_Y_Max) temp = Cardio_Y_Max - 1;
; 0000 02CE   temp2 = Cardio_Y_Max - (WorkParameters[2] / Cardio_Divider);
; 0000 02CF   if (temp2 < Cardio_Y_Min) temp2 = Cardio_Y_Min;
; 0000 02D0 
; 0000 02D1   SSD1963_DrawFillRect(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK); // ������� �� ����� ������� ��������
; 0000 02D2 //  Paint_ScanLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Max, DGRAY, 25);
; 0000 02D3   //SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Min, DGRAY);
; 0000 02D4   SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min + 25, Cardio_Y_Min + 25, DGRAY);
; 0000 02D5   SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min + 50, Cardio_Y_Min + 50, DGRAY);
; 0000 02D6   SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min + 75, Cardio_Y_Min + 75, DGRAY);
; 0000 02D7   SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min + 100, Cardio_Y_Min + 100, DGRAY);
; 0000 02D8   SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min + 125, Cardio_Y_Min + 125, DGRAY);
; 0000 02D9   SSD1963_DrawFastLine(Cardio_X, Cardio_X + Length, Cardio_Y_Min + 150, Cardio_Y_Min + 150, DGRAY);
; 0000 02DA 
; 0000 02DB   //if ((Cardio_X % Length) < 1)  SSD1963_DrawFastLine(Cardio_X, Cardio_X, Cardio_Y_Min, Cardio_Y_Max, DGRAY);
; 0000 02DC   SSD1963_DrawLine(Cardio_X, Cardio_X + Length, temp2, temp2, YELLOW, 1); // ����� ����� � �������
; 0000 02DD   SSD1963_DrawLine(Cardio_X, Cardio_X + Length, Cardio_Y_Last, temp, Color, 2); // ����� ����� � �������
; 0000 02DE   Cardio_X += Length; // ����������� � ������������
; 0000 02DF   Cardio_Y_Last = temp; // ���������� ���������� ����� ������������
; 0000 02E0   if (Cardio_X > Cardio_X_Max - Length) // ���� �������� �� ����� ���������� ������������
; 0000 02E1   {
; 0000 02E2     SSD1963_DrawFillRect(Cardio_X, Cardio_X_Max, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK); // ������� ������� � ������ ��� ������� ������
; 0000 02E3     Cardio_X = Cardio_X_Min; // ������ �������
; 0000 02E4     SSD1963_DrawFillRect(Cardio_X, Cardio_X + Length, Cardio_Y_Min, Cardio_Y_Max + 1, BLACK); // ������� ������� � ������ ��� ������� ������
; 0000 02E5   }
; 0000 02E6 }
;
;void Calc_Pulse(unsigned int Value)
; 0000 02E9 {
; 0000 02EA   if (Value > WorkParameters[2])
;	Value -> Y+0
; 0000 02EB   {
; 0000 02EC     if (Pulse_Flag < 1)
; 0000 02ED     {
; 0000 02EE       Pulse_Counter++;
; 0000 02EF       Pulse_Flag = 1;
; 0000 02F0     }
; 0000 02F1   }
; 0000 02F2   else if (Pulse_Flag > 0) Pulse_Flag = 0;
; 0000 02F3 
; 0000 02F4   if (Pulse_mSec > 59999)
; 0000 02F5   {
; 0000 02F6     Pulse_mSec = 0;
; 0000 02F7     Pulse_Value = Pulse_Counter;
; 0000 02F8     Pulse_Counter = 0;
; 0000 02F9   }
; 0000 02FA }
;
;/*void Paint_Battery(unsigned int Value)
;{
;  SSD1963_DrawFillRect(Battery_X + 4, Battery_Width - 4, Battery_Y + 4, Battery_Height - 4, BLACK);
;  SSD1963_DrawFillRect(Battery_X + 4, Battery_Width - 4, Battery_Y + 4 + (45 - Value), Battery_Height - 4, GREEN);
;*/
;void PutParameterText(char Number, char X, char Y, unsigned int Color)
; 0000 0302 {
_PutParameterText:
; 0000 0303   SSD1963_PutString16("                ", X, Y, Color, BLACK);
;	Number -> Y+4
;	X -> Y+3
;	Y -> Y+2
;	Color -> Y+0
	__POINTW1MN _0x1F6,0
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
	CALL _SSD1963_PutString16
; 0000 0304   SSD1963_PutString16("                ", X, Y + FONT_HEIGHT, Color, BLACK);
	__POINTW1MN _0x1F6,17
	CALL SUBOPT_0x5F
	ADIW R30,16
	CALL SUBOPT_0x60
	CALL _SSD1963_PutString16
; 0000 0305   switch (Number)
	LDD  R30,Y+4
	CALL SUBOPT_0x61
; 0000 0306   {
; 0000 0307     case 0 :
	BRNE _0x1FA
; 0000 0308       SSD1963_PutString16("����������", X, Y, Color, BLACK);
	__POINTW1MN _0x1F6,34
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
	CALL _SSD1963_PutString16
; 0000 0309       SSD1963_PutString16("���", X, Y + FONT_HEIGHT, Color, BLACK);
	__POINTW1MN _0x1F6,45
	RJMP _0x23D
; 0000 030A     break;
; 0000 030B     case 1 :
_0x1FA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1FB
; 0000 030C       SSD1963_PutString16("���", X, Y, Color, BLACK);
	__POINTW1MN _0x1F6,49
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
	CALL _SSD1963_PutString16
; 0000 030D       SSD1963_PutString16("���", X, Y + FONT_HEIGHT, Color, BLACK);
	__POINTW1MN _0x1F6,53
	RJMP _0x23D
; 0000 030E     break;
; 0000 030F     case 2 :
_0x1FB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F9
; 0000 0310       SSD1963_PutString16("���������� � ���", X, Y, Color, BLACK);
	__POINTW1MN _0x1F6,57
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
	CALL _SSD1963_PutString16
; 0000 0311       SSD1963_PutString16("�����������", X, Y + FONT_HEIGHT, Color, BLACK);
	__POINTW1MN _0x1F6,74
_0x23D:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDI  R31,0
	ADIW R30,16
	CALL SUBOPT_0x60
	CALL _SSD1963_PutString16
; 0000 0312     break;
; 0000 0313     /*
; 0000 0314     case 3 :
; 0000 0315       SSD1963_PutString16("����� ���������", X, Y, Color, BLACK);
; 0000 0316       SSD1963_PutString16("��������", X, Y + FONT_HEIGHT, Color, BLACK);
; 0000 0317     break;
; 0000 0318     case 4 :
; 0000 0319       SSD1963_PutString16("�������� ���", X, Y, Color, BLACK);
; 0000 031A       SSD1963_PutString16("������������", X, Y + FONT_HEIGHT, Color, BLACK);
; 0000 031B     break;
; 0000 031C     case 5 :
; 0000 031D       SSD1963_PutString16("�� ������������", X, Y, Color, BLACK);
; 0000 031E       SSD1963_PutString16("� ������� ������", X, Y + FONT_HEIGHT, Color, BLACK);
; 0000 031F     break;
; 0000 0320     case 6 :
; 0000 0321       SSD1963_PutString16("���������� ����", X, Y, Color, BLACK);
; 0000 0322       SSD1963_PutString16("����", X, Y + FONT_HEIGHT, Color, BLACK);
; 0000 0323     break;
; 0000 0324     case 7 :
; 0000 0325       SSD1963_PutString16("���������� ����", X, Y, Color, BLACK);
; 0000 0326       SSD1963_PutString16("�����", X, Y + FONT_HEIGHT, Color, BLACK);
; 0000 0327     break;
; 0000 0328     case 8 :
; 0000 0329       SSD1963_PutString16("���������� ����", X, Y, Color, BLACK);
; 0000 032A       SSD1963_PutString16("���", X, Y + FONT_HEIGHT, Color, BLACK);
; 0000 032B     break;
; 0000 032C     case 9 :
; 0000 032D       SSD1963_PutString16("���������� ����", X, Y, Color, BLACK);
; 0000 032E       SSD1963_PutString16("������", X, Y + FONT_HEIGHT, Color, BLACK);
; 0000 032F     break;*/
; 0000 0330   }
_0x1F9:
; 0000 0331 }
	ADIW R28,5
	RET

	.DSEG
_0x1F6:
	.BYTE 0x56
;
;void main(void)
; 0000 0334 {

	.CSEG
_main:
; 0000 0335 unsigned int ii = 0xffff;
; 0000 0336 char yiii[3];
; 0000 0337 
; 0000 0338 {
	SBIW R28,3
;	ii -> R16,R17
;	yiii -> Y+0
	__GETWRN 16,17,-1
; 0000 0339 // Input/Output Ports initialization
; 0000 033A // Port A initialization
; 0000 033B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 033C // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 033D PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 033E DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 033F 
; 0000 0340 // Port B initialization
; 0000 0341 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=Out
; 0000 0342 // State7=0 State6=0 State5=0 State4=0 State3=T State2=0 State1=0 State0=0
; 0000 0343 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0344 DDRB=0xF7;
	LDI  R30,LOW(247)
	OUT  0x17,R30
; 0000 0345 
; 0000 0346 // Port C initialization
; 0000 0347 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0348 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0349 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 034A DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 034B 
; 0000 034C // Port D initialization
; 0000 034D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=Out
; 0000 034E // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=0
; 0000 034F PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0350 DDRD=0xFB;
	LDI  R30,LOW(251)
	OUT  0x11,R30
; 0000 0351 
; 0000 0352 // Port E initialization
; 0000 0353 // Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=In
; 0000 0354 // State7=0 State6=T State5=0 State4=0 State3=T State2=0 State1=0 State0=T
; 0000 0355 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0356 DDRE=0xB6;
	LDI  R30,LOW(182)
	OUT  0x2,R30
; 0000 0357 
; 0000 0358 // Port F initialization
; 0000 0359 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 035A // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
; 0000 035B PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 035C DDRF=0xF8;
	LDI  R30,LOW(248)
	STS  97,R30
; 0000 035D 
; 0000 035E // Port G initialization
; 0000 035F // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0360 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0361 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 0362 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 0363 
; 0000 0364 // Timer/Counter 0 initialization
; 0000 0365 // Clock source: System Clock
; 0000 0366 // Clock value: 250,000 kHz
; 0000 0367 // Mode: Normal top=0xFF
; 0000 0368 // OC0 output: Disconnected
; 0000 0369 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 036A TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 036B TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 036C OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 036D 
; 0000 036E // Timer/Counter 1 initialization
; 0000 036F // Clock source: System Clock
; 0000 0370 // Clock value: Timer1 Stopped
; 0000 0371 // Mode: Normal top=0xFFFF
; 0000 0372 // OC1A output: Discon.
; 0000 0373 // OC1B output: Discon.
; 0000 0374 // OC1C output: Discon.
; 0000 0375 // Noise Canceler: Off
; 0000 0376 // Input Capture on Falling Edge
; 0000 0377 // Timer1 Overflow Interrupt: Off
; 0000 0378 // Input Capture Interrupt: Off
; 0000 0379 // Compare A Match Interrupt: Off
; 0000 037A // Compare B Match Interrupt: Off
; 0000 037B // Compare C Match Interrupt: Off
; 0000 037C TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 037D TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 037E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 037F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0380 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0381 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0382 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0383 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0384 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0385 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0386 OCR1CH=0x00;
	STS  121,R30
; 0000 0387 OCR1CL=0x00;
	STS  120,R30
; 0000 0388 
; 0000 0389 // Timer/Counter 2 initialization
; 0000 038A // Clock source: System Clock
; 0000 038B // Clock value: Timer2 Stopped
; 0000 038C // Mode: Normal top=0xFF
; 0000 038D // OC2 output: Disconnected
; 0000 038E TCCR2=0x00;
	OUT  0x25,R30
; 0000 038F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0390 OCR2=0x00;
	OUT  0x23,R30
; 0000 0391 
; 0000 0392 // Timer/Counter 3 initialization
; 0000 0393 // Clock source: System Clock
; 0000 0394 // Clock value: Timer3 Stopped
; 0000 0395 // Mode: Normal top=0xFFFF
; 0000 0396 // OC3A output: Discon.
; 0000 0397 // OC3B output: Discon.
; 0000 0398 // OC3C output: Discon.
; 0000 0399 // Noise Canceler: Off
; 0000 039A // Input Capture on Falling Edge
; 0000 039B // Timer3 Overflow Interrupt: Off
; 0000 039C // Input Capture Interrupt: Off
; 0000 039D // Compare A Match Interrupt: Off
; 0000 039E // Compare B Match Interrupt: Off
; 0000 039F // Compare C Match Interrupt: Off
; 0000 03A0 TCCR3A=0x00;
	STS  139,R30
; 0000 03A1 TCCR3B=0x00;
	STS  138,R30
; 0000 03A2 TCNT3H=0x00;
	STS  137,R30
; 0000 03A3 TCNT3L=0x00;
	STS  136,R30
; 0000 03A4 ICR3H=0x00;
	STS  129,R30
; 0000 03A5 ICR3L=0x00;
	STS  128,R30
; 0000 03A6 OCR3AH=0x00;
	STS  135,R30
; 0000 03A7 OCR3AL=0x00;
	STS  134,R30
; 0000 03A8 OCR3BH=0x00;
	STS  133,R30
; 0000 03A9 OCR3BL=0x00;
	STS  132,R30
; 0000 03AA OCR3CH=0x00;
	STS  131,R30
; 0000 03AB OCR3CL=0x00;
	STS  130,R30
; 0000 03AC 
; 0000 03AD // External Interrupt(s) initialization
; 0000 03AE // INT0: Off
; 0000 03AF // INT1: Off
; 0000 03B0 // INT2: Off
; 0000 03B1 // INT3: Off
; 0000 03B2 // INT4: Off
; 0000 03B3 // INT5: Off
; 0000 03B4 // INT6: Off
; 0000 03B5 // INT7: Off
; 0000 03B6 EICRA=0x00;
	STS  106,R30
; 0000 03B7 EICRB=0x00;
	OUT  0x3A,R30
; 0000 03B8 EIMSK=0x00;
	OUT  0x39,R30
; 0000 03B9 
; 0000 03BA // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 03BB TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 03BC 
; 0000 03BD ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 03BE 
; 0000 03BF // USART0 initialization
; 0000 03C0 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 03C1 // USART0 Receiver: On
; 0000 03C2 // USART0 Transmitter: On
; 0000 03C3 // USART0 Mode: Asynchronous
; 0000 03C4 // USART0 Baud Rate: 115200
; 0000 03C5 UCSR0A=0x00;
	OUT  0xB,R30
; 0000 03C6 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 03C7 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 03C8 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 03C9 UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 03CA 
; 0000 03CB // USART1 initialization
; 0000 03CC // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 03CD // USART1 Receiver: On
; 0000 03CE // USART1 Transmitter: On
; 0000 03CF // USART1 Mode: Asynchronous
; 0000 03D0 // USART1 Baud Rate: 9600
; 0000 03D1 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 03D2 UCSR1B=0xD8;
	LDI  R30,LOW(216)
	STS  154,R30
; 0000 03D3 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 03D4 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 03D5 UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 03D6 
; 0000 03D7 // Analog Comparator initialization
; 0000 03D8 // Analog Comparator: Off
; 0000 03D9 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 03DA ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 03DB SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 03DC 
; 0000 03DD // ADC initialization
; 0000 03DE // ADC Clock frequency: 1000,000 kHz
; 0000 03DF // ADC Voltage Reference: AREF pin
; 0000 03E0 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 03E1 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 03E2 
; 0000 03E3 // SPI initialization
; 0000 03E4 // SPI Type: Master
; 0000 03E5 // SPI Clock Rate: 2*250,000 kHz
; 0000 03E6 // SPI Clock Phase: Cycle Start
; 0000 03E7 // SPI Clock Polarity: Low
; 0000 03E8 // SPI Data Order: MSB First
; 0000 03E9 SPCR=0x52;
	LDI  R30,LOW(82)
	OUT  0xD,R30
; 0000 03EA SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 03EB 
; 0000 03EC // TWI initialization
; 0000 03ED // TWI disabled
; 0000 03EE TWCR=0x00;
	STS  116,R30
; 0000 03EF 
; 0000 03F0 // I2C Bus initialization
; 0000 03F1 i2c_init();
	CALL _i2c_init
; 0000 03F2 
; 0000 03F3 // Global enable interrupts
; 0000 03F4 #asm("sei")
	sei
; 0000 03F5 }
; 0000 03F6 
; 0000 03F7   //PORTE.6 = 1;
; 0000 03F8   SwitchPORTF(LEDGREEN, 1);
	CALL SUBOPT_0x2C
; 0000 03F9   SwitchPORTF(LEDRED, 1);
	CALL SUBOPT_0x2A
; 0000 03FA   SwitchPORTF(LEDBLUE, 1);
	CALL SUBOPT_0x2B
; 0000 03FB   delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x4
; 0000 03FC 
; 0000 03FD   SSD1963_Init();
	CALL _SSD1963_Init
; 0000 03FE   SwitchPORTF(BACKLIGHT, 1);
	CALL SUBOPT_0x62
; 0000 03FF   /*SSD1963_ClearScreen(BLACK);
; 0000 0400   SSD1963_PutString16("�������������...", 0, 0, WHITE, BLACK);
; 0000 0401   SSD1963_PutString16("���������� ������...", 0, FONT_HEIGHT * 1, WHITE, BLACK);
; 0000 0402   */
; 0000 0403   if (EEPROM_FLAG > 1)
	LDI  R26,LOW(_EEPROM_FLAG)
	LDI  R27,HIGH(_EEPROM_FLAG)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRLO _0x1FD
; 0000 0404   {
; 0000 0405     for(i = 0; i < 3; i++)
	CLR  R4
_0x1FF:
	LDI  R30,LOW(3)
	CP   R4,R30
	BRSH _0x200
; 0000 0406     WorkParameters[i] = Default_Parameters[i];
	MOV  R30,R4
	LDI  R26,LOW(_WorkParameters)
	LDI  R27,HIGH(_WorkParameters)
	CALL SUBOPT_0x63
	MOVW R22,R30
	MOV  R30,R4
	LDI  R26,LOW(_Default_Parameters*2)
	LDI  R27,HIGH(_Default_Parameters*2)
	CALL SUBOPT_0x63
	CALL __GETW1PF
	MOVW R26,R22
	CALL __EEPROMWRW
	INC  R4
	RJMP _0x1FF
_0x200:
; 0000 0407 EEPROM_FLAG = 0;
	LDI  R26,LOW(_EEPROM_FLAG)
	LDI  R27,HIGH(_EEPROM_FLAG)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0408   }
; 0000 0409   /*
; 0000 040A   SSD1963_PutString16("���������� ����...", 0, FONT_HEIGHT * 2, WHITE, BLACK);
; 0000 040B   rtc_init(0, 0);
; 0000 040C   rtc_get_time(0, &Hour, &Minute, &Seconds, &mSeconds);
; 0000 040D   rtc_get_date(0, &Day, &Month, &Year);*/
; 0000 040E 
; 0000 040F   SSD1963_ClearScreen(BLACK);
_0x1FD:
	CALL SUBOPT_0xC
	CALL _SSD1963_ClearScreen
; 0000 0410 
; 0000 0411   SSD1963_PutString16("������", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) - FONT_HEIGHT, RED, BLACK);
	__POINTW1MN _0x201,0
	CALL SUBOPT_0x64
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x65
	CALL SUBOPT_0x66
; 0000 0412   delay_ms(300);
; 0000 0413   SSD1963_PutString16("������", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2), YELLOW, BLACK);
	__POINTW1MN _0x201,7
	CALL SUBOPT_0x64
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65287)
	LDI  R31,HIGH(65287)
	CALL SUBOPT_0xD
	CALL SUBOPT_0x66
; 0000 0414   delay_ms(300);
; 0000 0415   SSD1963_PutString16("������", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) + FONT_HEIGHT, RED, BLACK);
	__POINTW1MN _0x201,14
	CALL SUBOPT_0x64
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x65
	CALL SUBOPT_0x66
; 0000 0416   delay_ms(300);
; 0000 0417   SSD1963_PutString16("      ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) - FONT_HEIGHT, BLACK, BLACK);
	__POINTW1MN _0x201,21
	CALL SUBOPT_0x64
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
	CALL SUBOPT_0x66
; 0000 0418   delay_ms(300);
; 0000 0419   SSD1963_PutString16("      ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2), BLACK, BLACK);
	__POINTW1MN _0x201,28
	CALL SUBOPT_0x64
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
	CALL SUBOPT_0x66
; 0000 041A   delay_ms(300);
; 0000 041B   SSD1963_PutString16("      ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) + FONT_HEIGHT, BLACK, BLACK);
	__POINTW1MN _0x201,35
	CALL SUBOPT_0x64
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
	CALL _SSD1963_PutString16
; 0000 041C 
; 0000 041D   Prepare_Screen();
	RCALL _Prepare_Screen
; 0000 041E   TSC2046_Init();
	CALL _TSC2046_Init
; 0000 041F 
; 0000 0420   Cardio_Y_Last = Cardio_Y_Min;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _Cardio_Y_Last,R30
	STS  _Cardio_Y_Last+1,R31
; 0000 0421   Cardio_X = Cardio_X_Min;
	LDI  R30,LOW(0)
	STS  _Cardio_X,R30
	STS  _Cardio_X+1,R30
; 0000 0422   Cardio_Divider = WorkParameters[0] / (Cardio_Y_Max - Cardio_Y_Min);
	LDI  R26,LOW(_WorkParameters)
	LDI  R27,HIGH(_WorkParameters)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL __DIVW21U
	LDI  R26,LOW(_Cardio_Divider)
	LDI  R27,HIGH(_Cardio_Divider)
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTDP1
; 0000 0423   PutParameterText(Parameter_Counter, 30, 16, BLUE);
	CALL SUBOPT_0x67
; 0000 0424   Pulse_X = Pulse_X_Min;
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	STS  _Pulse_X,R30
	STS  _Pulse_X+1,R31
; 0000 0425 
; 0000 0426   //Paint_ScanLine(Cardio_X_Min, Cardio_X_Max, Cardio_Y_Min, Cardio_Y_Max, DGRAY, 50);
; 0000 0427 
; 0000 0428    RS485 = 1;
	SBI  0x12,4
; 0000 0429 
; 0000 042A while (1)
_0x204:
; 0000 042B {
; 0000 042C 
; 0000 042D 
; 0000 042E         switch(State)
	LDS  R30,_State
	CALL SUBOPT_0x61
; 0000 042F         {
; 0000 0430           case 0 : // �������� ������� �����
	BREQ PC+3
	JMP _0x20A
; 0000 0431           {
; 0000 0432             /*if (ADC0 > WorkParameters[0]) ADC0 = WorkParameters[0];
; 0000 0433             for (i = 0; i < 192; i++) longADC += read_adc(0);
; 0000 0434             longADC = longADC / 192;
; 0000 0435             ADC0 = longADC;
; 0000 0436             longADC = 0;*/
; 0000 0437             //ADC0 = read_adc(0);
; 0000 0438             //if (ADC0 > WorkParameters[0]) ADC0 = WorkParameters[0];
; 0000 0439            // putchar(Address_Slave);
; 0000 043A            // if (rx_counter0 > 0)
; 0000 043B            // {
; 0000 043C               //  ADC0 = ((getchar() << 8) + getchar());
; 0000 043D             //}
; 0000 043E 
; 0000 043F            // Cardio_Divider = WorkParameters[0] / (Cardio_Y_Max - Cardio_Y_Min);
; 0000 0440             //Paint_Cardio(ADC0, RED, WorkParameters[1]);
; 0000 0441 
; 0000 0442 
; 0000 0443 
; 0000 0444              if(WaitADC_mSec>10)
	LDS  R26,_WaitADC_mSec
	LDS  R27,_WaitADC_mSec+1
	SBIW R26,11
	BRLO _0x20B
; 0000 0445             while(rx_counter0>2 || (rx_counter0>1 && Parameter_Counter==2))
_0x20C:
	LDS  R26,_rx_counter0
	CPI  R26,LOW(0x3)
	BRSH _0x20F
	CPI  R26,LOW(0x2)
	BRLO _0x210
	LDS  R26,_Parameter_Counter
	CPI  R26,LOW(0x2)
	BREQ _0x20F
_0x210:
	RJMP _0x20E
_0x20F:
; 0000 0446             {
; 0000 0447 
; 0000 0448             if(Parameter_Counter<2) Paint_3phase(getchar0(),getchar0(),getchar0());
	LDS  R26,_Parameter_Counter
	CPI  R26,LOW(0x2)
	BRSH _0x213
	CALL SUBOPT_0x68
	CALL _getchar0
	ST   -Y,R30
	RCALL _Paint_3phase
; 0000 0449                 else Paint_2phase(getchar0(),getchar0());
	RJMP _0x214
_0x213:
	CALL SUBOPT_0x68
	RCALL _Paint_2phase
; 0000 044A 
; 0000 044B 
; 0000 044C             }
_0x214:
	RJMP _0x20C
_0x20E:
; 0000 044D             if(tx_counter0==0 && WaitADC_mSec > 400)
_0x20B:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x0)
	BRNE _0x216
	LDS  R26,_WaitADC_mSec
	LDS  R27,_WaitADC_mSec+1
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRSH _0x217
_0x216:
	RJMP _0x215
_0x217:
; 0000 044E             {
; 0000 044F             WaitADC_mSec = 0;
	LDI  R30,LOW(0)
	STS  _WaitADC_mSec,R30
	STS  _WaitADC_mSec+1,R30
; 0000 0450             getclear0();
	CALL _getclear0
; 0000 0451             Cardio_X = Cardio_X_Min;
	LDI  R30,LOW(0)
	STS  _Cardio_X,R30
	STS  _Cardio_X+1,R30
; 0000 0452             switch(Parameter_Counter)
	LDS  R30,_Parameter_Counter
	CALL SUBOPT_0x61
; 0000 0453             {
; 0000 0454                 case 0: putchar0('U'); break;
	BRNE _0x21B
	LDI  R30,LOW(85)
	RJMP _0x23E
; 0000 0455                 case 1: putchar0('I'); break;
_0x21B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x21C
	LDI  R30,LOW(73)
	RJMP _0x23E
; 0000 0456                 case 2: putchar0('Z'); break;
_0x21C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x21A
	LDI  R30,LOW(90)
_0x23E:
	ST   -Y,R30
	CALL _putchar0
; 0000 0457             }
_0x21A:
; 0000 0458             }
; 0000 0459 
; 0000 045A 
; 0000 045B 
; 0000 045C             if (TSC2046_GetCoordinates() > 0)
_0x215:
	CALL _TSC2046_GetCoordinates
	CPI  R30,LOW(0x1)
	BRSH PC+3
	JMP _0x21E
; 0000 045D             {
; 0000 045E               Sleep_mSec = 0;
	CALL SUBOPT_0x69
; 0000 045F               Button_Pressed = GetButton();
; 0000 0460               switch (Button_Pressed)
; 0000 0461               {
; 0000 0462                 case 1 :
	BRNE _0x222
; 0000 0463                   getclear0();
	CALL _getclear0
; 0000 0464                   Parameter_Counter++;
	LDS  R30,_Parameter_Counter
	SUBI R30,-LOW(1)
	STS  _Parameter_Counter,R30
; 0000 0465                   if (Parameter_Counter > 2) Parameter_Counter = 0;
	LDS  R26,_Parameter_Counter
	CPI  R26,LOW(0x3)
	BRLO _0x223
	LDI  R30,LOW(0)
	STS  _Parameter_Counter,R30
; 0000 0466                   PutParameterText(Parameter_Counter, 30, 16, BLUE);
_0x223:
	CALL SUBOPT_0x67
; 0000 0467                 break;
	RJMP _0x221
; 0000 0468                 case 2 :
_0x222:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x224
; 0000 0469                 if(multiplier<200)multiplier+=10;
	LDS  R26,_multiplier
	LDS  R27,_multiplier+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRGE _0x225
	LDS  R30,_multiplier
	LDS  R31,_multiplier+1
	ADIW R30,10
	STS  _multiplier,R30
	STS  _multiplier+1,R31
; 0000 046A 
; 0000 046B                   //if (Parameter_Counter == 0) {if (WorkParameters[Parameter_Counter] > 1) WorkParameters[Parameter_Counter] -= 10;}
; 0000 046C                   //else {if (WorkParameters[Parameter_Counter] < 1000) WorkParameters[Parameter_Counter]++;}
; 0000 046D                 break;
_0x225:
	RJMP _0x221
; 0000 046E                 case 3 :
_0x224:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x226
; 0000 046F                 if(multiplier>20)multiplier-=10;
	LDS  R26,_multiplier
	LDS  R27,_multiplier+1
	SBIW R26,21
	BRLT _0x227
	LDS  R30,_multiplier
	LDS  R31,_multiplier+1
	SBIW R30,10
	STS  _multiplier,R30
	STS  _multiplier+1,R31
; 0000 0470 
; 0000 0471                   //if (Parameter_Counter == 0) {if (WorkParameters[Parameter_Counter] < 1000) WorkParameters[Parameter_Counter] += 10;}
; 0000 0472                   //else {if (WorkParameters[Parameter_Counter] > 1) WorkParameters[Parameter_Counter]--;}
; 0000 0473                 break;
_0x227:
	RJMP _0x221
; 0000 0474                 case 4 :
_0x226:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x221
; 0000 0475                   State = 200;
	LDI  R30,LOW(200)
	STS  _State,R30
; 0000 0476                   Repaint_Button("�����", 4, BLACK, WHITE);
	__POINTW1MN _0x201,42
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
; 0000 0477                   delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x4
; 0000 0478                 break;
; 0000 0479               }
_0x221:
; 0000 047A             }
; 0000 047B           }
_0x21E:
; 0000 047C           break;
	RJMP _0x209
; 0000 047D           case 1 : // ���������
_0x20A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x209
; 0000 047E           {
; 0000 047F           }
; 0000 0480           break;
; 0000 0481           case 200 : // �����
	CPI  R30,LOW(0xC8)
	LDI  R26,HIGH(0xC8)
	CPC  R31,R26
	BRNE _0x22A
; 0000 0482           if (TSC2046_GetCoordinates() > 0)
	CALL _TSC2046_GetCoordinates
	CPI  R30,LOW(0x1)
	BRLO _0x22B
; 0000 0483           {
; 0000 0484             Sleep_mSec = 0;
	CALL SUBOPT_0x69
; 0000 0485             Button_Pressed = GetButton();
; 0000 0486             switch (Button_Pressed)
; 0000 0487             {
; 0000 0488               case 1 :
	BREQ _0x22E
; 0000 0489               break;
; 0000 048A               case 2 :
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x22E
; 0000 048B               break;
; 0000 048C               case 3 :
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ _0x22E
; 0000 048D               break;
; 0000 048E               case 4 :
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x22E
; 0000 048F                 State = 0;
	LDI  R30,LOW(0)
	STS  _State,R30
; 0000 0490                 Repaint_Button("�����", 4, BLACK, WHITE);
	__POINTW1MN _0x201,48
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
; 0000 0491                 delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x4
; 0000 0492               break;
; 0000 0493             }
_0x22E:
; 0000 0494           }
; 0000 0495           break;
_0x22B:
	RJMP _0x209
; 0000 0496           case 250 : // ������ �����
_0x22A:
	CPI  R30,LOW(0xFA)
	LDI  R26,HIGH(0xFA)
	CPC  R31,R26
	BRNE _0x209
; 0000 0497           {
; 0000 0498             if (TSC2046_GetCoordinates() > 0)
	CALL _TSC2046_GetCoordinates
	CPI  R30,LOW(0x1)
	BRLO _0x234
; 0000 0499             {
; 0000 049A               State = 0;
	LDI  R30,LOW(0)
	STS  _State,R30
; 0000 049B               SwitchPORTF(BACKLIGHT, 1);
	CALL SUBOPT_0x62
; 0000 049C             }
; 0000 049D           }
_0x234:
; 0000 049E           break;
; 0000 049F         }
_0x209:
; 0000 04A0 
; 0000 04A1   }
	RJMP _0x204
; 0000 04A2 }
_0x235:
	RJMP _0x235

	.DSEG
_0x201:
	.BYTE 0x36

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_tempX:
	.BYTE 0x4
_tempY:
	.BYTE 0x4
_buffer:
	.BYTE 0x200
_firstDataSector:
	.BYTE 0x4
_rootCluster:
	.BYTE 0x4
_totalClusters:
	.BYTE 0x4
_bytesPerSector:
	.BYTE 0x2
_sectorPerCluster:
	.BYTE 0x2
_reservedSectorCount:
	.BYTE 0x2
_freeClusterCountUpdated:
	.BYTE 0x1
_unusedSectors:
	.BYTE 0x4
_rx_buffer0:
	.BYTE 0xF0
_rx_wr_index0:
	.BYTE 0x1
_rx_rd_index0:
	.BYTE 0x1
_rx_counter0:
	.BYTE 0x1
_tx_buffer0:
	.BYTE 0x8
_tx_wr_index0:
	.BYTE 0x1
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
_rx_buffer1:
	.BYTE 0x20
_rx_wr_index1:
	.BYTE 0x1
_rx_rd_index1:
	.BYTE 0x1
_rx_counter1:
	.BYTE 0x1
_tx_buffer1:
	.BYTE 0x80
_tx_wr_index1:
	.BYTE 0x1
_tx_rd_index1:
	.BYTE 0x1
_tx_counter1:
	.BYTE 0x1
_BTN1_Y_Begin:
	.BYTE 0x2
_BTN1_Y_End:
	.BYTE 0x2
_BTN1_X_Begin:
	.BYTE 0x2
_BTN1_X_End:
	.BYTE 0x2
_BTN2_Y_Begin:
	.BYTE 0x2
_BTN2_Y_End:
	.BYTE 0x2
_BTN2_X_Begin:
	.BYTE 0x2
_BTN2_X_End:
	.BYTE 0x2
_BTN3_Y_Begin:
	.BYTE 0x2
_BTN3_Y_End:
	.BYTE 0x2
_BTN3_X_Begin:
	.BYTE 0x2
_BTN3_X_End:
	.BYTE 0x2
_BTN4_Y_Begin:
	.BYTE 0x2
_BTN4_Y_End:
	.BYTE 0x2
_BTN4_X_Begin:
	.BYTE 0x2
_BTN4_X_End:
	.BYTE 0x2
_Button_Pressed:
	.BYTE 0x1
_mSec:
	.BYTE 0x2
_SD_Ready:
	.BYTE 0x1
_error:
	.BYTE 0x1
_FAT32_active:
	.BYTE 0x1
_LEDGREEN_mSec:
	.BYTE 0x2
_LEDRED_mSec:
	.BYTE 0x2
_LEDBLUE_mSec:
	.BYTE 0x2
_LEDGREEN_max:
	.BYTE 0x2
_LEDRED_max:
	.BYTE 0x2
_LEDBLUE_max:
	.BYTE 0x2
_Pulse_X:
	.BYTE 0x2
_Pulse_Y_Last:
	.BYTE 0x2
_Pulse_mSec:
	.BYTE 0x2
_Pulse_Value:
	.BYTE 0x2
_Pulse_Counter:
	.BYTE 0x2
_Pulse_ScreenValue:
	.BYTE 0x2
_Pulse_Flag:
	.BYTE 0x1
_Pulse_ScreenFlag:
	.BYTE 0x1
_Cardio_X:
	.BYTE 0x2
_Cardio_Y_Last:
	.BYTE 0x2
_Cardio_Divider:
	.BYTE 0x4

	.ESEG
_WorkParameters:
	.DB  LOW(0xA01F4),HIGH(0xA01F4),BYTE3(0xA01F4),BYTE4(0xA01F4)
	.DW  0x12C
_EEPROM_FLAG:
	.BYTE 0x1

	.DSEG
_Parameter_Counter:
	.BYTE 0x1
_Alarm:
	.BYTE 0x1
_Battery_Discharged:
	.BYTE 0x1
_State:
	.BYTE 0x1
_ScanLine_X:
	.BYTE 0x2
_Refresh_mSec:
	.BYTE 0x2
_Sleep_mSec:
	.BYTE 0x2
_Alarm_mSec:
	.BYTE 0x2
_WaitADC_mSec:
	.BYTE 0x2
_ValueLast:
	.BYTE 0x6
_multiplier:
	.BYTE 0x2
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LD   R30,Y
	ST   -Y,R30
	CALL _RotateByte
	OUT  0x1B,R30
	LDI  R30,LOW(0)
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SSD1963_WriteCmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	CALL _SSD1963_WriteData_b8
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _SSD1963_WriteData_b8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	CALL _SSD1963_WriteCmd
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SSD1963_WriteData_b8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	CALL _SSD1963_WriteCmd
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _SSD1963_WriteData_b8

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	CALL _SSD1963_WriteData_b8
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _SSD1963_WriteData_b8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SSD1963_WriteData_b8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	CALL _SSD1963_WriteData_b8
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	CALL _SSD1963_SetArea
	LDI  R30,LOW(44)
	ST   -Y,R30
	JMP  _SSD1963_WriteCmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SSD1963_WriteData_b16

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x10:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x11:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x13:
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,1
	MOVW R16,R30
	TST  R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R30,R16
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x16:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,1
	CLR  R22
	CLR  R23
	__PUTD1S 2
	LDD  R26,Y+5
	TST  R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	MOVW R30,R16
	__GETD2S 2
	CALL __CWD1
	CALL __MULD12
	__PUTD1S 2
	LDI  R30,LOW(0)
	__CLRD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x17
	__GETD2S 6
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	__GETD1S 6
	__SUBD1N -1
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDI  R31,0
	LDD  R26,Y+27
	LDD  R27,Y+27+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	CALL _spi
	__DELAY_USW 400
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R16,R30
	CLR  R17
	MOV  R17,R16
	CLR  R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	LDI  R31,0
	__ADDWRR 16,17,30,31
	SBI  0x3,2
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __DIVF21
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	STS  _tempX,R30
	STS  _tempX+1,R30
	STS  _tempX+2,R30
	STS  _tempX+3,R30
	STS  _tempY,R30
	STS  _tempY+1,R30
	STS  _tempY+2,R30
	STS  _tempY+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x23:
	CALL _TSC2046_getX
	LDS  R26,_tempX
	LDS  R27,_tempX+1
	LDS  R24,_tempX+2
	LDS  R25,_tempX+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _tempX,R30
	STS  _tempX+1,R31
	STS  _tempX+2,R22
	STS  _tempX+3,R23
	CALL _TSC2046_getY
	LDS  R26,_tempY
	LDS  R27,_tempY+1
	LDS  R24,_tempY+2
	LDS  R25,_tempY+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _tempY,R30
	STS  _tempY+1,R31
	STS  _tempY+2,R22
	STS  _tempY+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x24:
	LDS  R26,_tempX
	LDS  R27,_tempX+1
	LDS  R24,_tempX+2
	LDS  R25,_tempX+3
	__GETD1N 0x10
	CALL __DIVD21
	MOVW R6,R30
	LDS  R26,_tempY
	LDS  R27,_tempY+1
	LDS  R24,_tempY+2
	LDS  R25,_tempY+3
	__GETD1N 0x10
	CALL __DIVD21
	MOVW R8,R30
	JMP  _TSC2046_Stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R22,R26
	LD   R1,X
	LDD  R30,Y+1
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SwitchPORTF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SwitchPORTF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SwitchPORTF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _SwitchPORTF

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	LDS  R30,_BTN1_X_Begin
	LDS  R31,_BTN1_X_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDS  R30,_BTN1_X_End
	LDS  R31,_BTN1_X_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	LDS  R30,_BTN1_Y_Begin
	LDS  R31,_BTN1_Y_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDS  R30,_BTN1_Y_End
	LDS  R31,_BTN1_Y_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	LDS  R30,_BTN2_X_Begin
	LDS  R31,_BTN2_X_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDS  R30,_BTN2_X_End
	LDS  R31,_BTN2_X_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	LDS  R30,_BTN2_Y_Begin
	LDS  R31,_BTN2_Y_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDS  R30,_BTN2_Y_End
	LDS  R31,_BTN2_Y_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	LDS  R30,_BTN3_X_Begin
	LDS  R31,_BTN3_X_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDS  R30,_BTN3_X_End
	LDS  R31,_BTN3_X_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	LDS  R30,_BTN3_Y_Begin
	LDS  R31,_BTN3_Y_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDS  R30,_BTN3_Y_End
	LDS  R31,_BTN3_Y_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	LDS  R30,_BTN4_X_Begin
	LDS  R31,_BTN4_X_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDS  R30,_BTN4_X_End
	LDS  R31,_BTN4_X_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDS  R30,_BTN4_Y_Begin
	LDS  R31,_BTN4_Y_Begin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	LDS  R30,_BTN4_Y_End
	LDS  R31,_BTN4_Y_End+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3F:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x40:
	ADIW R30,15
	SBIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	CALL _SSD1963_PutString16
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x42:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x32
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x36
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x44:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x3A
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x45:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SSD1963_DrawFillRect

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x46:
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Repaint_Button

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4A:
	SBIW R28,13
	LDI  R30,LOW(7)
	STD  Y+1,R30
	LDI  R30,LOW(224)
	STD  Y+2,R30
	LDI  R30,LOW(7)
	STD  Y+3,R30
	LDI  R30,LOW(255)
	STD  Y+4,R30
	LDI  R30,LOW(0)
	STD  Y+5,R30
	LDI  R30,LOW(31)
	STD  Y+6,R30
	CALL __SAVELOCR6
	__POINTW2MN _WorkParameters,2
	CALL __EEPROMRDW
	MOVW R16,R30
	__GETWRN 18,19,141
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:127 WORDS
SUBOPT_0x4B:
	LDS  R30,_Cardio_X
	LDS  R31,_Cardio_X+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	LDS  R26,_Cardio_X
	LDS  R27,_Cardio_X+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(233)
	LDI  R31,HIGH(233)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(8456)
	LDI  R31,HIGH(8456)
	ST   -Y,R31
	ST   -Y,R30
	CALL _SSD1963_DrawFastLine
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8456)
	LDI  R31,HIGH(8456)
	ST   -Y,R31
	ST   -Y,R30
	CALL _SSD1963_DrawFastLine
	LDI  R30,LOW(0)
	STD  Y+6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:129 WORDS
SUBOPT_0x4F:
	LDD  R30,Y+6
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,13
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x50:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	SUBI R30,LOW(128)
	SBCI R31,HIGH(128)
	ST   -X,R31
	ST   -X,R30
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x52:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R30
	CALL __GETW1P
	LDS  R26,_multiplier
	LDS  R27,_multiplier+1
	CALL __MULW12
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	CALL __ASRW3
	CALL __ASRW4
	ST   -X,R31
	ST   -X,R30
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x54:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(231)
	LDI  R31,HIGH(231)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
	LDD  R30,Y+10
	LDI  R26,LOW(_ValueLast)
	LDI  R27,HIGH(_ValueLast)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x58:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,19
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x59:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+14
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,15
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5A:
	CALL _SSD1963_DrawLine
	LDD  R30,Y+6
	LDI  R26,LOW(_ValueLast)
	LDI  R27,HIGH(_ValueLast)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5B:
	MOVW R30,R16
	LDS  R26,_Cardio_X
	LDS  R27,_Cardio_X+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _Cardio_X,R30
	STS  _Cardio_X+1,R31
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	SUB  R30,R16
	SBC  R31,R17
	LDS  R26,_Cardio_X
	LDS  R27,_Cardio_X+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5C:
	LDS  R30,_Cardio_X
	LDS  R31,_Cardio_X+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5D:
	CALL _SSD1963_DrawFillRect
	LDI  R30,LOW(0)
	STS  _Cardio_X,R30
	STS  _Cardio_X+1,R30
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5E:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	MOVW R30,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5F:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x60:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SwitchPORTF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x63:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x64:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7936)
	LDI  R31,HIGH(7936)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x66:
	CALL _SSD1963_PutString16
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x67:
	LDS  R30,_Parameter_Counter
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _PutParameterText

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	CALL _getchar0
	ST   -Y,R30
	CALL _getchar0
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x69:
	LDI  R30,LOW(0)
	STS  _Sleep_mSec,R30
	STS  _Sleep_mSec+1,R30
	CALL _GetButton
	STS  _Button_Pressed,R30
	RJMP SUBOPT_0x3E


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,53
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
