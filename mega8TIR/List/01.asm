
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
	.DEF _uart_timeout=R5
	.DEF _rx_wr_index=R4
	.DEF _rx_rd_index=R7
	.DEF _rx_counter=R6
	.DEF _tx_wr_index=R9
	.DEF _tx_rd_index=R8
	.DEF _tx_counter=R11
	.DEF _test=R10
	.DEF _index=R13
	.DEF _tValA=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x14:
	.DB  0x0,0x0,0x20,0x4E,0x20,0x4E,0x20,0x4E
_0x15:
	.DB  0xA,0x0,0xA,0x0,0xA,0x0,0xA
_0x55:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  _regVal
	.DW  _0x14*2

	.DW  0x07
	.DW  _stepVal
	.DW  _0x15*2

	.DW  0x09
	.DW  0x05
	.DW  _0x55*2

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
;Date    : 19.09.2015
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
;
;char uart_timeout=0;
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 32
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
; 0000 004F {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0050 char status,data;
; 0000 0051 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0052 data=UDR;
	IN   R16,12
; 0000 0053 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0054    {
; 0000 0055    uart_timeout = 0;
	CLR  R5
; 0000 0056    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0057 #if RX_BUFFER_SIZE == 256
; 0000 0058    // special case for receiver buffer size=256
; 0000 0059    if (++rx_counter == 0)
; 0000 005A       {
; 0000 005B #else
; 0000 005C    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(32)
	CP   R30,R4
	BRNE _0x4
	CLR  R4
; 0000 005D    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R6
	LDI  R30,LOW(32)
	CP   R30,R6
	BRNE _0x5
; 0000 005E       {
; 0000 005F       rx_counter=0;
	CLR  R6
; 0000 0060 #endif
; 0000 0061       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0062       }
; 0000 0063    }
_0x5:
; 0000 0064 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x54
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006B {
_getchar:
; 0000 006C char data;
; 0000 006D while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R6
	BREQ _0x6
; 0000 006E data=rx_buffer[rx_rd_index++];
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 006F #if RX_BUFFER_SIZE != 256
; 0000 0070 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(32)
	CP   R30,R7
	BRNE _0x9
	CLR  R7
; 0000 0071 #endif
; 0000 0072 #asm("cli")
_0x9:
	cli
; 0000 0073 --rx_counter;
	DEC  R6
; 0000 0074 #asm("sei")
	sei
; 0000 0075 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0076 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 32
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
; 0000 0086 {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0087 if (tx_counter)
	TST  R11
	BREQ _0xA
; 0000 0088    {
; 0000 0089    --tx_counter;
	DEC  R11
; 0000 008A    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 008B #if TX_BUFFER_SIZE != 256
; 0000 008C    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(32)
	CP   R30,R8
	BRNE _0xB
	CLR  R8
; 0000 008D #endif
; 0000 008E    }
_0xB:
; 0000 008F }
_0xA:
_0x54:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0096 {
; 0000 0097 while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
; 0000 0098 #asm("cli")
; 0000 0099 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
; 0000 009A    {
; 0000 009B    tx_buffer[tx_wr_index++]=c;
; 0000 009C #if TX_BUFFER_SIZE != 256
; 0000 009D    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
; 0000 009E #endif
; 0000 009F    ++tx_counter;
; 0000 00A0    }
; 0000 00A1 else
; 0000 00A2    UDR=c;
; 0000 00A3 #asm("sei")
; 0000 00A4 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;#define LEDBLUE PORTB.0
;#define LEDGREEN PORTB.1
;#define RS485 PORTB.4
;//#define DR1 PORTD.5
;//#define DR2 PORTD.6
;//#define DR3 PORTD.7
;inline void DrOff(char n)
; 0000 00B3 {
_DrOff:
; 0000 00B4     PORTD |= 1<<(n+4);
;	n -> Y+0
	CALL SUBOPT_0x0
	OR   R30,R1
	OUT  0x12,R30
; 0000 00B5 }
	RJMP _0x2060001
;inline void DrOn(char n)
; 0000 00B7 {
_DrOn:
; 0000 00B8     PORTD &= ~(1<<(n+4));
;	n -> Y+0
	CALL SUBOPT_0x0
	COM  R30
	AND  R30,R1
	OUT  0x12,R30
; 0000 00B9 }
	RJMP _0x2060001
;
;char test;
;
;signed int regVal[4] = {0,20000,20000,20000}; //0 - 20000 //Угол открытия

	.DSEG
;signed int stepVal[4] = {10,10,10,10}; //1 - 100 //Шаг изменения на 1 вольт
;char flipFlop[4] = {0,0,0,0}; //0-1   //Направление отклонения напряжения
;signed int temp[4];
;char index=0;
;
;
;#define T_FREE 0x00
;/*#define T_ON1  0x11
;#define T_OFF1 0x01
;#define T_ON2  0x12
;#define T_OFF2 0x02
;#define T_ON3  0x13
;#define T_OFF3 0x03*/
;#define TIME_OFF 100
;
;char tValA = T_FREE, tValB = T_FREE; //Флаги действий прерываний
;char uart_firstByte=0;
;
;
;// Timer 0 overflow interrupt service routine 1 ms
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00D3 {

	.CSEG
_timer0_ovf_isr:
	CALL SUBOPT_0x1
; 0000 00D4 // Reinitialize Timer 0 value
; 0000 00D5 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 00D6 
; 0000 00D7 if(++uart_timeout>15)  //Если 15 мс нет данных, обнуляем буфер
	INC  R5
	LDI  R30,LOW(15)
	CP   R30,R5
	BRSH _0x16
; 0000 00D8 {
; 0000 00D9     while (rx_counter) getchar();
_0x17:
	TST  R6
	BREQ _0x19
	RCALL _getchar
	RJMP _0x17
_0x19:
; 0000 00DA uart_firstByte = 1;
	LDI  R30,LOW(1)
	STS  _uart_firstByte,R30
; 0000 00DB }
; 0000 00DC 
; 0000 00DD //if(uart_timeout > 50) RS485 = 0;
; 0000 00DE 
; 0000 00DF if(uart_timeout>150) LEDBLUE = 1;  //Если 150 мс нет данных, выключить светодиод
_0x16:
	LDI  R30,LOW(150)
	CP   R30,R5
	BRSH _0x1A
	SBI  0x18,0
; 0000 00E0 
; 0000 00E1 }
_0x1A:
	RJMP _0x53
;
;
;
;inline void TimeAdd(char i)  //Добавить включение тиристора в очередь на свободное прерывание или включить его сразу
; 0000 00E6 {
_TimeAdd:
; 0000 00E7     if(regVal[i] < 8)
;	i -> Y+0
	CALL SUBOPT_0x2
	SBIW R30,8
	BRGE _0x1D
; 0000 00E8     {
; 0000 00E9         DrOn(i);
	LD   R30,Y
	ST   -Y,R30
	RCALL _DrOn
; 0000 00EA         if(tValA == T_FREE)
	TST  R12
	BRNE _0x1E
; 0000 00EB         {
; 0000 00EC             OCR1A = TCNT1+TIME_OFF;
	CALL SUBOPT_0x3
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00ED             tValA = i;
	LDD  R12,Y+0
; 0000 00EE         }
; 0000 00EF         else if(tValB == T_FREE)
	RJMP _0x1F
_0x1E:
	LDS  R30,_tValB
	CPI  R30,0
	BRNE _0x20
; 0000 00F0         {
; 0000 00F1             OCR1B = TCNT1+TIME_OFF;
	CALL SUBOPT_0x3
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00F2             tValB = i;
	LD   R30,Y
	STS  _tValB,R30
; 0000 00F3         }
; 0000 00F4     }
_0x20:
_0x1F:
; 0000 00F5     else
	RJMP _0x21
_0x1D:
; 0000 00F6     {
; 0000 00F7         if(tValA == T_FREE)
	TST  R12
	BRNE _0x22
; 0000 00F8         {
; 0000 00F9             OCR1A = TCNT1+regVal[i];
	__INWR 0,1,44
	CALL SUBOPT_0x2
	ADD  R30,R0
	ADC  R31,R1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00FA             tValA = i|0x10;
	LD   R30,Y
	ORI  R30,0x10
	MOV  R12,R30
; 0000 00FB         }
; 0000 00FC         else if(tValB == T_FREE)
	RJMP _0x23
_0x22:
	LDS  R30,_tValB
	CPI  R30,0
	BRNE _0x24
; 0000 00FD         {
; 0000 00FE             OCR1B = TCNT1+regVal[i];
	__INWR 0,1,44
	CALL SUBOPT_0x2
	ADD  R30,R0
	ADC  R31,R1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00FF             tValB = i|0x10;
	LD   R30,Y
	ORI  R30,0x10
	STS  _tValB,R30
; 0000 0100         }
; 0000 0101     }
_0x24:
_0x23:
_0x21:
; 0000 0102 }
_0x2060001:
	ADIW R28,1
	RET
;
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0108 {
_ext_int0_isr:
	CALL SUBOPT_0x1
; 0000 0109     TimeAdd(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _TimeAdd
; 0000 010A }
	RJMP _0x53
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 010E {
_ext_int1_isr:
	CALL SUBOPT_0x1
; 0000 010F     TimeAdd(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _TimeAdd
; 0000 0110 }
	RJMP _0x53
;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0114 {
_ext_int2_isr:
	CALL SUBOPT_0x1
; 0000 0115     TimeAdd(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _TimeAdd
; 0000 0116 }
	RJMP _0x53
;
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)  //Взять следующее событие из очереди
; 0000 011B {
_timer1_compa_isr:
	CALL SUBOPT_0x1
; 0000 011C     if(tValA & 0x10)
	SBRS R12,4
	RJMP _0x25
; 0000 011D     {
; 0000 011E         OCR1A = TCNT1+TIME_OFF;
	CALL SUBOPT_0x3
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 011F         tValA &= 0x07;
	LDI  R30,LOW(7)
	AND  R12,R30
; 0000 0120         DrOn(tValA);
	ST   -Y,R12
	RCALL _DrOn
; 0000 0121     }
; 0000 0122     else if(tValA)
	RJMP _0x26
_0x25:
	TST  R12
	BREQ _0x27
; 0000 0123     {
; 0000 0124         DrOff(tValA);
	ST   -Y,R12
	RCALL _DrOff
; 0000 0125         tValA = 0;
	CLR  R12
; 0000 0126     }
; 0000 0127 
; 0000 0128 }
_0x27:
_0x26:
	RJMP _0x53
;
;// Timer1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void) //Взять следующее событие из очереди
; 0000 012C {
_timer1_compb_isr:
	CALL SUBOPT_0x1
; 0000 012D     if(tValB & 0x10)
	LDS  R30,_tValB
	ANDI R30,LOW(0x10)
	BREQ _0x28
; 0000 012E     {
; 0000 012F         OCR1B = TCNT1+TIME_OFF;
	CALL SUBOPT_0x3
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0130         tValB &= 0x07;
	LDS  R30,_tValB
	ANDI R30,LOW(0x7)
	STS  _tValB,R30
; 0000 0131         DrOn(tValB);
	ST   -Y,R30
	RCALL _DrOn
; 0000 0132     }
; 0000 0133     else if(tValB)
	RJMP _0x29
_0x28:
	LDS  R30,_tValB
	CPI  R30,0
	BREQ _0x2A
; 0000 0134     {
; 0000 0135         DrOff(tValB);
	ST   -Y,R30
	RCALL _DrOff
; 0000 0136         tValB = 0;
	LDI  R30,LOW(0)
	STS  _tValB,R30
; 0000 0137     }
; 0000 0138 
; 0000 0139 }
_0x2A:
_0x29:
_0x53:
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
;
;
;
;
;
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 0145 {
_main:
; 0000 0146 // Declare your local variables here
; 0000 0147 {
; 0000 0148 // Input/Output Ports initialization
; 0000 0149 // Port A initialization
; 0000 014A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 014C PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 014D DDRA=0x00;
	OUT  0x1A,R30
; 0000 014E 
; 0000 014F // Port B initialization
; 0000 0150 // Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=Out Func0=Out
; 0000 0151 // State7=T State6=T State5=T State4=0 State3=T State2=T State1=0 State0=0
; 0000 0152 PORTB=0x00;
	OUT  0x18,R30
; 0000 0153 DDRB=0x13;
	LDI  R30,LOW(19)
	OUT  0x17,R30
; 0000 0154 
; 0000 0155 // Port C initialization
; 0000 0156 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0157 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0158 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0159 DDRC=0x00;
	OUT  0x14,R30
; 0000 015A 
; 0000 015B // Port D initialization
; 0000 015C // Func7=Out Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 015D // State7=1 State6=1 State5=1 State4=T State3=T State2=T State1=T State0=T
; 0000 015E PORTD=0xE0;
	LDI  R30,LOW(224)
	OUT  0x12,R30
; 0000 015F DDRD=0xE0;
	OUT  0x11,R30
; 0000 0160 
; 0000 0161 // Timer/Counter 0 initialization
; 0000 0162 // Clock source: System Clock
; 0000 0163 // Clock value: 250,000 kHz
; 0000 0164 // Mode: Normal top=0xFF
; 0000 0165 // OC0 output: Disconnected
; 0000 0166 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0167 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0168 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0169 
; 0000 016A // Timer/Counter 1 initialization
; 0000 016B // Clock source: System Clock
; 0000 016C // Clock value: 2000,000 kHz
; 0000 016D // Mode: Normal top=0xFFFF
; 0000 016E // OC1A output: Discon.
; 0000 016F // OC1B output: Discon.
; 0000 0170 // Noise Canceler: Off
; 0000 0171 // Input Capture on Falling Edge
; 0000 0172 // Timer1 Overflow Interrupt: Off
; 0000 0173 // Input Capture Interrupt: Off
; 0000 0174 // Compare A Match Interrupt: On
; 0000 0175 // Compare B Match Interrupt: On
; 0000 0176 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0177 TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0178 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0179 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 017A ICR1H=0x00;
	OUT  0x27,R30
; 0000 017B ICR1L=0x00;
	OUT  0x26,R30
; 0000 017C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 017D OCR1AL=0x01;
	LDI  R30,LOW(1)
	OUT  0x2A,R30
; 0000 017E OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 017F OCR1BL=0x01;
	LDI  R30,LOW(1)
	OUT  0x28,R30
; 0000 0180 
; 0000 0181 // Timer/Counter 2 initialization
; 0000 0182 // Clock source: System Clock
; 0000 0183 // Clock value: Timer2 Stopped
; 0000 0184 // Mode: Normal top=0xFF
; 0000 0185 // OC2 output: Disconnected
; 0000 0186 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 0187 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0188 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0189 OCR2=0x00;
	OUT  0x23,R30
; 0000 018A 
; 0000 018B // External Interrupt(s) initialization
; 0000 018C // INT0: On
; 0000 018D // INT0 Mode: Falling Edge
; 0000 018E // INT1: On
; 0000 018F // INT1 Mode: Falling Edge
; 0000 0190 // INT2: On
; 0000 0191 // INT2 Mode: Falling Edge
; 0000 0192 GICR|=0xE0;
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 0193 MCUCR=0x0A;
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0194 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0195 GIFR=0xE0;
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 0196 
; 0000 0197 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0198 TIMSK=0x19;
	LDI  R30,LOW(25)
	OUT  0x39,R30
; 0000 0199 
; 0000 019A 
; 0000 019B // USART initialization
; 0000 019C // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 019D // USART Receiver: On
; 0000 019E // USART Transmitter: On
; 0000 019F // USART Mode: Asynchronous
; 0000 01A0 // USART Baud Rate: 9600
; 0000 01A1 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01A2 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01A3 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01A4 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01A5 UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 01A6 
; 0000 01A7 // Analog Comparator initialization
; 0000 01A8 // Analog Comparator: Off
; 0000 01A9 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01AA ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01AB SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01AC 
; 0000 01AD // ADC initialization
; 0000 01AE // ADC disabled
; 0000 01AF ADCSRA=0x00;
	OUT  0x6,R30
; 0000 01B0 
; 0000 01B1 // SPI initialization
; 0000 01B2 // SPI disabled
; 0000 01B3 SPCR=0x00;
	OUT  0xD,R30
; 0000 01B4 
; 0000 01B5 // TWI initialization
; 0000 01B6 // TWI disabled
; 0000 01B7 TWCR=0x00;
	OUT  0x36,R30
; 0000 01B8 
; 0000 01B9 // Global enable interrupts
; 0000 01BA #asm("sei")
	sei
; 0000 01BB }
; 0000 01BC RS485 = 0;
	CBI  0x18,4
; 0000 01BD LEDGREEN = 0;
	CBI  0x18,1
; 0000 01BE LEDBLUE = 1;
	SBI  0x18,0
; 0000 01BF 
; 0000 01C0 while (1)
_0x31:
; 0000 01C1       {
; 0000 01C2           if(rx_counter > 6 && uart_firstByte) //Если с начала посылки прошло больше 6 байт и верный адрес
	LDI  R30,LOW(6)
	CP   R30,R6
	BRSH _0x35
	LDS  R30,_uart_firstByte
	CPI  R30,0
	BRNE _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 01C3           {
; 0000 01C4               if(getchar() == 0x66)
	RCALL _getchar
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x37
; 0000 01C5               if(getchar() == 0x06)
	RCALL _getchar
	CPI  R30,LOW(0x6)
	BREQ PC+3
	JMP _0x38
; 0000 01C6               if(getchar() == 0x60)
	RCALL _getchar
	CPI  R30,LOW(0x60)
	BREQ PC+3
	JMP _0x39
; 0000 01C7               {
; 0000 01C8                 LEDBLUE = 0;          //То включаем светодиод и
	CBI  0x18,0
; 0000 01C9                 for(index=0; index<3; index++)
	CLR  R13
_0x3D:
	LDI  R30,LOW(3)
	CP   R13,R30
	BRLO PC+3
	JMP _0x3E
; 0000 01CA                 {
; 0000 01CB                     temp[index] = getchar();
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 01CC                     temp[index] -= 100;     //Настраеваем шаг регулирования
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	ST   -X,R31
	ST   -X,R30
; 0000 01CD                     if(flipFlop[index] && temp[index] > 0 || !flipFlop[index] && temp[index] < 0)
	CALL SUBOPT_0x6
	BREQ _0x40
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	MOVW R26,R30
	CALL __CPW02
	BRLT _0x42
_0x40:
	CALL SUBOPT_0x6
	BRNE _0x43
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	TST  R31
	BRMI _0x42
_0x43:
	RJMP _0x3F
_0x42:
; 0000 01CE                     {
; 0000 01CF                         stepVal[index]<<=1; //Если напряжение долго отклоняется в 1 сторону, то увеличиваем шаг
	CALL SUBOPT_0x8
	CALL SUBOPT_0x5
	LSL  R30
	ROL  R31
	ST   -X,R31
	ST   -X,R30
; 0000 01D0                         if(stepVal[index] > 100) stepVal[index] = 100;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRLT _0x46
	CALL SUBOPT_0x8
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 01D1                     }
_0x46:
; 0000 01D2                     else if(temp[index] != 0)
	RJMP _0x47
_0x3F:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	SBIW R30,0
	BREQ _0x48
; 0000 01D3                     {
; 0000 01D4                         stepVal[index]>>=1; //Если напряжение колеблится около нужного, уменьшаем шаг
	CALL SUBOPT_0x8
	CALL SUBOPT_0x5
	ASR  R31
	ROR  R30
	ST   -X,R31
	ST   -X,R30
; 0000 01D5                         if(stepVal[index] < 1) stepVal[index] = 1;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x7
	SBIW R30,1
	BRGE _0x49
	CALL SUBOPT_0x8
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 01D6                     }
_0x49:
; 0000 01D7 
; 0000 01D8 
; 0000 01D9                     if(temp[index]<0)  //Регулируем угол открытия
_0x48:
_0x47:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	TST  R31
	BRPL _0x4A
; 0000 01DA                     {
; 0000 01DB                         #asm("cli")
	cli
; 0000 01DC                         regVal[index+1] += stepVal[index]*temp[index];
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
; 0000 01DD                         if(regVal[index+1] < 1) regVal[index+1] = 1;
	SBIW R30,1
	BRGE _0x4B
	CALL SUBOPT_0xD
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 01DE                         #asm("sei")
_0x4B:
	sei
; 0000 01DF                         flipFlop[index] = 0;
	CALL SUBOPT_0x9
	SUBI R30,LOW(-_flipFlop)
	SBCI R31,HIGH(-_flipFlop)
	LDI  R26,LOW(0)
	RJMP _0x52
; 0000 01E0                     }
; 0000 01E1                     else if(temp[index] > 0)
_0x4A:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x4D
; 0000 01E2                     {
; 0000 01E3                         #asm("cli")
	cli
; 0000 01E4                         regVal[index+1] += stepVal[index]*temp[index];
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
; 0000 01E5                         if(regVal[index+1] > 20000 || regVal[index+1] < 1) regVal[index+1] = 20000;
	CPI  R30,LOW(0x4E21)
	LDI  R26,HIGH(0x4E21)
	CPC  R31,R26
	BRGE _0x4F
	SBIW R30,1
	BRGE _0x4E
_0x4F:
	CALL SUBOPT_0xD
	LDI  R30,LOW(20000)
	LDI  R31,HIGH(20000)
	ST   X+,R30
	ST   X,R31
; 0000 01E6                         #asm("sei")
_0x4E:
	sei
; 0000 01E7                         flipFlop[index] = 1;
	CALL SUBOPT_0x9
	SUBI R30,LOW(-_flipFlop)
	SBCI R31,HIGH(-_flipFlop)
	LDI  R26,LOW(1)
_0x52:
	STD  Z+0,R26
; 0000 01E8                     }
; 0000 01E9                 }
_0x4D:
	INC  R13
	RJMP _0x3D
_0x3E:
; 0000 01EA 
; 0000 01EB               }
; 0000 01EC              uart_firstByte = 0;
_0x39:
_0x38:
_0x37:
	LDI  R30,LOW(0)
	STS  _uart_firstByte,R30
; 0000 01ED 
; 0000 01EE           }
; 0000 01EF       }
_0x34:
	RJMP _0x31
; 0000 01F0 }
_0x51:
	RJMP _0x51
;
;
;
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

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x20
_tx_buffer:
	.BYTE 0x20
_regVal:
	.BYTE 0x8
_stepVal:
	.BYTE 0x8
_flipFlop:
	.BYTE 0x4
_temp:
	.BYTE 0x8
_tValB:
	.BYTE 0x1
_uart_firstByte:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	IN   R1,18
	LD   R30,Y
	SUBI R30,-LOW(4)
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x1:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	LD   R30,Y
	LDI  R26,LOW(_regVal)
	LDI  R27,HIGH(_regVal)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	IN   R30,0x2C
	IN   R31,0x2C+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x4:
	MOV  R30,R13
	LDI  R26,LOW(_temp)
	LDI  R27,HIGH(_temp)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_flipFlop)
	SBCI R31,HIGH(-_flipFlop)
	LD   R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x8:
	MOV  R30,R13
	LDI  R26,LOW(_stepVal)
	LDI  R27,HIGH(_stepVal)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	MOV  R30,R13
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	ADIW R30,1
	LDI  R26,LOW(_regVal)
	LDI  R27,HIGH(_regVal)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	LD   R22,Z
	LDD  R23,Z+1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC:
	MOVW R26,R0
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R26,R24
	ST   X+,R30
	ST   X,R31
	MOV  R26,R13
	CLR  R27
	LSL  R26
	ROL  R27
	__ADDW2MN _regVal,2
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	MOV  R26,R13
	CLR  R27
	LSL  R26
	ROL  R27
	__ADDW2MN _regVal,2
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
