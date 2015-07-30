
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _adc_temp=R6
	.DEF _adc_rd_input=R9
	.DEF _adc_wr_input=R8
	.DEF _adc_wr_index=R11
	.DEF _adc_rd_index=R10
	.DEF _isFregUpd=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x4B:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  0x0D
	.DW  _0x4B*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 28.07.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
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
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 4
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 004D {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004E char status,data;
; 0000 004F status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0050 data=UDR;
	IN   R16,12
; 0000 0051 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0052    {
; 0000 0053    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0054 #if RX_BUFFER_SIZE == 256
; 0000 0055    // special case for receiver buffer size=256
; 0000 0056    if (++rx_counter == 0)
; 0000 0057       {
; 0000 0058 #else
; 0000 0059    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 005A    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0x5
; 0000 005B       {
; 0000 005C       rx_counter=0;
	CLR  R7
; 0000 005D #endif
; 0000 005E       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 005F       }
; 0000 0060    }
_0x5:
; 0000 0061 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0068 {
_getchar:
; 0000 0069 char data;
; 0000 006A while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 006B data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 006C #if RX_BUFFER_SIZE != 256
; 0000 006D if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 006E #endif
; 0000 006F #asm("cli")
_0x9:
	cli
; 0000 0070 --rx_counter;
	DEC  R7
; 0000 0071 #asm("sei")
	sei
; 0000 0072 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0073 }
;#pragma used-
;#endif
;/*
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 128
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
;{
;if (tx_counter)
;   {
;   --tx_counter;
;   UDR=tx_buffer[tx_rd_index++];
;#if TX_BUFFER_SIZE != 256
;   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
;#endif
;   }
;}
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
;{
;while (tx_counter == TX_BUFFER_SIZE);
;#asm("cli")
;if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
;   {
;   tx_buffer[tx_wr_index++]=c;
;#if TX_BUFFER_SIZE != 256
;   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
;#endif
;   ++tx_counter;
;   }
;else
;   UDR=c;
;#asm("sei")
;}
;#pragma used-
;#endif
;*/
;// Standard Input/Output functions
;//#include <stdio.h>
;
;#define _ALTERNATE_PUTCHAR_
;void putchar(char c)
; 0000 00AA {
_putchar:
; 0000 00AB     // Wait for empty transmit buffer
; 0000 00AC     while ( !(UCSRA & DATA_REGISTER_EMPTY) );
;	c -> Y+0
_0xA:
	SBIS 0xB,5
	RJMP _0xA
; 0000 00AD     // Start transmission
; 0000 00AE     UDR = c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00AF }
	ADIW R28,1
	RET
;
;#define MIGMIG PORTB.5
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00B6 {
_timer0_ovf_isr:
	ST   -Y,R30
; 0000 00B7 // Reinitialize Timer 0 value
; 0000 00B8 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00B9 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00BA }
	LD   R30,Y+
	RETI
;
;#define FIRST_U_ADC_INPUT 5
;#define FIRST_I_ADC_INPUT 1
;#define ZU_ADC_INPUT 4
;#define ZI_ADC_INPUT 0
;#define FREQUENCY_ADC_INPUT 6
;#define ADC_BUF_SIZE 62 //На 64 глючит
;#define ADC_VREF_TYPE 0x00
;
;unsigned char adc_data[8][ADC_BUF_SIZE];
;unsigned long adc_current[8], adc_real[8];
;unsigned char adc_count[8], s_val[8];
;unsigned char adc_temp;
;unsigned char adc_rd_input, adc_wr_input, adc_wr_index, adc_rd_index;
;unsigned char isRising[8] = {0,0,0,0,0,0,0,0}, isUpdate[8] = {0,0,0,0,0,0,0,0}, isFregUpd = 0;
;unsigned char valClear[9] = {0,0,0,0,0,0,0,0,0};
;unsigned int last_time = 0;
;unsigned int freg = 0;
;
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00D1 {
_timer2_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D2 // Reinitialize Timer2 value
; 0000 00D3 TCNT2=0x06;
	LDI  R30,LOW(6)
	OUT  0x24,R30
; 0000 00D4 // Очищаем значения, если ничего не происходит больше 250 мс
; 0000 00D5 {
; 0000 00D6 valClear[0]++;
	LDS  R30,_valClear
	SUBI R30,-LOW(1)
	STS  _valClear,R30
; 0000 00D7 valClear[1]++;
	__GETB1MN _valClear,1
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,1
; 0000 00D8 valClear[2]++;
	__GETB1MN _valClear,2
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,2
; 0000 00D9 valClear[3]++;
	__GETB1MN _valClear,3
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,3
; 0000 00DA valClear[4]++;
	__GETB1MN _valClear,4
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,4
; 0000 00DB valClear[5]++;
	__GETB1MN _valClear,5
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,5
; 0000 00DC valClear[6]++;
	__GETB1MN _valClear,6
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,6
; 0000 00DD valClear[7]++;
	__GETB1MN _valClear,7
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,7
; 0000 00DE valClear[8]++;
	__GETB1MN _valClear,8
	SUBI R30,-LOW(1)
	__PUTB1MN _valClear,8
; 0000 00DF }
; 0000 00E0 
; 0000 00E1 if(adc_rd_input == 0)
	TST  R9
	BRNE _0xD
; 0000 00E2 {
; 0000 00E3      TCNT0=0xEC; //10us
	LDI  R30,LOW(236)
	OUT  0x32,R30
; 0000 00E4      TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 00E5      MIGMIG ^= 1;
	LDI  R26,0
	SBIC 0x18,5
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0xE
	CBI  0x18,5
	RJMP _0xF
_0xE:
	SBI  0x18,5
_0xF:
; 0000 00E6 }
; 0000 00E7 }
_0xD:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 00ED {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
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
; 0000 00EE // Read the AD conversion result
; 0000 00EF     adc_temp = ADCW>>2;
	IN   R30,0x4
	IN   R31,0x4+1
	CALL __LSRW2
	MOV  R6,R30
; 0000 00F0 // Select next ADC input
; 0000 00F1     adc_rd_input = adc_wr_input + 1;
	MOV  R30,R8
	SUBI R30,-LOW(1)
	MOV  R9,R30
; 0000 00F2     if(adc_rd_input > 7) adc_rd_input = 0;
	LDI  R30,LOW(7)
	CP   R30,R9
	BRSH _0x10
	CLR  R9
; 0000 00F3     ADMUX=(ADC_VREF_TYPE & 0xff) | adc_rd_input;
_0x10:
	MOV  R30,R9
	OUT  0x7,R30
; 0000 00F4 // Delay needed for the stabilization of the ADC input voltage
; 0000 00F5     if(adc_rd_input)
	TST  R9
	BREQ _0x11
; 0000 00F6     {
; 0000 00F7       TCNT0=0xEC;  //10us
	LDI  R30,LOW(236)
	OUT  0x32,R30
; 0000 00F8       TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 00F9     }
; 0000 00FA 
; 0000 00FB adc_data[adc_wr_input][adc_wr_index] = adc_temp;
_0x11:
	MOV  R30,R8
	LDI  R26,LOW(62)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_adc_data)
	SBCI R31,HIGH(-_adc_data)
	MOVW R26,R30
	MOV  R30,R11
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R6
; 0000 00FC 
; 0000 00FD if(adc_temp & 0x80)
	SBRS R6,7
	RJMP _0x12
; 0000 00FE {
; 0000 00FF   if(!isRising[adc_wr_input])
	RCALL SUBOPT_0x0
	LD   R30,Z
	CPI  R30,0
	BRNE _0x13
; 0000 0100   {
; 0000 0101     //Нарастающий
; 0000 0102     if(adc_wr_input == FREQUENCY_ADC_INPUT)
	LDI  R30,LOW(6)
	CP   R30,R8
	BRNE _0x14
; 0000 0103     {
; 0000 0104         last_time = TCNT1;
	IN   R30,0x2C
	IN   R31,0x2C+1
	STS  _last_time,R30
	STS  _last_time+1,R31
; 0000 0105         TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0106         TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0107         isFregUpd = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0108     }
; 0000 0109     adc_real[adc_wr_input] =  adc_current[adc_wr_input];
_0x14:
	MOV  R30,R8
	RCALL SUBOPT_0x1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RCALL SUBOPT_0x2
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
; 0000 010A     adc_current[adc_wr_input] = 0;
	RCALL SUBOPT_0x2
	__GETD1N 0x0
	CALL __PUTDP1
; 0000 010B     isRising[adc_wr_input] = 1;
	RCALL SUBOPT_0x0
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 010C     isUpdate[adc_wr_input] = adc_count[adc_wr_input];
	MOV  R26,R8
	LDI  R27,0
	SUBI R26,LOW(-_isUpdate)
	SBCI R27,HIGH(-_isUpdate)
	RCALL SUBOPT_0x3
	LD   R30,Z
	ST   X,R30
; 0000 010D     adc_count[adc_wr_input] = 0;
	RCALL SUBOPT_0x3
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 010E   }
; 0000 010F }
_0x13:
; 0000 0110 else
	RJMP _0x15
_0x12:
; 0000 0111 {
; 0000 0112   if(adc_temp < 120) isRising[adc_wr_input] = 0;
	LDI  R30,LOW(120)
	CP   R6,R30
	BRSH _0x16
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0113   adc_temp = 127 - adc_temp;
_0x16:
	MOV  R30,R6
	LDI  R31,0
	LDI  R26,LOW(127)
	LDI  R27,HIGH(127)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R6,R30
; 0000 0114 }
_0x15:
; 0000 0115 
; 0000 0116 adc_temp &= 0x7F;
	LDI  R30,LOW(127)
	AND  R6,R30
; 0000 0117 adc_current[adc_wr_input] += adc_temp * adc_temp;
	MOV  R30,R8
	LDI  R26,LOW(_adc_current)
	LDI  R27,HIGH(_adc_current)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R26,R6
	CLR  R27
	MOV  R30,R6
	LDI  R31,0
	CALL __MULW12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CWD1
	CALL __ADDD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 0118 adc_count[adc_wr_input]++;
	MOV  R26,R8
	LDI  R27,0
	SUBI R26,LOW(-_adc_count)
	SBCI R27,HIGH(-_adc_count)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0119 
; 0000 011A // Select next ADC input
; 0000 011B if (++adc_wr_input > 7)
	INC  R8
	LDI  R30,LOW(7)
	CP   R30,R8
	BRSH _0x17
; 0000 011C {
; 0000 011D     adc_wr_input = 0;
	CLR  R8
; 0000 011E     if(++adc_wr_index >= ADC_BUF_SIZE) adc_wr_index = 0;
	INC  R11
	LDI  R30,LOW(62)
	CP   R11,R30
	BRLO _0x18
	CLR  R11
; 0000 011F 	if(adc_wr_index == adc_rd_index)
_0x18:
	CP   R10,R11
	BRNE _0x19
; 0000 0120 	{
; 0000 0121 		if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
	INC  R10
	LDI  R30,LOW(62)
	CP   R10,R30
	BRLO _0x1A
	CLR  R10
; 0000 0122 	}
_0x1A:
; 0000 0123 }
_0x19:
; 0000 0124 }
_0x17:
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
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;unsigned char isqrt( unsigned int from)
; 0000 0127 {
_isqrt:
; 0000 0128      unsigned int mask = 0x4000, sqr = 0, temp;
; 0000 0129      do
	CALL __SAVELOCR6
;	from -> Y+6
;	mask -> R16,R17
;	sqr -> R18,R19
;	temp -> R20,R21
	__GETWRN 16,17,16384
	__GETWRN 18,19,0
_0x1C:
; 0000 012A      {
; 0000 012B          temp = sqr | mask;
	MOVW R30,R16
	OR   R30,R18
	OR   R31,R19
	MOVW R20,R30
; 0000 012C          sqr >>= 1;
	LSR  R19
	ROR  R18
; 0000 012D          if( temp <= from ) {
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R30,R20
	CPC  R31,R21
	BRLO _0x1E
; 0000 012E              sqr |= mask;
	__ORWRR 18,19,16,17
; 0000 012F              from -= temp;
	SUB  R30,R20
	SBC  R31,R21
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0130          }
; 0000 0131      } while( mask >>= 2 );
_0x1E:
	MOVW R30,R16
	CALL __LSRW2
	MOVW R16,R30
	SBIW R30,0
	BRNE _0x1C
; 0000 0132      //округление
; 0000 0133      if( sqr < from ) ++sqr;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x1F
	__ADDWRN 18,19,1
; 0000 0134      return (unsigned char)sqr;
_0x1F:
	MOV  R30,R18
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 0135 }
;
;inline void main_loop()
; 0000 0138 {
_main_loop:
; 0000 0139     char i, j;
; 0000 013A     unsigned int s_tval;
; 0000 013B     for(i=0; i<8; i++)
	CALL __SAVELOCR4
;	i -> R17
;	j -> R16
;	s_tval -> R18,R19
	LDI  R17,LOW(0)
_0x21:
	CPI  R17,8
	BRLO PC+3
	JMP _0x22
; 0000 013C     {
; 0000 013D         if(isUpdate[i])
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_isUpdate)
	SBCI R31,HIGH(-_isUpdate)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x23
; 0000 013E         {
; 0000 013F             valClear[i] = 0;
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_valClear)
	SBCI R31,HIGH(-_valClear)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0140             s_tval = adc_real[i]/isUpdate[i];
	MOV  R30,R17
	RCALL SUBOPT_0x1
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_isUpdate)
	SBCI R31,HIGH(-_isUpdate)
	LD   R30,Z
	LDI  R31,0
	CALL __CWD1
	CALL __DIVD21U
	MOVW R18,R30
; 0000 0141             isUpdate[i] = 0;
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_isUpdate)
	SBCI R31,HIGH(-_isUpdate)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0142             s_val[i] = isqrt(s_tval);
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_s_val)
	SBCI R31,HIGH(-_s_val)
	PUSH R31
	PUSH R30
	ST   -Y,R19
	ST   -Y,R18
	RCALL _isqrt
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0143         }
; 0000 0144         if(valClear[i] > 250)
_0x23:
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_valClear)
	SBCI R31,HIGH(-_valClear)
	LD   R26,Z
	CPI  R26,LOW(0xFB)
	BRLO _0x24
; 0000 0145         {
; 0000 0146             valClear[i] = 0;
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_valClear)
	SBCI R31,HIGH(-_valClear)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0147             s_val[i] = 0;
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_s_val)
	SBCI R31,HIGH(-_s_val)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0148         }
; 0000 0149     }
_0x24:
	SUBI R17,-1
	RJMP _0x21
_0x22:
; 0000 014A     if(isFregUpd)
	TST  R13
	BREQ _0x25
; 0000 014B     {
; 0000 014C       valClear[8] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _valClear,8
; 0000 014D       // Период в тиках 62,500 kHz
; 0000 014E       freg = 62500 / last_time;
	LDS  R30,_last_time
	LDS  R31,_last_time+1
	LDI  R26,LOW(62500)
	LDI  R27,HIGH(62500)
	CALL __DIVW21U
	STS  _freg,R30
	STS  _freg+1,R31
; 0000 014F       isFregUpd = 0;
	CLR  R13
; 0000 0150     }
; 0000 0151     if(valClear[8] > 250)
_0x25:
	__GETB2MN _valClear,8
	CPI  R26,LOW(0xFB)
	BRLO _0x26
; 0000 0152     {
; 0000 0153         valClear[8] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _valClear,8
; 0000 0154         freg = 0;
	STS  _freg,R30
	STS  _freg+1,R30
; 0000 0155     }
; 0000 0156 
; 0000 0157     if(rx_counter)
_0x26:
	TST  R7
	BRNE PC+3
	JMP _0x27
; 0000 0158     {
; 0000 0159         switch(getchar())
	RCALL _getchar
; 0000 015A         {
; 0000 015B             case 'U':
	CPI  R30,LOW(0x55)
	BRNE _0x2B
; 0000 015C                 j = FIRST_U_ADC_INPUT + 3;
	LDI  R16,LOW(8)
; 0000 015D                 while(adc_rd_index != adc_wr_index)
_0x2C:
	CP   R11,R10
	BREQ _0x2E
; 0000 015E                 {
; 0000 015F                         for(i=FIRST_U_ADC_INPUT; i<j; i++)
	LDI  R17,LOW(5)
_0x30:
	CP   R17,R16
	BRSH _0x31
; 0000 0160                         {
; 0000 0161                             putchar(adc_data[i][adc_rd_index]);
	RCALL SUBOPT_0x5
; 0000 0162                         }
	SUBI R17,-1
	RJMP _0x30
_0x31:
; 0000 0163                         #asm("wdr")
	wdr
; 0000 0164                     if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
	INC  R10
	LDI  R30,LOW(62)
	CP   R10,R30
	BRLO _0x32
	CLR  R10
; 0000 0165                 }
_0x32:
	RJMP _0x2C
_0x2E:
; 0000 0166             break;
	RJMP _0x2A
; 0000 0167             case 'I':
_0x2B:
	CPI  R30,LOW(0x49)
	BRNE _0x33
; 0000 0168                 j = FIRST_I_ADC_INPUT + 3;
	LDI  R16,LOW(4)
; 0000 0169                 while(adc_rd_index != adc_wr_index)
_0x34:
	CP   R11,R10
	BREQ _0x36
; 0000 016A                 {
; 0000 016B                         for(i=FIRST_I_ADC_INPUT; i<j; i++)
	LDI  R17,LOW(1)
_0x38:
	CP   R17,R16
	BRSH _0x39
; 0000 016C                         {
; 0000 016D                             putchar(adc_data[i][adc_rd_index]);
	RCALL SUBOPT_0x5
; 0000 016E                         }
	SUBI R17,-1
	RJMP _0x38
_0x39:
; 0000 016F                         #asm("wdr")
	wdr
; 0000 0170                     if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
	INC  R10
	LDI  R30,LOW(62)
	CP   R10,R30
	BRLO _0x3A
	CLR  R10
; 0000 0171                 }
_0x3A:
	RJMP _0x34
_0x36:
; 0000 0172             break;
	RJMP _0x2A
; 0000 0173             case 'Z':
_0x33:
	CPI  R30,LOW(0x5A)
	BRNE _0x3B
; 0000 0174                 while(adc_rd_index != adc_wr_index)
_0x3C:
	CP   R11,R10
	BREQ _0x3E
; 0000 0175                 {
; 0000 0176                     putchar(adc_data[ZU_ADC_INPUT][adc_rd_index]);
	__POINTW2MN _adc_data,248
	CLR  R30
	ADD  R26,R10
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	RCALL _putchar
; 0000 0177                     putchar(adc_data[ZI_ADC_INPUT][adc_rd_index]);
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_adc_data)
	SBCI R31,HIGH(-_adc_data)
	RCALL SUBOPT_0x6
; 0000 0178                     #asm("wdr")
	wdr
; 0000 0179                     if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
	INC  R10
	LDI  R30,LOW(62)
	CP   R10,R30
	BRLO _0x3F
	CLR  R10
; 0000 017A                 }
_0x3F:
	RJMP _0x3C
_0x3E:
; 0000 017B             break;
	RJMP _0x2A
; 0000 017C             case 'S':
_0x3B:
	CPI  R30,LOW(0x53)
	BRNE _0x2A
; 0000 017D                 // Частота Гц
; 0000 017E                 putchar(freg & 0xFF);
	LDS  R30,_freg
	ST   -Y,R30
	RCALL _putchar
; 0000 017F                 // Среднеквадратичные U
; 0000 0180 				        j = FIRST_U_ADC_INPUT + 3;
	LDI  R16,LOW(8)
; 0000 0181                 for(i=FIRST_U_ADC_INPUT; i<j; i++)
	LDI  R17,LOW(5)
_0x42:
	CP   R17,R16
	BRSH _0x43
; 0000 0182                 {
; 0000 0183                     putchar(s_val[i]);
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_s_val)
	SBCI R31,HIGH(-_s_val)
	RCALL SUBOPT_0x6
; 0000 0184                 }
	SUBI R17,-1
	RJMP _0x42
_0x43:
; 0000 0185                 // Среднеквадратичные I
; 0000 0186 				        j = FIRST_I_ADC_INPUT + 3;
	LDI  R16,LOW(4)
; 0000 0187                 for(i=FIRST_I_ADC_INPUT; i<j; i++)
	LDI  R17,LOW(1)
_0x45:
	CP   R17,R16
	BRSH _0x46
; 0000 0188 				        {
; 0000 0189 					          putchar(s_val[i]);
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_s_val)
	SBCI R31,HIGH(-_s_val)
	RCALL SUBOPT_0x6
; 0000 018A 				        }
	SUBI R17,-1
	RJMP _0x45
_0x46:
; 0000 018B                 // Среднеквадратичные ZUI
; 0000 018C 				        putchar(s_val[ZU_ADC_INPUT]);
	__GETB1MN _s_val,4
	ST   -Y,R30
	RCALL _putchar
; 0000 018D                 putchar(s_val[ZI_ADC_INPUT]);
	LDS  R30,_s_val
	ST   -Y,R30
	RCALL _putchar
; 0000 018E             break;
; 0000 018F         }
_0x2A:
; 0000 0190     }
; 0000 0191 }
_0x27:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 0197 {
_main:
; 0000 0198 // Declare your local variables here
; 0000 0199 
; 0000 019A // Input/Output Ports initialization
; 0000 019B // Port A initialization
; 0000 019C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 019D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 019E PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 019F DDRA=0x00;
	OUT  0x1A,R30
; 0000 01A0 
; 0000 01A1 // Port B initialization
; 0000 01A2 // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01A3 // State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T
; 0000 01A4 PORTB=0x00;
	OUT  0x18,R30
; 0000 01A5 DDRB=0x20;
	LDI  R30,LOW(32)
	OUT  0x17,R30
; 0000 01A6 
; 0000 01A7 // Port C initialization
; 0000 01A8 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01A9 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01AA PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01AB DDRC=0x00;
	OUT  0x14,R30
; 0000 01AC 
; 0000 01AD // Port D initialization
; 0000 01AE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01AF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01B0 PORTD=0x00;
	OUT  0x12,R30
; 0000 01B1 DDRD=0x00;
	OUT  0x11,R30
; 0000 01B2 
; 0000 01B3 // Timer/Counter 0 initialization
; 0000 01B4 // Clock source: System Clock
; 0000 01B5 // Clock value: 2000,000 kHz
; 0000 01B6 // Mode: Normal top=0xFF
; 0000 01B7 // OC0 output: Disconnected
; 0000 01B8 //TCCR0=0x02;
; 0000 01B9 TCNT0=0xE2;
	LDI  R30,LOW(226)
	OUT  0x32,R30
; 0000 01BA OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 01BB 
; 0000 01BC // Timer/Counter 1 initialization
; 0000 01BD // Clock source: System Clock
; 0000 01BE // Clock value: 62,500 kHz
; 0000 01BF // Mode: Normal top=0xFFFF
; 0000 01C0 // OC1A output: Discon.
; 0000 01C1 // OC1B output: Discon.
; 0000 01C2 // Noise Canceler: Off
; 0000 01C3 // Input Capture on Falling Edge
; 0000 01C4 // Timer1 Overflow Interrupt: Off
; 0000 01C5 // Input Capture Interrupt: Off
; 0000 01C6 // Compare A Match Interrupt: Off
; 0000 01C7 // Compare B Match Interrupt: Off
; 0000 01C8 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01C9 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 01CA TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01CB TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01CC ICR1H=0x00;
	OUT  0x27,R30
; 0000 01CD ICR1L=0x00;
	OUT  0x26,R30
; 0000 01CE OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01CF OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01D0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01D1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01D2 
; 0000 01D3 // Timer/Counter 2 initialization
; 0000 01D4 // Clock source: System Clock
; 0000 01D5 // Clock value: 250,000 kHz
; 0000 01D6 // Mode: Normal top=0xFF
; 0000 01D7 // OC2 output: Disconnected
; 0000 01D8 ASSR=0x00;
	OUT  0x22,R30
; 0000 01D9 TCCR2=0x04;
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 01DA TCNT2=0x06;
	LDI  R30,LOW(6)
	OUT  0x24,R30
; 0000 01DB OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 01DC 
; 0000 01DD // External Interrupt(s) initialization
; 0000 01DE // INT0: Off
; 0000 01DF // INT1: Off
; 0000 01E0 // INT2: Off
; 0000 01E1 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01E2 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01E3 
; 0000 01E4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01E5 TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 01E6 
; 0000 01E7 // USART initialization
; 0000 01E8 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01E9 // USART Receiver: On
; 0000 01EA // USART Transmitter: On
; 0000 01EB // USART Mode: Asynchronous
; 0000 01EC // USART Baud Rate: 115200
; 0000 01ED UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01EE UCSRB=0xD8;
	LDI  R30,LOW(216)
	RCALL SUBOPT_0x7
; 0000 01EF UCSRC=0x86;
; 0000 01F0 UBRRH=0x00;
; 0000 01F1 UBRRL=0x08;
; 0000 01F2 
; 0000 01F3 // USART initialization  // Без ТХ прерывания
; 0000 01F4 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01F5 // USART Receiver: On
; 0000 01F6 // USART Transmitter: On
; 0000 01F7 // USART Mode: Asynchronous
; 0000 01F8 // USART Baud Rate: 115200
; 0000 01F9 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01FA UCSRB=0x98;
	LDI  R30,LOW(152)
	RCALL SUBOPT_0x7
; 0000 01FB UCSRC=0x86;
; 0000 01FC UBRRH=0x00;
; 0000 01FD UBRRL=0x08;
; 0000 01FE 
; 0000 01FF // Analog Comparator initialization
; 0000 0200 // Analog Comparator: Off
; 0000 0201 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0202 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0203 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0204 
; 0000 0205 // ADC initialization
; 0000 0206 // ADC Clock frequency: 250,000 kHz
; 0000 0207 // ADC Voltage Reference: AREF pin
; 0000 0208 // ADC Auto Trigger Source: Timer0 Overflow
; 0000 0209 ADMUX=(ADC_VREF_TYPE & 0xff);
	OUT  0x7,R30
; 0000 020A ADCSRA=0xAE;
	LDI  R30,LOW(174)
	RCALL SUBOPT_0x8
; 0000 020B SFIOR&=0x1F;
; 0000 020C SFIOR|=0x80;
; 0000 020D 
; 0000 020E // ADC initialization // На штатной частоте
; 0000 020F // ADC Clock frequency: 125,000 kHz
; 0000 0210 // ADC Voltage Reference: AREF pin
; 0000 0211 // ADC Auto Trigger Source: Timer0 Overflow
; 0000 0212 ADMUX= (ADC_VREF_TYPE & 0xff);
	OUT  0x7,R30
; 0000 0213 ADCSRA=0xAF;
	LDI  R30,LOW(175)
	RCALL SUBOPT_0x8
; 0000 0214 SFIOR&=0x1F;
; 0000 0215 SFIOR|=0x80;
; 0000 0216 
; 0000 0217 // SPI initialization
; 0000 0218 // SPI disabled
; 0000 0219 SPCR=0x00;
	OUT  0xD,R30
; 0000 021A 
; 0000 021B // TWI initialization
; 0000 021C // TWI disabled
; 0000 021D TWCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x36,R30
; 0000 021E 
; 0000 021F // Watchdog Timer initialization
; 0000 0220 // Watchdog Timer Prescaler: OSC/256k
; 0000 0221 #pragma optsize-
; 0000 0222 WDTCR=0x1C;
	LDI  R30,LOW(28)
	OUT  0x21,R30
; 0000 0223 WDTCR=0x0C;
	LDI  R30,LOW(12)
	OUT  0x21,R30
; 0000 0224 #ifdef _OPTIMIZE_SIZE_
; 0000 0225 #pragma optsize+
; 0000 0226 #endif
; 0000 0227 
; 0000 0228 // Global enable interrupts
; 0000 0229 #asm("sei")
	sei
; 0000 022A 
; 0000 022B while (1)
_0x47:
; 0000 022C       {
; 0000 022D       #asm("wdr")
	wdr
; 0000 022E       main_loop();
	RCALL _main_loop
; 0000 022F       }
	RJMP _0x47
; 0000 0230 }
_0x4A:
	RJMP _0x4A

	.DSEG
_rx_buffer:
	.BYTE 0x4
_adc_data:
	.BYTE 0x1F0
_adc_current:
	.BYTE 0x20
_adc_real:
	.BYTE 0x20
_adc_count:
	.BYTE 0x8
_s_val:
	.BYTE 0x8
_isRising:
	.BYTE 0x8
_isUpdate:
	.BYTE 0x8
_valClear:
	.BYTE 0x9
_last_time:
	.BYTE 0x2
_freg:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_isRising)
	SBCI R31,HIGH(-_isRising)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_adc_real)
	LDI  R27,HIGH(_adc_real)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	MOV  R30,R8
	LDI  R26,LOW(_adc_current)
	LDI  R27,HIGH(_adc_current)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_adc_count)
	SBCI R31,HIGH(-_adc_count)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(62)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_adc_data)
	SBCI R31,HIGH(-_adc_data)
	MOVW R26,R30
	CLR  R30
	ADD  R26,R10
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LD   R30,Z
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	OUT  0xA,R30
	LDI  R30,LOW(134)
	OUT  0x20,R30
	LDI  R30,LOW(0)
	OUT  0x20,R30
	LDI  R30,LOW(8)
	OUT  0x9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	OUT  0x6,R30
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
	IN   R30,0x30
	ORI  R30,0x80
	OUT  0x30,R30
	LDI  R30,LOW(0)
	RET


	.CSEG
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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
