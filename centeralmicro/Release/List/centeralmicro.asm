
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _temp=R5
	.DEF _keypad_handler=R6
	.DEF _keypad_handler_msb=R7
	.DEF _button_handler=R8
	.DEF _button_handler_msb=R9
	.DEF _temp_window_byte=R4
	.DEF _temp_window_selected=R11
	.DEF _temp_window_range_small=R10
	.DEF _temp_window_range_large=R13
	.DEF _edit_window_block_no=R12

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rxc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x20,0x20,0x28,0x28,0x68,0xB0,0x60,0x20
	.DB  0x20,0x20,0x28,0x2A,0x28,0x30,0x20,0x20
	.DB  0x0,0x80,0x80,0x44,0x32,0x24,0x20,0x20
	.DB  0x0,0x24,0x24,0x24,0x38,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x24,0x2A,0x11,0x0
	.DB  0x20,0x20,0x20,0x24,0x2A,0x11,0x20,0x20
	.DB  0x30,0x20,0x20,0x20,0x24,0x2A,0x11,0x20
	.DB  0x20,0x20,0x30,0x20,0x30,0x28,0x28,0x18
	.DB  0x20,0x24,0x22,0x21,0x24,0x2A,0x11,0x0
	.DB  0x24,0x22,0x21,0x24,0x2A,0x11,0x20,0x20
	.DB  0x30,0x24,0x22,0x21,0x24,0x2A,0x11,0x20
	.DB  0x0,0x80,0x80,0x40,0x30,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x60,0xA0,0x60,0x28,0x30
	.DB  0x20,0x20,0x20,0x60,0xB0,0x60,0x20,0x20
	.DB  0x0,0x30,0x28,0x60,0xA0,0x60,0x30,0x20
	.DB  0x0,0x4,0x6,0x1D,0x25,0x24,0x20,0x20
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x4F,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x7,0x0,0x7,0x0,0x0,0x0,0x0
	.DB  0x0,0x14,0x7F,0x14,0x7F,0x14,0x0,0x0
	.DB  0x0,0x24,0x2A,0x7F,0x2A,0x12,0x0,0x0
	.DB  0x0,0x23,0x13,0x8,0x64,0x62,0x0,0x0
	.DB  0x0,0x36,0x49,0x55,0x22,0x40,0x0,0x0
	.DB  0x0,0x0,0x5,0x3,0x0,0x0,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x0,0x0
	.DB  0x0,0x41,0x22,0x1C,0x0,0x0,0x0,0x0
	.DB  0x0,0x14,0x8,0x3E,0x8,0x14,0x0,0x0
	.DB  0x0,0x8,0x8,0x3E,0x8,0x8,0x0,0x0
	.DB  0x0,0x0,0x28,0x18,0x0,0x0,0x0,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x8,0x0
	.DB  0x0,0x30,0x30,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x20,0x10,0x8,0x4,0x2,0x0,0x0
	.DB  0x0,0x3E,0x51,0x49,0x45,0x3E,0x0,0x0
	.DB  0x0,0x0,0x42,0x7F,0x40,0x0,0x0,0x0
	.DB  0x0,0x42,0x61,0x51,0x49,0x46,0x0,0x0
	.DB  0x0,0x21,0x41,0x45,0x4B,0x31,0x0,0x0
	.DB  0x0,0x18,0x14,0x12,0x7F,0x10,0x0,0x0
	.DB  0x0,0x0,0x27,0x45,0x45,0x45,0x39,0x0
	.DB  0x0,0x3C,0x4A,0x49,0x49,0x30,0x0,0x0
	.DB  0x0,0x1,0x71,0x9,0x5,0x3,0x0,0x0
	.DB  0x0,0x36,0x49,0x49,0x49,0x36,0x0,0x0
	.DB  0x0,0x6,0x49,0x49,0x29,0x1E,0x0,0x0
	.DB  0x0,0x0,0x36,0x36,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x56,0x36,0x0,0x0,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x0,0x0,0x0
	.DB  0x0,0x24,0x24,0x24,0x24,0x24,0x0,0x0
	.DB  0x0,0x0,0x41,0x22,0x14,0x8,0x0,0x0
	.DB  0x0,0x2,0x1,0x51,0x9,0x6,0x0,0x0
	.DB  0x0,0x32,0x49,0x79,0x41,0x3E,0x0,0x0
	.DB  0x0,0x7E,0x11,0x11,0x11,0x7E,0x0,0x0
	.DB  0x0,0x7F,0x49,0x49,0x49,0x36,0x0,0x0
	.DB  0x0,0x3E,0x41,0x41,0x41,0x22,0x0,0x0
	.DB  0x0,0x7F,0x41,0x41,0x22,0x1C,0x0,0x0
	.DB  0x0,0x7F,0x49,0x49,0x49,0x41,0x0,0x0
	.DB  0x0,0x7F,0x9,0x9,0x9,0x1,0x0,0x0
	.DB  0x0,0x3E,0x41,0x49,0x49,0x3A,0x0,0x0
	.DB  0x0,0x7F,0x8,0x8,0x8,0x7F,0x0,0x0
	.DB  0x0,0x0,0x41,0x7F,0x41,0x0,0x0,0x0
	.DB  0x0,0x20,0x40,0x41,0x3F,0x1,0x0,0x0
	.DB  0x0,0x7F,0x8,0x14,0x22,0x41,0x0,0x0
	.DB  0x0,0x7F,0x40,0x40,0x40,0x40,0x0,0x0
	.DB  0x0,0x7F,0x2,0xC,0x2,0x7F,0x0,0x0
	.DB  0x0,0x7F,0x4,0x8,0x10,0x7F,0x0,0x0
	.DB  0x0,0x3E,0x41,0x41,0x41,0x3E,0x0,0x0
	.DB  0x0,0x7F,0x9,0x9,0x9,0x6,0x0,0x0
	.DB  0x3E,0x41,0x51,0x21,0x5E,0x0,0x0,0x0
	.DB  0x0,0x7F,0x9,0x19,0x29,0x46,0x0,0x0
	.DB  0x0,0x46,0x49,0x49,0x49,0x31,0x0,0x0
	.DB  0x0,0x1,0x1,0x7F,0x1,0x1,0x0,0x0
	.DB  0x0,0x3F,0x40,0x40,0x40,0x3F,0x0,0x0
	.DB  0x0,0x1F,0x20,0x40,0x20,0x1F,0x0,0x0
	.DB  0x0,0x3F,0x40,0x60,0x40,0x3F,0x0,0x0
	.DB  0x0,0x63,0x14,0x8,0x14,0x63,0x0,0x0
	.DB  0x0,0x7,0x8,0x70,0x8,0x7,0x0,0x0
	.DB  0x0,0x61,0x51,0x49,0x45,0x43,0x0,0x0
	.DB  0x0,0x7F,0x41,0x41,0x0,0x0,0x0,0x0
	.DB  0x0,0x15,0x16,0x7C,0x16,0x15,0x0,0x0
	.DB  0x0,0x41,0x41,0x7F,0x0,0x0,0x0,0x0
	.DB  0x0,0x4,0x2,0x1,0x2,0x4,0x0,0x0
	.DB  0x0,0x40,0x40,0x40,0x40,0x40,0x0,0x0
	.DB  0x0,0x1,0x2,0x4,0x0,0x0,0x0,0x0
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x0,0x0
	.DB  0x0,0x7F,0x44,0x44,0x44,0x38,0x0,0x0
	.DB  0x0,0x38,0x44,0x44,0x44,0x0,0x0,0x0
	.DB  0x0,0x38,0x44,0x44,0x48,0x7F,0x0,0x0
	.DB  0x0,0x38,0x54,0x54,0x54,0x18,0x0,0x0
	.DB  0x0,0x10,0x7E,0x11,0x1,0x2,0x0,0x0
	.DB  0x0,0xC,0x52,0x52,0x52,0x3E,0x0,0x0
	.DB  0x0,0x7F,0x8,0x4,0x4,0x78,0x0,0x0
	.DB  0x0,0x0,0x44,0x7D,0x40,0x0,0x0,0x0
	.DB  0x0,0x20,0x40,0x40,0x3D,0x0,0x0,0x0
	.DB  0x0,0x7F,0x10,0x28,0x44,0x0,0x0,0x0
	.DB  0x0,0x0,0x41,0x7F,0x40,0x0,0x0,0x0
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x0,0x0
	.DB  0x0,0x7C,0x8,0x4,0x4,0x78,0x0,0x0
	.DB  0x0,0x38,0x44,0x44,0x44,0x38,0x0,0x0
	.DB  0x0,0x7C,0x14,0x14,0x14,0x8,0x0,0x0
	.DB  0x0,0x8,0x14,0x14,0x18,0x7C,0x0,0x0
	.DB  0x0,0x7C,0x8,0x4,0x4,0x8,0x0,0x0
	.DB  0x0,0x48,0x54,0x54,0x54,0x20,0x0,0x0
	.DB  0x0,0x4,0x3F,0x44,0x40,0x20,0x0,0x0
	.DB  0x0,0x3C,0x40,0x40,0x20,0x7C,0x0,0x0
	.DB  0x0,0x1C,0x20,0x40,0x20,0x1C,0x0,0x0
	.DB  0x0,0x1E,0x20,0x10,0x20,0x1E,0x0,0x0
	.DB  0x0,0x22,0x14,0x8,0x14,0x22,0x0,0x0
	.DB  0x0,0x6,0x48,0x48,0x48,0x3E,0x0,0x0
	.DB  0x0,0x44,0x64,0x54,0x4C,0x44,0x0,0x0
	.DB  0x0,0x8,0x36,0x41,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x7F,0x0,0x0,0x0,0x0
	.DB  0x0,0x41,0x36,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x8,0x8,0x2A,0x1C,0x8,0x0,0x0
	.DB  0x0,0x8,0x1C,0x2A,0x8,0x8,0x0,0x0
	.DB  0x0,0x3C,0x42,0x41,0x42,0x3C,0x0,0x0
	.DB  0x0,0x30,0x28,0x60,0xA0,0x60,0x28,0x30
	.DB  0x20,0x20,0x20,0x20,0xA0,0x20,0x28,0x30
	.DB  0x20,0x20,0x20,0x20,0xB0,0x20,0x20,0x20
	.DB  0x0,0x30,0x28,0x20,0xA0,0x20,0x30,0x20
	.DB  0x20,0x20,0x20,0x22,0x20,0x22,0x28,0x30
	.DB  0x20,0x20,0x20,0x22,0x30,0x22,0x20,0x20
	.DB  0x0,0x30,0x28,0x22,0x20,0x22,0x30,0x20
	.DB  0x20,0x20,0x20,0x22,0x21,0x22,0x28,0x30
	.DB  0x20,0x20,0x20,0x22,0x31,0x22,0x20,0x20
	.DB  0x0,0x30,0x28,0x22,0x21,0x22,0x30,0x20
	.DB  0x20,0x20,0x28,0x28,0x28,0xB0,0x20,0x20
	.DB  0x20,0x20,0x28,0x28,0x28,0x30,0x20,0x20
	.DB  0x0,0xC0,0xA8,0x28,0x68,0xB0,0x60,0x20
	.DB  0x0,0x0,0x80,0x80,0x44,0x32,0x4,0x0
	.DB  0x0,0x24,0x25,0x24,0x38,0x20,0x20,0x20
	.DB  0x30,0x24,0x22,0x21,0x24,0x2A,0x11,0x0
	.DB  0x0,0x80,0x80,0x40,0x34,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x38,0x20,0x38,0x20,0x18
	.DB  0x20,0x20,0x38,0x20,0x38,0x20,0x38,0x20
	.DB  0x60,0x80,0x80,0x78,0x20,0x38,0x20,0x18
	.DB  0x20,0x20,0x20,0x38,0x22,0x39,0x22,0x18
	.DB  0x20,0x20,0x38,0x22,0x39,0x22,0x38,0x20
	.DB  0x60,0x80,0x80,0x78,0x22,0x39,0x22,0x18
	.DB  0x30,0x20,0x20,0x20,0x24,0x2A,0x11,0x0
	.DB  0x20,0x30,0x20,0x30,0x28,0x28,0x38,0x20
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x28,0x38
	.DB  0x20,0x20,0x30,0x20,0x30,0x28,0x2A,0x18
	.DB  0x20,0x30,0x20,0x30,0x28,0x2A,0x38,0x20
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x2A,0x38
	.DB  0x20,0x20,0x3E,0x30,0x28,0x28,0x38,0x20
	.DB  0x20,0x20,0x3E,0x30,0x28,0x2A,0x38,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x28,0x28,0x0
	.DB  0x20,0x20,0x20,0x30,0x28,0x28,0x20,0x20
	.DB  0x0,0x40,0xA0,0xB0,0x28,0x28,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x28,0x2A,0x0
	.DB  0x20,0x20,0x20,0x30,0x28,0x2A,0x20,0x20
	.DB  0x0,0x40,0xA0,0xB0,0x28,0x2A,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x28,0x2A,0x30
	.DB  0x20,0x20,0x30,0x28,0x2A,0x30,0x20,0x20
	.DB  0x0,0x18,0x20,0x20,0x30,0x28,0x2A,0x30
	.DB  0x20,0x20,0x20,0x20,0x30,0x2A,0x28,0x32
	.DB  0x20,0x20,0x30,0x2A,0x28,0x32,0x20,0x20
	.DB  0x60,0x80,0x80,0xB2,0xA8,0x7A,0x20,0x20
	.DB  0x22,0x25,0x25,0x25,0x25,0x25,0x25,0x19
	.DB  0x20,0x20,0x20,0x1C,0x22,0x21,0x20,0x20
	.DB  0x30,0x28,0x2C,0x2A,0x20,0x3F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x1F,0x0
	.DB  0x20,0x20,0x20,0x20,0x1F,0x20,0x20,0x20
	.DB  0x0,0x30,0x40,0x40,0x3F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x48,0x48,0x30
	.DB  0x20,0x20,0x30,0x48,0x48,0x30,0x20,0x20
	.DB  0x80,0x40,0x30,0x48,0x48,0x30,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x22,0x20,0x18,0x0
	.DB  0x20,0x20,0x20,0x20,0x1A,0x20,0x20,0x20
	.DB  0x30,0x40,0x44,0x40,0x30,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x30,0x28,0x3A,0x2C,0x18
	.DB  0x20,0x20,0x30,0x28,0x3A,0x2C,0x38,0x20
	.DB  0x0,0x18,0x14,0x14,0x18,0x20,0x20,0x20
	.DB  0x0,0x21,0x22,0x24,0x28,0x10,0xF,0x0
	.DB  0x0,0xB0,0xA8,0x78,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xA0,0x20,0xA0,0x28,0x30
	.DB  0x20,0x20,0x20,0xA0,0x30,0xA0,0x20,0x20
	.DB  0x0,0x60,0x80,0x80,0xA0,0x50,0x10,0x20
	.DB  0x0,0x1E,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x30,0x28,0x28,0x20,0x0,0x0
	.DB  0x0,0x4,0x2,0x2,0x3A,0x2,0x2,0x1
	.DB  0x0,0x0,0x4,0x6,0x3D,0x5,0x4,0x0
	.DB  0x0,0x0,0x4,0xB6,0xAD,0x7D,0x4,0x0
	.DB  0x0,0x0,0x80,0xC0,0xBF,0xA0,0x80,0x0
	.DB  0x4,0x66,0x85,0x95,0xA8,0xA8,0x48,0x0
	.DB  0x0,0x0,0x0,0x3F,0x0,0x0,0x0,0x0
	.DB  0x0,0x30,0x28,0x20,0xA0,0x20,0x28,0x30
	.DB  0x0,0x0,0x30,0x2A,0x28,0x32,0x0,0x0
	.DB  0x0,0x30,0x28,0x22,0x20,0x22,0x28,0x30
	.DB  0x0,0x30,0x28,0x22,0x21,0x22,0x28,0x30
	.DB  0x0,0xC0,0xA8,0xA8,0x28,0xB0,0x20,0x20
	.DB  0x0,0xC0,0xA8,0xA8,0xA8,0x30,0x20,0x20
	.DB  0x0,0xC0,0xA8,0xAA,0x28,0x30,0x20,0x20
	.DB  0x0,0x0,0x24,0x24,0x24,0x38,0x0,0x0
	.DB  0x0,0x0,0x24,0x25,0x24,0x38,0x0,0x0
	.DB  0x0,0x80,0x80,0x40,0x30,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x80,0x40,0x34,0x0,0x0
	.DB  0x60,0x80,0x80,0x78,0x20,0x38,0x20,0x18
	.DB  0x60,0x80,0x80,0x78,0x22,0x39,0x22,0x18
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x28,0x18
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x2A,0x18
	.DB  0x0,0x22,0x14,0x8,0x14,0x22,0x0,0x0
	.DB  0x20,0x20,0x3E,0x30,0x28,0x28,0x18,0x0
	.DB  0x20,0x20,0x3E,0x30,0x28,0x2A,0x18,0x0
	.DB  0x0,0x0,0x40,0xA0,0xB0,0x28,0x28,0x0
	.DB  0x0,0x0,0x40,0xA0,0xB0,0x2A,0x28,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x18,0x20,0x20,0x30,0x28,0x2A,0x30
	.DB  0x0,0x60,0x80,0x80,0xB2,0xA8,0x7A,0x0
	.DB  0x0,0x30,0x28,0x2C,0x2A,0x20,0x3F,0x0
	.DB  0x0,0x40,0xA9,0xAA,0xA8,0xF0,0x0,0x0
	.DB  0x0,0x0,0x60,0x80,0x80,0x7E,0x0,0x0
	.DB  0x0,0x40,0xAA,0xA9,0xAA,0xF0,0x0,0x0
	.DB  0x0,0x0,0xC0,0x20,0x30,0x28,0x28,0x30
	.DB  0x0,0x0,0x60,0x80,0x88,0x80,0x60,0x0
	.DB  0x0,0x0,0x30,0x28,0x28,0x30,0x0,0x0
	.DB  0x0,0x0,0x0,0xB0,0xA8,0x78,0x0,0x0
	.DB  0x4,0x26,0x25,0x25,0x28,0x10,0xF,0x0
	.DB  0x4,0x22,0x22,0x26,0x29,0x10,0xF,0x0
	.DB  0x0,0x21,0x22,0x24,0xA8,0xD0,0xAF,0xA0
	.DB  0x0,0x70,0xAA,0xA9,0xAA,0x30,0x0,0x0
	.DB  0x0,0x70,0xAA,0xA8,0xAA,0x30,0x0,0x0
	.DB  0x0,0x30,0x40,0x40,0x50,0x28,0x8,0x0
	.DB  0x0,0x30,0xC0,0x40,0xD0,0x28,0x8,0x0
	.DB  0x0,0x0,0x2,0x79,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x2,0x78,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x5,0x5,0x5
	.DB  0x0,0x0,0x0,0x4,0x3,0xB,0x6,0x6
	.DB  0xA0,0xA0,0xA0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x1,0x1,0x1,0x0,0x0
	.DB  0x0,0x21,0x22,0x24,0x28,0x10,0x2F,0x20
	.DB  0x0,0x0,0x0,0x0,0x0,0x4,0x3,0x3
	.DB  0x0,0x0,0x80,0x80,0x80,0x80,0x0,0x0
	.DB  0x0,0x0,0x10,0x10,0x54,0x10,0x10,0x0
	.DB  0x0,0x0,0x2,0x4,0x2,0x4,0x2,0x0
	.DB  0x20,0x24,0x26,0x25,0x25,0x20,0x28,0x30
	.DB  0x20,0x24,0x26,0x25,0x35,0x20,0x20,0x20
	.DB  0x8,0x6C,0x8A,0x8A,0xA0,0x50,0x10,0x20
	.DB  0x4,0xB6,0xAD,0x7D,0x24,0x20,0x20,0x20
	.DB  0x0,0x19,0x14,0x15,0x18,0x20,0x20,0x20
	.DB  0x4,0x2,0x2,0x1A,0x22,0x22,0x21,0x20
	.DB  0x0,0x40,0x60,0x50,0x48,0x50,0x40,0x40
_map:
	.DB  0xC1,0xC1,0xC1,0xC1,0x0,0x0,0xC2,0xC2
	.DB  0xFE,0xFE,0x1,0x0,0xC3,0xC3,0x1F,0x1F
	.DB  0x1,0x0,0xC4,0xC4,0xFC,0xFC,0x1,0x0
	.DB  0xC5,0xC5,0xC5,0xC5,0x1,0x1,0xC6,0xBD
	.DB  0xBF,0xBE,0x1,0x1,0xC7,0xC7,0xC0,0xC0
	.DB  0x1,0x0,0xC8,0x82,0x84,0x83,0x1,0x1
	.DB  0xC9,0xC9,0xFD,0xFD,0x1,0x0,0xCA,0x85
	.DB  0x87,0x86,0x1,0x1,0xCB,0x88,0x8A,0x89
	.DB  0x1,0x1,0xCC,0x8B,0xCC,0x8B,0x1,0x1
	.DB  0xCD,0x8C,0xCD,0x8C,0x1,0x1,0xCE,0x11
	.DB  0xCE,0x11,0x1,0x1,0xCF,0xCF,0x13,0x13
	.DB  0x1,0x0,0xD0,0xD0,0x8F,0x8F,0x1,0x0
	.DB  0xD1,0xD1,0x1B,0x1B,0x1,0x0,0xD2,0xD2
	.DB  0x91,0x91,0x1,0x0,0xD3,0x92,0x94,0x93
	.DB  0x1,0x1,0xD4,0x95,0x97,0x96,0x1,0x1
	.DB  0xD5,0x17,0x9A,0x99,0x1,0x1,0xD6,0x9B
	.DB  0x9D,0x9C,0x1,0x1,0xD7,0xD7,0xD7,0xD7
	.DB  0x0,0x0,0xD8,0xD8,0x9E,0x9E,0x1,0x1
	.DB  0xD9,0xD9,0x9F,0x9F,0x1,0x1,0xDA,0xA0
	.DB  0xA2,0xA1,0x1,0x1,0xDB,0xA3,0xA5,0xA4
	.DB  0x1,0x1,0xDC,0xDC,0xDC,0xDC,0x0,0x0
	.DB  0xDD,0xA6,0xA8,0xA7,0x1,0x1,0xDE,0xA9
	.DB  0xAB,0xAA,0x1,0x1,0xDF,0xAC,0xAE,0xAD
	.DB  0x1,0x1,0xE0,0xE0,0xE0,0xE0,0x0,0x0
	.DB  0xE1,0xAF,0xB1,0xB0,0x1,0x1,0xE2,0xE2
	.DB  0xE2,0xE2,0x0,0x0,0xE3,0xB2,0xB4,0xB3
	.DB  0x1,0x1,0xE4,0xB5,0xB7,0xB6,0x1,0x1
	.DB  0xE5,0xB8,0xBA,0xB9,0x1,0x1,0xE6,0xE6
	.DB  0xBC,0xBC,0x1,0x0,0xE7,0xE7,0xE7,0xE7
	.DB  0x0,0x0,0xE8,0xE8,0xE8,0xE8,0x0,0x0
	.DB  0xE9,0xE9,0xE9,0xE9,0x0,0x0,0xEA,0xEA
	.DB  0xEA,0xEA,0x0,0x0,0xEB,0xEB,0xEB,0xEB
	.DB  0x0,0x0,0xEC,0xBD,0xBF,0xBE,0x1,0x1
	.DB  0xED,0xBD,0xBF,0xBE,0x1,0x1,0xEE,0xEE
	.DB  0xEE,0xEE,0x0,0x0,0xEF,0xEF,0xEF,0xEF
	.DB  0x0,0x0,0xF0,0xF0,0xF0,0xF0,0x0,0x0
	.DB  0xF1,0xF1,0xF1,0xF1,0x0,0x0,0xF2,0xF2
	.DB  0xF2,0xF2,0x0,0x0,0xF3,0xF3,0xF3,0xF3
	.DB  0x0,0x0,0xF5,0xF5,0xF5,0xF5,0x0,0x0
	.DB  0xF6,0xF6,0xF6,0xF6,0x0,0x0,0xF7,0xF7
	.DB  0xF7,0xF7,0x0,0x0,0xF8,0xF8,0xF8,0xF8
	.DB  0x0,0x0,0xFB,0xF9,0xFB,0xFA,0x1,0x1
	.DB  0xBB,0xBB,0xF4,0xF4,0x1,0x0,0x81,0x1C
	.DB  0x1E,0x1D,0x1,0x1,0x90,0x18,0x1A,0x19
	.DB  0x1,0x1,0x98,0x14,0x16,0x15,0x1,0x1
	.DB  0x8E,0x8E,0x12,0x12,0x1,0x0,0x8D,0x10
	.DB  0x8D,0x10,0x1,0x1
_codes:
	.DB  0x7,0x8,0x9,0xFF,0x4,0x5,0x6,0xFF
	.DB  0x1,0x2,0x3,0xFF,0xFF,0x0,0xFF,0xFF
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xFC,0x0,0x0,0x0
	.DB  0x0

_0xE:
	.DB  0xC1
_0x149:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x25,0x64,0x20,0x0,0x25,0x64,0x0,0x5B
	.DB  0x0,0x5D,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x61,0x20,0x72,0x61,0x6E,0x67,0x65
	.DB  0x3A,0x0,0x20,0x2D,0x20,0x0,0x5B,0x4F
	.DB  0x4B,0x5D,0x0,0x20,0x43,0x61,0x6E,0x63
	.DB  0x65,0x6C,0x0,0x3E,0x0,0x50,0x61,0x74
	.DB  0x74,0x65,0x72,0x6E,0x3A,0x20,0x25,0x64
	.DB  0x0,0x3E,0x20,0x43,0x6F,0x6E,0x74,0x69
	.DB  0x6E,0x75,0x65,0x0,0x20,0x20,0x53,0x61
	.DB  0x76,0x65,0x0,0x20,0x20,0x41,0x63,0x74
	.DB  0x69,0x76,0x61,0x74,0x65,0x0,0x20,0x20
	.DB  0x43,0x61,0x6E,0x63,0x65,0x6C,0x0,0x20
	.DB  0x20,0x0,0x50,0x61,0x74,0x74,0x65,0x72
	.DB  0x6E,0x3A,0x0,0x42,0x6C,0x6F,0x63,0x6B
	.DB  0x3A,0x0,0x5B,0x4D,0x65,0x6E,0x75,0x5D
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x61
	.DB  0x20,0x70,0x61,0x74,0x74,0x65,0x72,0x6E
	.DB  0x0,0x6E,0x75,0x6D,0x62,0x65,0x72,0x20
	.DB  0x62,0x65,0x74,0x77,0x65,0x65,0x6E,0x0
	.DB  0x31,0x20,0x61,0x6E,0x64,0x20,0x38,0x20
	.DB  0x3A,0x20,0x0,0x44,0x65,0x62,0x75,0x67
	.DB  0x67,0x69,0x6E,0x67,0x2C,0x0,0x50,0x6C
	.DB  0x65,0x61,0x73,0x65,0x20,0x77,0x61,0x69
	.DB  0x74,0x2E,0x2E,0x2E,0x0,0x41,0x6C,0x6C
	.DB  0x20,0x6C,0x69,0x67,0x68,0x74,0x6D,0x69
	.DB  0x63,0x72,0x6F,0x73,0x2C,0x0,0x61,0x72
	.DB  0x65,0x20,0x63,0x6F,0x6E,0x6E,0x65,0x63
	.DB  0x74,0x65,0x64,0x2E,0x0,0x6C,0x69,0x67
	.DB  0x68,0x74,0x6D,0x69,0x63,0x72,0x6F,0x73
	.DB  0x20,0x74,0x68,0x61,0x74,0x0,0x61,0x72
	.DB  0x65,0x20,0x64,0x69,0x73,0x63,0x6F,0x6E
	.DB  0x6E,0x65,0x63,0x74,0x65,0x64,0x0,0x2D
	.DB  0x0,0x3E,0x45,0x64,0x69,0x74,0x0,0x44
	.DB  0x65,0x62,0x75,0x67,0x0,0x54,0x65,0x6D
	.DB  0x70,0x20,0x72,0x61,0x6E,0x67,0x65,0x0
	.DB  0x50,0x61,0x74,0x74,0x65,0x72,0x6E,0x3A
	.DB  0x20,0x0,0x54,0x65,0x6D,0x70,0x3A,0x20
	.DB  0x6D,0x65,0x61,0x75,0x73,0x72,0x69,0x6E
	.DB  0x67,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _prevLet_G000
	.DW  _0xE*2

	.DW  0x02
	.DW  _0xE0
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0xE0+2
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0xE0+4
	.DW  _0x0*2+7

	.DW  0x02
	.DW  _0xE0+6
	.DW  _0x0*2+9

	.DW  0x0F
	.DW  _0xEB
	.DW  _0x0*2+11

	.DW  0x04
	.DW  _0xEB+15
	.DW  _0x0*2+26

	.DW  0x05
	.DW  _0xEB+19
	.DW  _0x0*2+30

	.DW  0x08
	.DW  _0xEB+24
	.DW  _0x0*2+35

	.DW  0x02
	.DW  _0xFA
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0xFA+2
	.DW  _0x0*2+43

	.DW  0x02
	.DW  _0xFA+4
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0xFA+6
	.DW  _0x0*2+43

	.DW  0x0B
	.DW  _0x10E
	.DW  _0x0*2+57

	.DW  0x07
	.DW  _0x10E+11
	.DW  _0x0*2+68

	.DW  0x0B
	.DW  _0x10E+18
	.DW  _0x0*2+75

	.DW  0x09
	.DW  _0x10E+29
	.DW  _0x0*2+86

	.DW  0x03
	.DW  _0x11C
	.DW  _0x0*2+95

	.DW  0x09
	.DW  _0x135
	.DW  _0x0*2+98

	.DW  0x07
	.DW  _0x135+9
	.DW  _0x0*2+107

	.DW  0x07
	.DW  _0x135+16
	.DW  _0x0*2+114

	.DW  0x02
	.DW  _0x139
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x140
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x140+2
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x140+4
	.DW  _0x0*2+7

	.DW  0x02
	.DW  _0x140+6
	.DW  _0x0*2+9

	.DW  0x10
	.DW  _0x147
	.DW  _0x0*2+121

	.DW  0x0F
	.DW  _0x147+16
	.DW  _0x0*2+137

	.DW  0x0B
	.DW  _0x147+31
	.DW  _0x0*2+152

	.DW  0x05
	.DW  _0x147+42
	.DW  _0x0*2+30

	.DW  0x08
	.DW  _0x147+47
	.DW  _0x0*2+35

	.DW  0x0B
	.DW  _0x14A
	.DW  _0x0*2+163

	.DW  0x0F
	.DW  _0x14A+11
	.DW  _0x0*2+174

	.DW  0x11
	.DW  _0x14A+26
	.DW  _0x0*2+189

	.DW  0x0F
	.DW  _0x14A+43
	.DW  _0x0*2+206

	.DW  0x11
	.DW  _0x14A+58
	.DW  _0x0*2+221

	.DW  0x11
	.DW  _0x14A+75
	.DW  _0x0*2+238

	.DW  0x02
	.DW  _0x14A+92
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x14A+94
	.DW  _0x0*2+255

	.DW  0x05
	.DW  _0x14A+96
	.DW  _0x0*2+30

	.DW  0x02
	.DW  _0x166
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x166+2
	.DW  _0x0*2+43

	.DW  0x02
	.DW  _0x166+4
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x166+6
	.DW  _0x0*2+43

	.DW  0x06
	.DW  _0x174
	.DW  _0x0*2+257

	.DW  0x09
	.DW  _0x174+6
	.DW  _0x0*2+77

	.DW  0x06
	.DW  _0x174+15
	.DW  _0x0*2+263

	.DW  0x0B
	.DW  _0x174+21
	.DW  _0x0*2+269

	.DW  0x0A
	.DW  _0x174+32
	.DW  _0x0*2+280

	.DW  0x10
	.DW  _0x174+42
	.DW  _0x0*2+290

	.DW  0x0A
	.DW  _0x17D
	.DW  _0x0*2+306

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <string.h>
;#include <delay.h>
;#include <interrupt.h>
;	flags -> R17

	.CSEG
;
;
;#include "usart.h"
;	data -> Y+0
;	pattern_no -> Y+0
;	pattern_no -> Y+0
;	block_no -> Y+0
;	byte_no -> Y+1
;	block_no -> Y+0
;	small -> Y+1
;	large -> Y+0
;	lightmicro_no -> Y+0
;#include "Includes/graph.h"
;#include "Includes/GLCD.h"

	.DSEG

	.CSEG
_trigger:
; .FSTART _trigger
	SBI  0x15,1
	__DELAY_USB 8
	CBI  0x15,1
	__DELAY_USB 8
	RET
; .FEND
;	line -> Y+0
_goto_col:
; .FSTART _goto_col
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+1
;	pattern -> R17
	CBI  0x12,7
	CBI  0x15,0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRSH _0x2F
	SBI  0x15,2
	CBI  0x15,3
	LDD  R17,Y+1
	RJMP _0x34
_0x2F:
	SBI  0x15,3
	CBI  0x15,2
	LDD  R30,Y+1
	SUBI R30,LOW(64)
	MOV  R17,R30
_0x34:
	MOV  R30,R17
	ORI  R30,0x40
	ANDI R30,0x7F
	MOV  R17,R30
	OUT  0x1B,R17
	RCALL _trigger
	LDD  R17,Y+0
	RJMP _0x20A0009
; .FEND
_goto_row:
; .FSTART _goto_row
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	y -> Y+1
;	pattern -> R17
	CBI  0x12,7
	CBI  0x15,0
	LDD  R30,Y+1
	ORI  R30,LOW(0xB8)
	ANDI R30,0xBF
	MOV  R17,R30
	OUT  0x1B,R17
	RCALL _trigger
	LDD  R17,Y+0
	RJMP _0x20A0009
; .FEND
_goto_xy:
; .FSTART _goto_xy
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+2
;	y -> Y+0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _goto_col
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _goto_row
	ADIW R28,4
	RET
; .FEND
_glcd_write:
; .FSTART _glcd_write
	ST   -Y,R26
;	b -> Y+0
	SBI  0x12,7
	CBI  0x15,0
	LD   R30,Y
	OUT  0x1B,R30
	__DELAY_USB 3
	RCALL _trigger
	RJMP _0x20A0006
; .FEND
_glcd_clrln:
; .FSTART _glcd_clrln
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	ln -> Y+2
;	i -> R16,R17
	CALL SUBOPT_0x0
	LDD  R26,Y+4
	CLR  R27
	RCALL _goto_xy
	CALL SUBOPT_0x1
	LDD  R26,Y+4
	CLR  R27
	RCALL _goto_xy
	SBI  0x15,2
	__GETWRN 16,17,0
_0x44:
	__CPWRN 16,17,65
	BRGE _0x45
	LDI  R26,LOW(0)
	RCALL _glcd_write
	__ADDWRN 16,17,1
	RJMP _0x44
_0x45:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0009:
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x47:
	__CPWRN 16,17,8
	BRGE _0x48
	MOV  R26,R16
	RCALL _glcd_clrln
	__ADDWRN 16,17,1
	RJMP _0x47
_0x48:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;	status -> R17
_glcd_read:
; .FSTART _glcd_read
	ST   -Y,R26
	ST   -Y,R17
;	column -> Y+1
;	read_data -> R17
	LDI  R17,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x15,0
	SBI  0x12,7
	LDD  R26,Y+1
	LDI  R30,LOW(64)
	CALL __LTB12U
	CPI  R30,0
	BRNE _0x5B
	CBI  0x15,2
	RJMP _0x5C
_0x5B:
	SBI  0x15,2
_0x5C:
	SBIS 0x15,2
	RJMP _0x5D
	CBI  0x15,3
	RJMP _0x5E
_0x5D:
	SBI  0x15,3
_0x5E:
	__DELAY_USB 3
	SBI  0x15,1
	__DELAY_USB 3
	CBI  0x15,1
	__DELAY_USB 53
	SBI  0x15,1
	__DELAY_USB 3
	IN   R17,25
	CBI  0x15,1
	__DELAY_USB 3
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
_point_at:
; .FSTART _point_at
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+4
;	y -> Y+2
;	color -> Y+1
;	pattern -> R17
	CALL SUBOPT_0x2
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,0
	BRNE _0x6A
	LDD  R30,Y+2
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	PUSH R30
	LDD  R26,Y+4
	RCALL _glcd_read
	POP  R26
	AND  R30,R26
	RJMP _0x18F
_0x6A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x69
	LDD  R30,Y+2
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	PUSH R30
	LDD  R26,Y+4
	RCALL _glcd_read
	POP  R26
	OR   R30,R26
_0x18F:
	MOV  R17,R30
_0x69:
	CALL SUBOPT_0x2
	MOV  R26,R17
	RCALL _glcd_write
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_h_line:
; .FSTART _h_line
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	x -> Y+7
;	y -> Y+5
;	l -> Y+4
;	s -> Y+3
;	c -> Y+2
;	i -> R16,R17
	__GETWRS 16,17,7
_0x6D:
	LDD  R30,Y+4
	LDI  R31,0
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADD  R30,R26
	ADC  R31,R27
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x6E
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	RCALL _point_at
	CALL SUBOPT_0x3
	RJMP _0x6D
_0x6E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
; .FEND
_v_line:
; .FSTART _v_line
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	x -> Y+8
;	y -> Y+6
;	l -> Y+4
;	s -> Y+3
;	c -> Y+2
;	i -> R16,R17
	__GETWRS 16,17,6
_0x70:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x71
	CALL SUBOPT_0x4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+6
	RCALL _point_at
	CALL SUBOPT_0x3
	RJMP _0x70
_0x71:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0008
; .FEND
;	x1 -> Y+22
;	y1 -> Y+20
;	x2 -> Y+18
;	y2 -> Y+16
;	s -> Y+15
;	c -> Y+14
;	i -> R17
;	y01 -> R16
;	temp -> R19
;	a -> Y+10
;	b -> Y+6
;	y00 -> R18
;	y010 -> R21
_rectangle:
; .FSTART _rectangle
	ST   -Y,R26
;	x1 -> Y+8
;	y1 -> Y+6
;	x2 -> Y+4
;	y2 -> Y+2
;	s -> Y+1
;	c -> Y+0
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	ADIW R30,1
	CALL SUBOPT_0x7
_0x20A0008:
	ADIW R28,10
	RET
; .FEND
;	x11 -> Y+16
;	y11 -> Y+14
;	x12 -> Y+12
;	y12 -> Y+10
;	x21 -> Y+8
;	y21 -> Y+6
;	x22 -> Y+4
;	y22 -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x1 -> Y+9
;	y1 -> Y+7
;	x2 -> Y+5
;	y2 -> Y+3
;	l -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x1 -> Y+9
;	y1 -> Y+7
;	x2 -> Y+5
;	y2 -> Y+3
;	l -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x11 -> Y+18
;	y11 -> Y+16
;	x12 -> Y+14
;	y12 -> Y+12
;	l1 -> Y+11
;	x21 -> Y+9
;	y21 -> Y+7
;	x22 -> Y+5
;	y22 -> Y+3
;	l2 -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x11 -> Y+18
;	y11 -> Y+16
;	x12 -> Y+14
;	y12 -> Y+12
;	l1 -> Y+11
;	x21 -> Y+9
;	y21 -> Y+7
;	x22 -> Y+5
;	y22 -> Y+3
;	l2 -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x0 -> Y+10
;	y0 -> Y+8
;	r -> Y+6
;	s -> Y+5
;	c -> Y+4
;	i -> R17
;	y -> R16
;	y00 -> R19
_putIt:
; .FSTART _putIt
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	c -> Y+5
;	x -> Y+3
;	y -> Y+1
;	i -> R17
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _goto_col
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _goto_row
	LDI  R17,LOW(0)
_0x86:
	CPI  R17,8
	BRSH _0x87
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	CALL SUBOPT_0x8
	LPM  R26,Z
	RCALL _glcd_write
	SUBI R17,-1
	RJMP _0x86
_0x87:
	LDD  R17,Y+0
	RJMP _0x20A0007
; .FEND
_enlarge:
; .FSTART _enlarge
	ST   -Y,R26
	CALL __SAVELOCR4
;	*large -> Y+6
;	c -> Y+5
;	size -> Y+4
;	i -> R17
;	j -> R16
;	temp -> R19
;	k -> R18
	LDI  R18,0
	LDI  R17,LOW(0)
_0x89:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0x8A
	LDI  R16,LOW(0)
_0x8C:
	CPI  R16,8
	BRSH _0x8D
	CALL SUBOPT_0x9
	LSR  R30
	ST   X,R30
	LDD  R30,Y+5
	ANDI R30,LOW(0x1)
	MOV  R19,R30
	CPI  R19,0
	BREQ _0x8E
	CALL SUBOPT_0x9
	ORI  R30,0x80
	ST   X,R30
_0x8E:
	SUBI R18,-LOW(1)
	LDD  R30,Y+4
	CP   R30,R18
	BRNE _0x8F
	LDD  R30,Y+5
	LSR  R30
	STD  Y+5,R30
	LDI  R18,LOW(0)
_0x8F:
	SUBI R16,-1
	RJMP _0x8C
_0x8D:
	SUBI R17,-1
	RJMP _0x89
_0x8A:
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND
_putItSz:
; .FSTART _putItSz
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,1
	CALL __SAVELOCR4
;	c -> Y+73
;	x -> Y+71
;	y -> Y+69
;	sz -> Y+68
;	i -> R17
;	j -> R16
;	k -> R19
;	large -> Y+4
	CALL SUBOPT_0xA
	RCALL _goto_col
	__GETW2SX 69
	RCALL _goto_row
	LDI  R17,LOW(0)
_0x91:
	CPI  R17,8
	BRSH _0x92
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 75
	CALL SUBOPT_0x8
	LPM  R30,Z
	ST   -Y,R30
	__GETB2SX 71
	RCALL _enlarge
	SUBI R17,-1
	RJMP _0x91
_0x92:
	LDI  R16,LOW(0)
_0x94:
	__GETB1SX 68
	CP   R16,R30
	BRLO PC+2
	RJMP _0x95
	LDI  R17,LOW(0)
_0x97:
	CPI  R17,8
	BRSH _0x98
	LDI  R19,LOW(0)
_0x9A:
	__GETB1SX 68
	CP   R19,R30
	BRSH _0x9B
	MOV  R30,R19
	LDI  R31,0
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	__GETB2SX 68
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	CALL __MULW12
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRNE _0x9C
	CALL SUBOPT_0x1
	CALL SUBOPT_0xA
	RCALL _goto_xy
_0x9C:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	LD   R26,X
	RCALL _glcd_write
	SUBI R19,-1
	RJMP _0x9A
_0x9B:
	SUBI R17,-1
	RJMP _0x97
_0x98:
	__GETW1SX 71
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(71))
	SBCI R27,HIGH(-(71))
	CALL SUBOPT_0xD
	MOVW R26,R30
	RCALL _goto_xy
	SUBI R16,-1
	RJMP _0x94
_0x95:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,12
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
;	c -> Y+6
;	x -> Y+4
;	y -> Y+2
;	l -> Y+1
;	sz -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x9D
	LDD  R30,Y+6
	LDI  R31,0
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0xA1
	LDI  R30,LOW(250)
	RJMP _0x191
_0xA1:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xA2
	LDI  R30,LOW(251)
	RJMP _0x191
_0xA2:
	CPI  R30,LOW(0x98)
	LDI  R26,HIGH(0x98)
	CPC  R31,R26
	BRNE _0xA3
	LDI  R30,LOW(252)
	RJMP _0x191
_0xA3:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0xA4
	LDI  R30,LOW(253)
	RJMP _0x191
_0xA4:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0xA0
	LDI  R30,LOW(254)
_0x191:
	STD  Y+6,R30
_0xA0:
	LDD  R26,Y+6
	CPI  R26,LOW(0xC1)
	BRLO _0xA7
	LDS  R26,_prevLet_G000
	LDS  R27,_prevLet_G000+1
	CPI  R26,LOW(0xC1)
	LDI  R30,HIGH(0xC1)
	CPC  R27,R30
	BRLT _0xA7
	CALL SUBOPT_0xE
	ADIW R30,5
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xA7
	CALL SUBOPT_0xF
	ADIW R30,4
	LPM  R30,Z
	CPI  R30,0
	BRNE _0xA8
_0xA7:
	RJMP _0xA6
_0xA8:
	CALL SUBOPT_0xE
	MOVW R26,R30
	LDS  R30,_stat_G000
	LDI  R31,0
	ADIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_prevX_G000
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_prevY_G000
	CLR  R27
	RCALL _putIt
	LDI  R30,LOW(2)
	RJMP _0x192
_0xA6:
	LDI  R30,LOW(0)
_0x192:
	STS  _stat_G000,R30
	LDD  R26,Y+6
	CPI  R26,LOW(0xC1)
	BRLO _0xAA
	CALL SUBOPT_0xF
	MOVW R26,R30
	LDS  R30,_stat_G000
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RJMP _0x193
_0xAA:
	LDD  R30,Y+6
_0x193:
	LDI  R31,0
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	RCALL _putItSz
	LDD  R30,Y+6
	LDI  R31,0
	STS  _prevLet_G000,R30
	STS  _prevLet_G000+1,R31
	LDD  R30,Y+4
	STS  _prevX_G000,R30
	LDD  R30,Y+2
	STS  _prevY_G000,R30
	RJMP _0xAC
_0x9D:
	LDD  R30,Y+6
	LDI  R31,0
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	RCALL _putItSz
_0xAC:
_0x20A0007:
	ADIW R28,7
	RET
; .FEND
_glcd_puts:
; .FSTART _glcd_puts
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*c -> Y+9
;	x -> Y+7
;	y -> Y+5
;	l -> Y+4
;	sz -> Y+3
;	space -> Y+2
;	i -> R17
;	special -> R16
	LDI  R17,0
	LDI  R16,0
_0xAD:
	CALL SUBOPT_0x11
	BRSH _0xB0
	LDD  R26,Y+4
	CPI  R26,LOW(0x0)
	BREQ _0xB1
_0xB0:
	RJMP _0xAF
_0xB1:
	CALL SUBOPT_0x12
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+7,R30
	STD  Y+7+1,R31
	CALL SUBOPT_0x15
	LDI  R26,LOW(128)
	LDI  R27,HIGH(128)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xB2
	LDI  R30,LOW(0)
	STD  Y+7,R30
	STD  Y+7+1,R30
	CALL SUBOPT_0x16
_0xB2:
	SUBI R17,-1
	RJMP _0xAD
_0xAF:
_0xB3:
	CALL SUBOPT_0x11
	BRSH _0xB6
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BREQ _0xB7
_0xB6:
	RJMP _0xB5
_0xB7:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0xE1)
	BRNE _0xB9
	CALL SUBOPT_0x17
	CPI  R26,LOW(0xC7)
	BREQ _0xBA
_0xB9:
	RJMP _0xB8
_0xBA:
	LDI  R16,LOW(249)
	RJMP _0xBB
_0xB8:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0xE1)
	BRNE _0xBD
	CALL SUBOPT_0x17
	CPI  R26,LOW(0xC3)
	BREQ _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
	LDI  R16,LOW(231)
	RJMP _0xBF
_0xBC:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0xE1)
	BRNE _0xC1
	CALL SUBOPT_0x17
	CPI  R26,LOW(0xC2)
	BREQ _0xC2
_0xC1:
	RJMP _0xC0
_0xC2:
	LDI  R16,LOW(232)
	RJMP _0xC3
_0xC0:
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0xE1)
	BRNE _0xC5
	CALL SUBOPT_0x17
	CPI  R26,LOW(0xC5)
	BREQ _0xC6
_0xC5:
	RJMP _0xC4
_0xC6:
	LDI  R16,LOW(233)
_0xC4:
_0xC3:
_0xBF:
_0xBB:
	CPI  R16,0
	BREQ _0xC7
	ST   -Y,R16
	CALL SUBOPT_0x18
	LDI  R30,LOW(1)
	CALL SUBOPT_0x13
	SUBI R17,-LOW(2)
	CALL SUBOPT_0x15
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x19
	LDI  R16,LOW(0)
	RJMP _0xC8
_0xC7:
	CALL SUBOPT_0x12
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x18
	LDD  R30,Y+9
	CALL SUBOPT_0x13
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x20)
	BRNE _0xC9
	CALL SUBOPT_0x14
	RJMP _0x194
_0xC9:
	CALL SUBOPT_0x15
_0x194:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x19
	SUBI R17,-1
_0xC8:
	CALL SUBOPT_0x15
	ADIW R30,1
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0xCB
	CALL SUBOPT_0x15
	LDI  R26,LOW(128)
	LDI  R27,HIGH(128)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x16
_0xCB:
	RJMP _0xB3
_0xB5:
	LDI  R30,LOW(193)
	LDI  R31,HIGH(193)
	STS  _prevLet_G000,R30
	STS  _prevLet_G000+1,R31
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,11
	RET
; .FEND
;	*bmp -> Y+12
;	x1 -> Y+10
;	y1 -> Y+8
;	x2 -> Y+6
;	y2 -> Y+4
;	i -> R16,R17
;	j -> R18,R19
;#include "Includes/seq2.h"
;
;
;eeprom char pattern[16][8][2];
;eeprom char pattern_no;
;
;
;char temp = 252;
;
;const signed char codes[] = {7, 8, 9, -1, 4, 5, 6, -1, 1, 2, 3, -1, -1, 0, -1, -1};
;
;/*
;    Input handlers
;*/
;void (*keypad_handler)(char) = 0;
;void (*button_handler)(char) = 0;
;
;void main_window(void);
;
;
;char temp_window_byte;
;char temp_window_selected;
;char temp_window_range_small;
;char temp_window_range_large;
;
;
;void temp_window_keypad(char key_num)
; 0000 0026 {
_temp_window_keypad:
; .FSTART _temp_window_keypad
; 0000 0027     char *byt = &temp_window_range_small;
; 0000 0028     if (temp_window_byte)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	key_num -> Y+2
;	*byt -> R16,R17
	__GETWRN 16,17,10
	TST  R4
	BREQ _0xD2
; 0000 0029         byt = &temp_window_range_large;
	__GETWRN 16,17,13
; 0000 002A 
; 0000 002B     if (codes[key_num] != -1) {
_0xD2:
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-_codes*2)
	SBCI R31,HIGH(-_codes*2)
	LPM  R26,Z
	CPI  R26,LOW(0xFF)
	BRNE PC+2
	RJMP _0xD3
; 0000 002C         char str[3];
; 0000 002D         char clear = 0;
; 0000 002E 
; 0000 002F         if (*byt > 9 || *byt == 0xFF) {
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
;	key_num -> Y+6
;	str -> Y+1
;	clear -> Y+0
	MOVW R26,R16
	LD   R26,X
	CPI  R26,LOW(0xA)
	BRSH _0xD5
	MOVW R26,R16
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BRNE _0xD4
_0xD5:
; 0000 0030             clear = 1;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0000 0031             *byt = codes[key_num];
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-_codes*2)
	SBCI R31,HIGH(-_codes*2)
	LPM  R30,Z
	MOVW R26,R16
	RJMP _0x195
; 0000 0032         }
; 0000 0033         else {
_0xD4:
; 0000 0034                 *byt *= 10;
	MOVW R30,R16
	MOVW R22,R30
	LD   R30,Z
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOVW R26,R22
	ST   X,R30
; 0000 0035                 *byt += codes[key_num];
	MOVW R30,R16
	MOVW R0,R30
	LD   R26,Z
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-_codes*2)
	SBCI R31,HIGH(-_codes*2)
	LPM  R30,Z
	ADD  R30,R26
	MOVW R26,R0
_0x195:
	ST   X,R30
; 0000 0036         }
; 0000 0037         if (clear)
	LD   R30,Y
	CPI  R30,0
	BREQ _0xD8
; 0000 0038             sprintf(str, "%d ", *byt);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,0
	RJMP _0x196
; 0000 0039         else
_0xD8:
; 0000 003A             sprintf(str, "%d", *byt);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,4
_0x196:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	LD   R30,X
	CALL SUBOPT_0x1B
; 0000 003B         glcd_puts(str, (4 + temp_window_byte * 5) * 8, 3, 0, 1, 0);
	CALL SUBOPT_0x1A
	MOV  R26,R4
	LDI  R30,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	ADIW R30,4
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 003C     }
	ADIW R28,4
; 0000 003D }
_0xD3:
	RJMP _0x20A0005
; .FEND
;
;
;void temp_window_button(char button_no)
; 0000 0041 {
_temp_window_button:
; .FSTART _temp_window_button
; 0000 0042     switch (button_no) {
	CALL SUBOPT_0x1E
;	button_no -> Y+0
; 0000 0043         case 1: // Up button
	BREQ _0xDE
; 0000 0044         case 4: // Down button
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xDF
_0xDE:
; 0000 0045             glcd_puts(" ", (6 - temp_window_selected * 2) * 8,
; 0000 0046                       6 + temp_window_selected, 0, 1, 0);
	__POINTW1MN _0xE0,0
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 0047             glcd_puts(" ", (9 + temp_window_selected * 2) * 8,
; 0000 0048                       6 + temp_window_selected, 0, 1, 0);
	__POINTW1MN _0xE0,2
	CALL SUBOPT_0x1F
	ADIW R30,9
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x21
; 0000 0049             temp_window_selected ^= 1;
	LDI  R30,LOW(1)
	EOR  R11,R30
; 0000 004A             glcd_puts("[", (6 - temp_window_selected * 2) * 8,
; 0000 004B                       6 + temp_window_selected, 0, 1, 0);
	__POINTW1MN _0xE0,4
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 004C             glcd_puts("]", (9 + temp_window_selected * 2) * 8,
; 0000 004D                       6 + temp_window_selected, 0, 1, 0);
	__POINTW1MN _0xE0,6
	CALL SUBOPT_0x1F
	ADIW R30,9
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x21
; 0000 004E         break;
	RJMP _0xDC
; 0000 004F         case 2: // Right button
_0xDF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0xE2
; 0000 0050         case 3: // Left button
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE3
_0xE2:
; 0000 0051             rectangle((4 + temp_window_byte * 5) * 8 - 3,
; 0000 0052                       3 * 8 - 3,
; 0000 0053                       (6 + temp_window_byte * 5) * 8 + 3,
; 0000 0054                       4 * 8 + 3, 0, 0);
	MOV  R26,R4
	LDI  R30,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	ADIW R30,4
	CALL __LSLW3
	SBIW R30,3
	CALL SUBOPT_0x22
	MOVW R30,R26
	ADIW R30,6
	CALL __LSLW3
	ADIW R30,3
	CALL SUBOPT_0x23
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rectangle
; 0000 0055             temp_window_byte ^= 1;
	LDI  R30,LOW(1)
	EOR  R4,R30
; 0000 0056             rectangle(4 * 8 - 3, 3 * 8 - 3, 6 * 8 + 3, 4 * 8 + 3, temp_window_byte ,1);
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	CALL SUBOPT_0x22
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	CALL SUBOPT_0x23
	ST   -Y,R4
	CALL SUBOPT_0x24
; 0000 0057             rectangle(9 * 8 - 3, 3 * 8 - 3, 11 * 8 + 3, 4 * 8 + 3, temp_window_byte ^ 1 ,1);
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	CALL SUBOPT_0x23
	LDI  R30,LOW(1)
	EOR  R30,R4
	CALL SUBOPT_0x25
; 0000 0058         break;
	RJMP _0xDC
; 0000 0059         case 0: // OK button
_0xE3:
	SBIW R30,0
	BRNE _0xDC
; 0000 005A             // OK is selected in menu
; 0000 005B             if (temp_window_selected == 0) {
	TST  R11
	BRNE _0xE5
; 0000 005C                 // If both ranges have values in them
; 0000 005D                 if (temp_window_range_small != 0xFF && temp_window_range_large != 0xFF) {
	LDI  R30,LOW(255)
	CP   R30,R10
	BREQ _0xE7
	CP   R30,R13
	BRNE _0xE8
_0xE7:
	RJMP _0xE6
_0xE8:
; 0000 005E                     // Swap range variables if second one is smaller than the first one
; 0000 005F                     if (temp_window_range_large < temp_window_range_small) {
	CP   R13,R10
	BRSH _0xE9
; 0000 0060                         char temporary = temp_window_range_large;
; 0000 0061                         temp_window_range_large = temp_window_range_small;
	SBIW R28,1
;	button_no -> Y+1
;	temporary -> Y+0
	__PUTBSR 13,0
	MOV  R13,R10
; 0000 0062                         temp_window_range_small = temporary;
	LDD  R10,Y+0
; 0000 0063                     }
	ADIW R28,1
; 0000 0064 
; 0000 0065                     send_range(temp_window_range_small, temp_window_range_large);
_0xE9:
	ST   -Y,R10
	MOV  R26,R13
	ST   -Y,R26
	LDI  R30,LOW(48)
	MOV  R26,R30
	ST   -Y,R26
_0x18007005:
	SBIS 0xB,5
	RJMP _0x18007005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	LDD  R30,Y+1
	MOV  R26,R30
	ST   -Y,R26
_0x1C007005:
	SBIS 0xB,5
	RJMP _0x1C007005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	LDI  R30,LOW(48)
	MOV  R26,R30
	ST   -Y,R26
_0x20007005:
	SBIS 0xB,5
	RJMP _0x20007005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	LD   R30,Y
	MOV  R26,R30
	ST   -Y,R26
_0x24007005:
	SBIS 0xB,5
	RJMP _0x24007005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	ADIW R28,2
; 0000 0066                     main_window();
	RCALL _main_window
; 0000 0067                 }
; 0000 0068             }
_0xE6:
; 0000 0069             // Cancel is selected in menu
; 0000 006A             else
	RJMP _0xEA
_0xE5:
; 0000 006B                 main_window();
	RCALL _main_window
; 0000 006C     }
_0xEA:
_0xDC:
; 0000 006D }
	RJMP _0x20A0006
; .FEND

	.DSEG
_0xE0:
	.BYTE 0x8
;
;
;void temp_window(void)
; 0000 0071 {

	.CSEG
_temp_window:
; .FSTART _temp_window
; 0000 0072     temp_window_byte = 0;
	CLR  R4
; 0000 0073     temp_window_selected = 0;
	CLR  R11
; 0000 0074     temp_window_range_small = 0xFF;
	LDI  R30,LOW(255)
	MOV  R10,R30
; 0000 0075     temp_window_range_large = 0xFF;
	MOV  R13,R30
; 0000 0076 
; 0000 0077     /*
; 0000 0078         Display
; 0000 0079     */
; 0000 007A     glcd_clear();
	RCALL _glcd_clear
; 0000 007B 
; 0000 007C     glcd_puts("Enter a range:", 0, 0, 0, 1, 0);
	__POINTW1MN _0xEB,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 007D     glcd_puts(" - ", 6 * 8, 3, 0, 1, 0);
	__POINTW1MN _0xEB,15
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1D
; 0000 007E     rectangle(4 * 8 - 3, 3 * 8 - 3, 6 * 8 + 3, 4 * 8 + 3, 0 ,1);
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	CALL SUBOPT_0x22
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	CALL SUBOPT_0x23
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x24
; 0000 007F     rectangle(9 * 8 - 3, 3 * 8 - 3, 11 * 8 + 3, 4 * 8 + 3, 1 ,1);
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	CALL SUBOPT_0x23
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
; 0000 0080     glcd_puts("[OK]", 6 * 8, 6, 0, 1, 0);
	__POINTW1MN _0xEB,19
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
; 0000 0081     glcd_puts(" Cancel", 4 * 8, 7, 0, 1, 0);
	__POINTW1MN _0xEB,24
	CALL SUBOPT_0x2A
; 0000 0082 
; 0000 0083     /*
; 0000 0084         Init input handlers
; 0000 0085     */
; 0000 0086     keypad_handler = &temp_window_keypad;
	LDI  R30,LOW(_temp_window_keypad)
	LDI  R31,HIGH(_temp_window_keypad)
	MOVW R6,R30
; 0000 0087     button_handler = &temp_window_button;
	LDI  R30,LOW(_temp_window_button)
	LDI  R31,HIGH(_temp_window_button)
	MOVW R8,R30
; 0000 0088 
; 0000 0089 }
	RET
; .FEND

	.DSEG
_0xEB:
	.BYTE 0x20
;
;/*
;    Draws a single LED
;*/
;inline void draw_led(unsigned int x, unsigned int y)
; 0000 008F {
; 0000 0090     rectangle(x - 1, y - 1, x + 1, y + 1, 0, 1);
;	x -> Y+2
;	y -> Y+0
; 0000 0091 }
;
;/*
;    Draws a block of LEDs
;*/
;inline void draw_block(unsigned int x, unsigned int y)
; 0000 0097 {
; 0000 0098     char i, j;
; 0000 0099 
; 0000 009A     for (i = 0; i < 4; i++)
;	x -> Y+4
;	y -> Y+2
;	i -> R17
;	j -> R16
; 0000 009B         for (j = 0; j < 4; j++)
; 0000 009C             draw_led(x + (i * 4) + 1, y + (j * 4) + 1);
; 0000 009D }
;
;// Active block number in edit window
;char edit_window_block_no;
;
;/*
;    Draws a border line for active block in edit window
;*/
;inline void draw_block_border(char black_dot)
; 0000 00A6 {
; 0000 00A7     char block_x = (edit_window_block_no % 4) * 16,
; 0000 00A8          block_y = (edit_window_block_no / 4) * 16;
; 0000 00A9 
; 0000 00AA     h_line(block_x, block_y, 15, 0, black_dot);
;	black_dot -> Y+2
;	block_x -> R17
;	block_y -> R16
; 0000 00AB     h_line(block_x, block_y + 14, 15, 0, black_dot);
; 0000 00AC     v_line(block_x + 14, block_y, 15, 0, black_dot);
; 0000 00AD     v_line(block_x, block_y, 15, 0, black_dot);
; 0000 00AE 
; 0000 00AF     if (!black_dot)
; 0000 00B0         draw_block(block_x, block_y);
; 0000 00B1 }
;
;// Current state of pattern which is being edited in edit window
;char edit_window_pattern[16][2];
;
;char activate_window_pattern_no;
;
;
;char edit_window_selected;
;
;
;void edit_window(char);
;
;
;void edit_window_menu_button(char button_no)
; 0000 00C0 {

	.CSEG
_edit_window_menu_button:
; .FSTART _edit_window_menu_button
; 0000 00C1     switch (button_no) {
	CALL SUBOPT_0x1E
;	button_no -> Y+0
; 0000 00C2         case 1: // Up
	BRNE _0xF9
; 0000 00C3             glcd_puts(" ", 0, edit_window_selected + 2, 0, 1, 0);
	__POINTW1MN _0xFA,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2B
; 0000 00C4             if (edit_window_selected == 0) {
	LDS  R30,_edit_window_selected
	CPI  R30,0
	BRNE _0xFB
; 0000 00C5                 edit_window_selected = 3;
	LDI  R30,LOW(3)
	RJMP _0x197
; 0000 00C6             }
; 0000 00C7             else {
_0xFB:
; 0000 00C8                 edit_window_selected -= 1;
	LDS  R30,_edit_window_selected
	SUBI R30,LOW(1)
_0x197:
	STS  _edit_window_selected,R30
; 0000 00C9             }
; 0000 00CA             glcd_puts(">", 0, edit_window_selected + 2, 0, 1, 0);
	__POINTW1MN _0xFA,2
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2B
; 0000 00CB         break;
	RJMP _0xF8
; 0000 00CC         case 4: // Down
_0xF9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xFD
; 0000 00CD             glcd_puts(" ", 0, edit_window_selected + 2, 0, 1, 0);
	__POINTW1MN _0xFA,4
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2B
; 0000 00CE             edit_window_selected = (edit_window_selected + 1) % 4;
	LDS  R30,_edit_window_selected
	CALL SUBOPT_0x2C
	STS  _edit_window_selected,R30
; 0000 00CF             glcd_puts(">", 0, edit_window_selected + 2, 0, 1, 0);
	__POINTW1MN _0xFA,6
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2B
; 0000 00D0         break;
	RJMP _0xF8
; 0000 00D1         case 0: // OK
_0xFD:
	SBIW R30,0
	BREQ PC+2
	RJMP _0xF8
; 0000 00D2         switch (edit_window_selected) {
	LDS  R30,_edit_window_selected
	LDI  R31,0
; 0000 00D3             case 0: // Continue
	SBIW R30,0
	BRNE _0x102
; 0000 00D4                 edit_window(0);
	LDI  R26,LOW(0)
	RCALL _edit_window
; 0000 00D5             break;
	RJMP _0x101
; 0000 00D6             case 1: // Save
_0x102:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x104
; 0000 00D7             case 2: // Activate
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x105
_0x104:
; 0000 00D8                 {
; 0000 00D9                     char i, j;
; 0000 00DA 
; 0000 00DB                     for (i = 0; i < 16; i++)
	SBIW R28,2
;	button_no -> Y+2
;	i -> Y+1
;	j -> Y+0
	LDI  R30,LOW(0)
	STD  Y+1,R30
_0x107:
	LDD  R26,Y+1
	CPI  R26,LOW(0x10)
	BRSH _0x108
; 0000 00DC                         for (j = 0; j < 2; j++)
	LDI  R30,LOW(0)
	ST   Y,R30
_0x10A:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRSH _0x10B
; 0000 00DD                             pattern[i][activate_window_pattern_no][j] = edit_window_pattern[i][j];
	LDD  R30,Y+1
	CALL SUBOPT_0x2D
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x2E
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	CALL __EEPROMWRB
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x10A
_0x10B:
; 0000 00DF send_pattern(pattern, activate_window_pattern_no);
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x107
_0x108:
	LDI  R30,LOW(_pattern)
	LDI  R31,HIGH(_pattern)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_activate_window_pattern_no
	CALL _send_pattern
; 0000 00E0 
; 0000 00E1                     if (edit_window_selected == 2) {
	LDS  R26,_edit_window_selected
	CPI  R26,LOW(0x2)
	BRNE _0x10C
; 0000 00E2                         pattern_no = activate_window_pattern_no;
	CALL SUBOPT_0x2F
; 0000 00E3                         send_active_pattern(activate_window_pattern_no);
	ST   -Y,R26
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	ORI  R30,0x80
	MOV  R26,R30
	ST   -Y,R26
_0x8003005:
	SBIS 0xB,5
	RJMP _0x8003005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	ADIW R28,1
; 0000 00E4                     }
; 0000 00E5 
; 0000 00E6                     main_window();
_0x10C:
	RCALL _main_window
; 0000 00E7                 }
	ADIW R28,2
; 0000 00E8             break;
	RJMP _0x101
; 0000 00E9             case 3: // Cancel
_0x105:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x101
; 0000 00EA                 main_window();
	RCALL _main_window
; 0000 00EB             break;
; 0000 00EC         }
_0x101:
; 0000 00ED     }
_0xF8:
; 0000 00EE }
_0x20A0006:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_0xFA:
	.BYTE 0x8
;
;
;void edit_window_menu()
; 0000 00F2 {

	.CSEG
_edit_window_menu:
; .FSTART _edit_window_menu
; 0000 00F3     edit_window_selected = 0;
	LDI  R30,LOW(0)
	STS  _edit_window_selected,R30
; 0000 00F4 
; 0000 00F5     /*
; 0000 00F6         Init input handlers
; 0000 00F7     */
; 0000 00F8     keypad_handler = 0;
	CLR  R6
	CLR  R7
; 0000 00F9     button_handler = &edit_window_menu_button;
	LDI  R30,LOW(_edit_window_menu_button)
	LDI  R31,HIGH(_edit_window_menu_button)
	MOVW R8,R30
; 0000 00FA 
; 0000 00FB     /*
; 0000 00FC         Display
; 0000 00FD     */
; 0000 00FE     glcd_clear();
	RCALL _glcd_clear
; 0000 00FF 
; 0000 0100     {
; 0000 0101         char str[9];
; 0000 0102         sprintf(str, "Pattern: %d", activate_window_pattern_no + 1);
	SBIW R28,9
;	str -> Y+0
	CALL SUBOPT_0x30
	__POINTW1FN _0x0,45
	CALL SUBOPT_0x31
; 0000 0103         glcd_puts(str, 0, 0, 0, 1, 0);
	MOVW R30,R28
	CALL SUBOPT_0x26
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 0104     }
	ADIW R28,9
; 0000 0105 
; 0000 0106     glcd_puts("> Continue", 0, 2, 0, 1, 0);
	__POINTW1MN _0x10E,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x32
; 0000 0107     glcd_puts("  Save", 0, 3, 0, 1, 0);
	__POINTW1MN _0x10E,11
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1D
; 0000 0108     glcd_puts("  Activate", 0, 4, 0, 1, 0);
	__POINTW1MN _0x10E,18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x33
; 0000 0109     glcd_puts("  Cancel", 0, 5, 0, 1, 0);
	__POINTW1MN _0x10E,29
	CALL SUBOPT_0x26
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x34
; 0000 010A }
	RET
; .FEND

	.DSEG
_0x10E:
	.BYTE 0x26
;
;
;void edit_window_button(char button_no)
; 0000 010E {

	.CSEG
_edit_window_button:
; .FSTART _edit_window_button
; 0000 010F     if (button_no != 0)
	ST   -Y,R26
;	button_no -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE PC+2
	RJMP _0x10F
; 0000 0110         draw_block_border(0);
	LDI  R26,LOW(0)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	MOV  R30,R12
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R17,R0
	MOV  R26,R12
	LDI  R27,0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R16,R0
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+8
	RCALL _h_line
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+8
	RCALL _h_line
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+9
	RCALL _v_line
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+9
	RCALL _v_line
	LDD  R30,Y+2
	CPI  R30,0
	BREQ PC+2
	RJMP _0x400A0F5
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R30
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDI  R17,LOW(0)
_0x80030EF:
	CPI  R17,4
	BRSH _0x80030F0
	LDI  R16,LOW(0)
_0x80030F2:
	CPI  R16,4
	BRSH _0x80030F3
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	MUL  R30,R16
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
	ADIW R28,4
	SUBI R16,-1
	RJMP _0x80030F2
_0x80030F3:
	SUBI R17,-1
	RJMP _0x80030EF
_0x80030F0:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
_0x400A0F5:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
; 0000 0111 
; 0000 0112     switch (button_no) {
_0x10F:
	LD   R30,Y
	LDI  R31,0
; 0000 0113         case 1: // Up button
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x113
; 0000 0114             if (edit_window_block_no < 4)
	LDI  R30,LOW(4)
	CP   R12,R30
	BRSH _0x114
; 0000 0115                 edit_window_block_no += 12;
	LDI  R30,LOW(12)
	ADD  R12,R30
; 0000 0116             else
	RJMP _0x115
_0x114:
; 0000 0117                 edit_window_block_no -= 4;
	LDI  R30,LOW(4)
	SUB  R12,R30
; 0000 0118         break;
_0x115:
	RJMP _0x112
; 0000 0119         case 4: // Down button
_0x113:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x116
; 0000 011A             edit_window_block_no = (edit_window_block_no + 4) % 16;
	MOV  R30,R12
	LDI  R31,0
	ADIW R30,4
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL __MANDW12
	MOV  R12,R30
; 0000 011B         break;
	RJMP _0x112
; 0000 011C         case 2: // Right button
_0x116:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x117
; 0000 011D             edit_window_block_no = (edit_window_block_no + 1) % 16;
	MOV  R30,R12
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL __MANDW12
	MOV  R12,R30
; 0000 011E         break;
	RJMP _0x112
; 0000 011F         case 3: // Left button
_0x117:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x118
; 0000 0120             if (edit_window_block_no == 0)
	TST  R12
	BRNE _0x119
; 0000 0121                 edit_window_block_no = 15;
	LDI  R30,LOW(15)
	MOV  R12,R30
; 0000 0122             else
	RJMP _0x11A
_0x119:
; 0000 0123                 edit_window_block_no--;
	DEC  R12
; 0000 0124         break;
_0x11A:
	RJMP _0x112
; 0000 0125         case 0: // OK button - Menu
_0x118:
	SBIW R30,0
	BRNE _0x112
; 0000 0126             edit_window_menu();
	RCALL _edit_window_menu
; 0000 0127             return;
	RJMP _0x20A0004
; 0000 0128         break;
; 0000 0129     }
_0x112:
; 0000 012A 
; 0000 012B     draw_block_border(1);
	LDI  R26,LOW(1)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	MOV  R30,R12
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R17,R0
	MOV  R26,R12
	LDI  R27,0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R16,R0
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+8
	RCALL _h_line
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+8
	RCALL _h_line
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+9
	RCALL _v_line
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+9
	RCALL _v_line
	LDD  R30,Y+2
	CPI  R30,0
	BREQ PC+2
	RJMP _0x1000A0F5
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R30
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDI  R17,LOW(0)
_0x140030EF:
	CPI  R17,4
	BRSH _0x140030F0
	LDI  R16,LOW(0)
_0x140030F2:
	CPI  R16,4
	BRSH _0x140030F3
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	MUL  R30,R16
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
	ADIW R28,4
	SUBI R16,-1
	RJMP _0x140030F2
_0x140030F3:
	SUBI R17,-1
	RJMP _0x140030EF
_0x140030F0:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
_0x1000A0F5:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
; 0000 012C     {
; 0000 012D         char str[3];
; 0000 012E         glcd_puts("  ", 64 + 3 * 8, 3, 0, 1, 0);
	SBIW R28,3
;	button_no -> Y+3
;	str -> Y+0
	__POINTW1MN _0x11C,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x35
; 0000 012F         sprintf(str, "%d", edit_window_block_no + 1);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x36
; 0000 0130         glcd_puts(str, 64 + 3 * 8, 3, 0, 1, 0);
	CALL SUBOPT_0x35
; 0000 0131     }
	ADIW R28,3
; 0000 0132 
; 0000 0133 }
	RJMP _0x20A0004
; .FEND

	.DSEG
_0x11C:
	.BYTE 0x3
;
;
;void edit_window_keypad(char key_no)
; 0000 0137 {

	.CSEG
_edit_window_keypad:
; .FSTART _edit_window_keypad
; 0000 0138     char led_x = ((edit_window_block_no % 4) * 16) + ((key_no % 4) * 4) + 1,
; 0000 0139          led_y = ((edit_window_block_no / 4) * 16) + ((key_no / 4) * 4) + 1,
; 0000 013A          led_bit;
; 0000 013B 
; 0000 013C     edit_window_pattern[edit_window_block_no][key_no / 8] ^= (1<<(key_no % 8));
	ST   -Y,R26
	CALL __SAVELOCR4
;	key_no -> Y+4
;	led_x -> R17
;	led_y -> R16
;	led_bit -> R19
	CALL SUBOPT_0x37
	LDD  R30,Y+4
	CALL SUBOPT_0x38
	LSL  R30
	LSL  R30
	ADD  R30,R0
	SUBI R30,-LOW(1)
	MOV  R17,R30
	CALL SUBOPT_0x39
	MOV  R22,R0
	LDD  R26,Y+4
	CALL SUBOPT_0x3A
	LSL  R30
	LSL  R30
	ADD  R30,R22
	SUBI R30,-LOW(1)
	MOV  R16,R30
	MOV  R30,R12
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x3B
	ADD  R30,R22
	ADC  R31,R23
	MOVW R22,R30
	LD   R1,Z
	CALL SUBOPT_0x3C
	EOR  R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 013D     led_bit = edit_window_pattern[edit_window_block_no][key_no / 8] & (1<<(key_no % 8));
	MOV  R30,R12
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x3B
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LD   R1,X
	CALL SUBOPT_0x3C
	AND  R30,R1
	MOV  R19,R30
; 0000 013E     if (led_bit == 0)
	CPI  R19,0
	BRNE _0x11D
; 0000 013F         point_at(led_x, led_y, 0);
	CALL SUBOPT_0x3D
	LDI  R26,LOW(0)
	RJMP _0x198
; 0000 0140     else
_0x11D:
; 0000 0141         point_at(led_x, led_y, 1);
	CALL SUBOPT_0x3D
	LDI  R26,LOW(1)
_0x198:
	RCALL _point_at
; 0000 0142 }
	CALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
;
;
;void edit_window(char new_window)
; 0000 0146 {
_edit_window:
; .FSTART _edit_window
; 0000 0147     char i, j;
; 0000 0148 
; 0000 0149     glcd_clear();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	new_window -> Y+2
;	i -> R17
;	j -> R16
	RCALL _glcd_clear
; 0000 014A 
; 0000 014B     // Draws blocks and LEDs
; 0000 014C     for (i = 0; i < 4; i++)
	LDI  R17,LOW(0)
_0x120:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x121
; 0000 014D         for (j = 0; j < 4; j++)
	LDI  R16,LOW(0)
_0x123:
	CPI  R16,4
	BRLO PC+2
	RJMP _0x124
; 0000 014E             draw_block(16 * i, 16 * j);
	LDI  R26,LOW(16)
	MUL  R17,R26
	ST   -Y,R1
	ST   -Y,R0
	MUL  R16,R26
	MOVW R30,R0
	MOVW R26,R30
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDI  R17,LOW(0)
_0xC0090EF:
	CPI  R17,4
	BRSH _0xC0090F0
	LDI  R16,LOW(0)
_0xC0090F2:
	CPI  R16,4
	BRSH _0xC0090F3
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	MUL  R30,R16
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
	ADIW R28,4
	SUBI R16,-1
	RJMP _0xC0090F2
_0xC0090F3:
	SUBI R17,-1
	RJMP _0xC0090EF
_0xC0090F0:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	SUBI R16,-1
	RJMP _0x123
_0x124:
; 0000 0150 if (new_window) {
	SUBI R17,-1
	RJMP _0x120
_0x121:
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x125
; 0000 0151         // Copies pattern from EEPROM to a SRAM array
; 0000 0152         for (i = 0; i < 16; i++)
	LDI  R17,LOW(0)
_0x127:
	CPI  R17,16
	BRSH _0x128
; 0000 0153             for (j = 0; j < 2; j++)
	LDI  R16,LOW(0)
_0x12A:
	CPI  R16,2
	BRSH _0x12B
; 0000 0154                 edit_window_pattern[i][j] = pattern[i][activate_window_pattern_no][j];
	MOV  R30,R17
	CALL SUBOPT_0x2E
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	CALL SUBOPT_0x2D
	CALL SUBOPT_0xC
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x12A
_0x12B:
; 0000 0155 }
	SUBI R17,-1
	RJMP _0x127
_0x128:
; 0000 0156 
; 0000 0157     // Draws LED states
; 0000 0158     for (i = 0; i < 16; i++) {
_0x125:
	LDI  R17,LOW(0)
_0x12D:
	CPI  R17,16
	BRLO PC+2
	RJMP _0x12E
; 0000 0159         for (j = 0; j < 16; j++) {
	LDI  R16,LOW(0)
_0x130:
	CPI  R16,16
	BRLO PC+2
	RJMP _0x131
; 0000 015A             char led_x = ((i % 4) * 16) + ((j % 4) * 4) + 1,
; 0000 015B                  led_y = ((i / 4) * 16) + ((j / 4) * 4) + 1,
; 0000 015C                  led_bit = edit_window_pattern[i][j / 8] & (1<<(j % 8));
; 0000 015D 
; 0000 015E             if (led_bit == 0)
	SBIW R28,3
;	new_window -> Y+5
;	led_x -> Y+2
;	led_y -> Y+1
;	led_bit -> Y+0
	MOV  R30,R17
	CALL SUBOPT_0x38
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R30,R16
	CALL SUBOPT_0x38
	LSL  R30
	LSL  R30
	ADD  R30,R0
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	MOV  R26,R17
	CALL SUBOPT_0x3A
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R22,R0
	MOV  R26,R16
	CALL SUBOPT_0x3A
	LSL  R30
	LSL  R30
	ADD  R30,R22
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	MOV  R30,R17
	CALL SUBOPT_0x2E
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LD   R1,X
	MOV  R30,R16
	LDI  R31,0
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	ST   Y,R30
	CPI  R30,0
	BRNE _0x132
; 0000 015F                 point_at(led_x, led_y, 0);
	CALL SUBOPT_0x3E
	LDI  R26,LOW(0)
	RJMP _0x199
; 0000 0160             else
_0x132:
; 0000 0161                 point_at(led_x, led_y, 1);
	CALL SUBOPT_0x3E
	LDI  R26,LOW(1)
_0x199:
	RCALL _point_at
; 0000 0162         }
	ADIW R28,3
	SUBI R16,-1
	RJMP _0x130
_0x131:
; 0000 0163     }
	SUBI R17,-1
	RJMP _0x12D
_0x12E:
; 0000 0164 
; 0000 0165     if (new_window)
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x134
; 0000 0166         edit_window_block_no = 0;
	CLR  R12
; 0000 0167     draw_block_border(1);
_0x134:
	LDI  R26,LOW(1)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x37
	MOV  R17,R0
	CALL SUBOPT_0x39
	MOV  R16,R0
	CALL SUBOPT_0x3D
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+8
	RCALL _h_line
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+8
	RCALL _h_line
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+9
	RCALL _v_line
	CALL SUBOPT_0x3D
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+9
	RCALL _v_line
	LDD  R30,Y+2
	CPI  R30,0
	BREQ PC+2
	RJMP _0x1C00A0F5
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R30
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDI  R17,LOW(0)
_0x200030EF:
	CPI  R17,4
	BRSH _0x200030F0
	LDI  R16,LOW(0)
_0x200030F2:
	CPI  R16,4
	BRSH _0x200030F3
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	MUL  R30,R16
	MOVW R30,R0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	CALL SUBOPT_0x10
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
	ADIW R28,4
	SUBI R16,-1
	RJMP _0x200030F2
_0x200030F3:
	SUBI R17,-1
	RJMP _0x200030EF
_0x200030F0:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
_0x1C00A0F5:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
; 0000 0168 
; 0000 0169     {
; 0000 016A         char str[9];
; 0000 016B         glcd_puts("Pattern:", 64, 0, 0, 1, 0);
	SBIW R28,9
;	new_window -> Y+11
;	str -> Y+0
	__POINTW1MN _0x135,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 016C         sprintf(str, "%d", activate_window_pattern_no + 1);
	CALL SUBOPT_0x30
	__POINTW1FN _0x0,4
	CALL SUBOPT_0x31
; 0000 016D         glcd_puts(str, 64 + 28, 1, 0, 1, 0);
	CALL SUBOPT_0x30
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x3F
; 0000 016E         glcd_puts("Block:", 64 + 1 * 8, 2, 0, 1, 0);
	__POINTW1MN _0x135,9
	CALL SUBOPT_0x40
	CALL SUBOPT_0x32
; 0000 016F         sprintf(str, "%d", edit_window_block_no + 1);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x36
; 0000 0170         glcd_puts(str, 64 + 3 * 8, 3, 0, 1, 0);
	CALL SUBOPT_0x35
; 0000 0171         glcd_puts("[Menu]", 64 + 1 * 8, 7, 0, 1, 0);
	__POINTW1MN _0x135,16
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
; 0000 0172     }
	ADIW R28,9
; 0000 0173 
; 0000 0174     /*
; 0000 0175         Init input handlers
; 0000 0176     */
; 0000 0177     keypad_handler = &edit_window_keypad;
	LDI  R30,LOW(_edit_window_keypad)
	LDI  R31,HIGH(_edit_window_keypad)
	MOVW R6,R30
; 0000 0178     button_handler = &edit_window_button;
	LDI  R30,LOW(_edit_window_button)
	LDI  R31,HIGH(_edit_window_button)
	MOVW R8,R30
; 0000 0179 }
_0x20A0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND

	.DSEG
_0x135:
	.BYTE 0x17
;
;
;char activate_window_selected;
;char activate_window_mode;
;
;void activate_window_keypad(char key_num)
; 0000 0180 {

	.CSEG
_activate_window_keypad:
; .FSTART _activate_window_keypad
; 0000 0181     if (codes[key_num] != -1 && codes[key_num] != 0) {
	ST   -Y,R26
;	key_num -> Y+0
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_codes*2)
	SBCI R31,HIGH(-_codes*2)
	LPM  R26,Z
	CPI  R26,LOW(0xFF)
	BREQ _0x137
	LPM  R26,Z
	CPI  R26,LOW(0x0)
	BRNE _0x138
_0x137:
	RJMP _0x136
_0x138:
; 0000 0182         char str[3];
; 0000 0183         glcd_puts(" ", 7 * 8, 4, 0, 1, 0);
	SBIW R28,3
;	key_num -> Y+3
;	str -> Y+0
	__POINTW1MN _0x139,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x42
; 0000 0184         activate_window_pattern_no = codes[key_num];
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_codes*2)
	SBCI R31,HIGH(-_codes*2)
	LPM  R0,Z
	STS  _activate_window_pattern_no,R0
; 0000 0185         sprintf(str, "%d", activate_window_pattern_no);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x43
	LDS  R30,_activate_window_pattern_no
	CALL SUBOPT_0x1B
; 0000 0186         glcd_puts(str, 7 * 8, 4, 0, 1, 0);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x42
; 0000 0187     }
	ADIW R28,3
; 0000 0188 }
_0x136:
	RJMP _0x20A0004
; .FEND

	.DSEG
_0x139:
	.BYTE 0x2
;
;
;void activate_window_button(char button_no)
; 0000 018C {

	.CSEG
_activate_window_button:
; .FSTART _activate_window_button
; 0000 018D     switch (button_no) {
	CALL SUBOPT_0x1E
;	button_no -> Y+0
; 0000 018E         case 1: // Up button
	BREQ _0x13E
; 0000 018F         case 4: // Down button
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x13F
_0x13E:
; 0000 0190             glcd_puts(" ", (6 - activate_window_selected * 2) * 8,
; 0000 0191                       6 + activate_window_selected, 0, 1, 0);
	__POINTW1MN _0x140,0
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
; 0000 0192             glcd_puts(" ", (9 + activate_window_selected * 2) * 8,
; 0000 0193                       6 + activate_window_selected, 0, 1, 0);
	__POINTW1MN _0x140,2
	CALL SUBOPT_0x44
	ADIW R30,9
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x46
; 0000 0194             activate_window_selected ^= 1;
	LDS  R26,_activate_window_selected
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _activate_window_selected,R30
; 0000 0195             glcd_puts("[", (6 - activate_window_selected * 2) * 8,
; 0000 0196                       6 + activate_window_selected, 0, 1, 0);
	__POINTW1MN _0x140,4
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
; 0000 0197             glcd_puts("]", (9 + activate_window_selected * 2) * 8,
; 0000 0198                       6 + activate_window_selected, 0, 1, 0);
	__POINTW1MN _0x140,6
	CALL SUBOPT_0x44
	ADIW R30,9
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x46
; 0000 0199         break;
	RJMP _0x13C
; 0000 019A         case 0: // OK button
_0x13F:
	SBIW R30,0
	BRNE _0x13C
; 0000 019B             // If OK is selected in menu
; 0000 019C             if (activate_window_selected == 0) {
	LDS  R30,_activate_window_selected
	CPI  R30,0
	BRNE _0x142
; 0000 019D                 // If pattern number is not empty
; 0000 019E                 if (activate_window_pattern_no != 0xFF) {
	LDS  R26,_activate_window_pattern_no
	CPI  R26,LOW(0xFF)
	BREQ _0x143
; 0000 019F                     activate_window_pattern_no--;
	LDS  R30,_activate_window_pattern_no
	SUBI R30,LOW(1)
	STS  _activate_window_pattern_no,R30
; 0000 01A0                     // Change active pattern and send them to lightmicros
; 0000 01A1                     if (activate_window_mode == 0) {
	LDS  R30,_activate_window_mode
	CPI  R30,0
	BRNE _0x144
; 0000 01A2                         pattern_no = activate_window_pattern_no;
	CALL SUBOPT_0x2F
; 0000 01A3                         send_active_pattern(activate_window_pattern_no);
	ST   -Y,R26
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	ORI  R30,0x80
	MOV  R26,R30
	ST   -Y,R26
_0x10003005:
	SBIS 0xB,5
	RJMP _0x10003005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	ADIW R28,1
; 0000 01A4                         main_window();
	RCALL _main_window
; 0000 01A5                     }
; 0000 01A6                     // Go to edit window
; 0000 01A7                     else
	RJMP _0x145
_0x144:
; 0000 01A8                         edit_window(1);
	LDI  R26,LOW(1)
	RCALL _edit_window
; 0000 01A9                 }
_0x145:
; 0000 01AA             }
_0x143:
; 0000 01AB             // If cancel is selected in menu
; 0000 01AC             else
	RJMP _0x146
_0x142:
; 0000 01AD                 main_window();
	RCALL _main_window
; 0000 01AE         break;
_0x146:
; 0000 01AF     }
_0x13C:
; 0000 01B0 }
	RJMP _0x20A0004
; .FEND

	.DSEG
_0x140:
	.BYTE 0x8
;
;
;void activate_window(char mode)
; 0000 01B4 {

	.CSEG
_activate_window:
; .FSTART _activate_window
; 0000 01B5     activate_window_selected = 0;
	ST   -Y,R26
;	mode -> Y+0
	LDI  R30,LOW(0)
	STS  _activate_window_selected,R30
; 0000 01B6     activate_window_mode = mode;
	LD   R30,Y
	STS  _activate_window_mode,R30
; 0000 01B7     activate_window_pattern_no = 0xFF;
	LDI  R30,LOW(255)
	STS  _activate_window_pattern_no,R30
; 0000 01B8 
; 0000 01B9     /*
; 0000 01BA         Display
; 0000 01BB     */
; 0000 01BC     glcd_clear();
	CALL _glcd_clear
; 0000 01BD 
; 0000 01BE     glcd_puts("Enter a pattern", 0, 0, 0, 1, 0);
	__POINTW1MN _0x147,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 01BF     glcd_puts("number between", 0, 1, 0, 1, 0);
	__POINTW1MN _0x147,16
	CALL SUBOPT_0x26
	CALL SUBOPT_0x47
; 0000 01C0     glcd_puts("1 and 8 : ", 0, 2, 0, 1, 0);
	__POINTW1MN _0x147,31
	CALL SUBOPT_0x26
	CALL SUBOPT_0x32
; 0000 01C1 
; 0000 01C2     rectangle(7 * 8 - 3, 4 * 8 - 3, 8 * 8 + 3, 5 * 8 + 3, 0 ,1);
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
; 0000 01C3 
; 0000 01C4     glcd_puts("[OK]", 6 * 8, 6, 0, 1, 0);
	__POINTW1MN _0x147,42
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
; 0000 01C5     glcd_puts(" Cancel", 4 * 8, 7, 0, 1, 0);
	__POINTW1MN _0x147,47
	CALL SUBOPT_0x2A
; 0000 01C6 
; 0000 01C7     /*
; 0000 01C8         Init input handlers
; 0000 01C9     */
; 0000 01CA     keypad_handler = &activate_window_keypad;
	LDI  R30,LOW(_activate_window_keypad)
	LDI  R31,HIGH(_activate_window_keypad)
	MOVW R6,R30
; 0000 01CB     button_handler = &activate_window_button;
	LDI  R30,LOW(_activate_window_button)
	LDI  R31,HIGH(_activate_window_button)
	MOVW R8,R30
; 0000 01CC }
	RJMP _0x20A0004
; .FEND

	.DSEG
_0x147:
	.BYTE 0x37
;
;void debug_window_button(char button_no)
; 0000 01CF {

	.CSEG
_debug_window_button:
; .FSTART _debug_window_button
; 0000 01D0     if (button_no == 0) // OK
	ST   -Y,R26
;	button_no -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x148
; 0000 01D1     {
; 0000 01D2         main_window();
	RCALL _main_window
; 0000 01D3     }
; 0000 01D4 }
_0x148:
	RJMP _0x20A0004
; .FEND
;
;
;void debug_window(void)
; 0000 01D8 {
_debug_window:
; .FSTART _debug_window
; 0000 01D9     char i, test_response, micros[16] = {0, 0, 0, 0,
; 0000 01DA                                          0, 0, 0, 0,
; 0000 01DB                                          0, 0, 0, 0,
; 0000 01DC                                          0, 0, 0, 0},
; 0000 01DD          count = 0;
; 0000 01DE 
; 0000 01DF     glcd_clear();
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x149*2)
	LDI  R31,HIGH(_0x149*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	i -> R17
;	test_response -> R16
;	micros -> Y+4
;	count -> R19
	LDI  R19,0
	CALL _glcd_clear
; 0000 01E0     glcd_puts("Debugging,", 0, 0, 0, 1, 0);
	__POINTW1MN _0x14A,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 01E1     glcd_puts("Please wait...", 0, 1, 0, 1, 0);
	__POINTW1MN _0x14A,11
	CALL SUBOPT_0x26
	CALL SUBOPT_0x47
; 0000 01E2 
; 0000 01E3     /*
; 0000 01E4         Testing section
; 0000 01E5     */
; 0000 01E6 
; 0000 01E7      // Receives USART from lightmicros
; 0000 01E8     PORTD.4 = 1;
	SBI  0x12,4
; 0000 01E9 
; 0000 01EA     for (i = 0; i < 16; i++) {
	LDI  R17,LOW(0)
_0x14E:
	CPI  R17,16
	BRSH _0x14F
; 0000 01EB         select_lightmicro(i);
	MOV  R26,R17
	ST   -Y,R26
	LD   R30,Y
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x81)
	MOV  R26,R30
	ST   -Y,R26
_0x28006005:
	SBIS 0xB,5
	RJMP _0x28006005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	ADIW R28,1
; 0000 01EC 
; 0000 01ED         send_test_connection_lightmicro(i);
	MOV  R26,R17
	ST   -Y,R26
	LD   R30,Y
	ORI  R30,0x20
	MOV  R26,R30
	ST   -Y,R26
_0x10005005:
	SBIS 0xB,5
	RJMP _0x10005005
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	ADIW R28,1
; 0000 01EE 
; 0000 01EF         delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
; 0000 01F0 
; 0000 01F1         if (UCSRA.RXC == 1) {
	SBIS 0xB,7
	RJMP _0x150
; 0000 01F2             test_response = UDR;
	IN   R16,12
; 0000 01F3             if (test_response == (i * 4 + 2)) {
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	ADIW R30,2
	MOV  R26,R16
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x14D
; 0000 01F4                 continue;
; 0000 01F5             }
; 0000 01F6         }
; 0000 01F7 
; 0000 01F8         micros[i] = 1;
_0x150:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 01F9         count++;
	SUBI R19,-1
; 0000 01FA     }
_0x14D:
	SUBI R17,-1
	RJMP _0x14E
_0x14F:
; 0000 01FB 
; 0000 01FC     // Receives USART from tempmicro
; 0000 01FD     PORTD.4 = 0;
	CBI  0x12,4
; 0000 01FE 
; 0000 01FF     /*
; 0000 0200         Display test result
; 0000 0201     */
; 0000 0202 
; 0000 0203     glcd_clear();
	CALL _glcd_clear
; 0000 0204 
; 0000 0205     // If all micros all connected
; 0000 0206     if (count == 0) {
	CPI  R19,0
	BRNE _0x154
; 0000 0207         glcd_puts("All lightmicros,", 0, 0, 0, 1, 0);
	__POINTW1MN _0x14A,26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 0208         glcd_puts("are connected.", 0, 1, 0, 1, 0);
	__POINTW1MN _0x14A,43
	CALL SUBOPT_0x26
	CALL SUBOPT_0x47
; 0000 0209     }
; 0000 020A     // If there is any disconnected micros
; 0000 020B     else {
	RJMP _0x155
_0x154:
; 0000 020C         char x = 0, y = 2;
; 0000 020D 
; 0000 020E         glcd_puts("lightmicros that", 0, 0, 0, 1, 0);
	SBIW R28,2
	LDI  R30,LOW(2)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
;	micros -> Y+6
;	x -> Y+1
;	y -> Y+0
	__POINTW1MN _0x14A,58
	CALL SUBOPT_0x26
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 020F         glcd_puts("are disconnected", 0, 1, 0, 1, 0);
	__POINTW1MN _0x14A,75
	CALL SUBOPT_0x26
	CALL SUBOPT_0x47
; 0000 0210 
; 0000 0211         for (i = 0; count != 0; i++) {
	LDI  R17,LOW(0)
_0x157:
	CPI  R19,0
	BRNE PC+2
	RJMP _0x158
; 0000 0212             // If lightmicro is disconnected
; 0000 0213             if (micros[i] == 1) {
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x159
; 0000 0214                 char i_str[4];
; 0000 0215                 char len = (i >= 10) ? 2 : 1;
; 0000 0216 
; 0000 0217                 if (15 - x < len) {
	SBIW R28,5
;	micros -> Y+11
;	x -> Y+6
;	y -> Y+5
;	i_str -> Y+1
;	len -> Y+0
	CPI  R17,10
	BRLO _0x15A
	LDI  R30,LOW(2)
	RJMP _0x15B
_0x15A:
	LDI  R30,LOW(1)
_0x15B:
	ST   Y,R30
	LDD  R30,Y+6
	LDI  R31,0
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	SUB  R26,R30
	SBC  R27,R31
	LD   R30,Y
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x15D
; 0000 0218                     // Clear dash
; 0000 0219                     glcd_puts(" ", (x - 1) * 8, y, 0, 1, 0);
	__POINTW1MN _0x14A,92
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDI  R31,0
	SBIW R30,1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x48
; 0000 021A 
; 0000 021B                     x = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 021C                     y++;
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
; 0000 021D 
; 0000 021E                 }
; 0000 021F                 else {
	RJMP _0x15E
_0x15D:
; 0000 0220                     if (x != 0) {
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x15F
; 0000 0221                         glcd_puts("-", x * 8 ,y , 0, 1, 0);
	__POINTW1MN _0x14A,94
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x49
; 0000 0222 
; 0000 0223                         x++;
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
; 0000 0224                     }
; 0000 0225                 }
_0x15F:
_0x15E:
; 0000 0226 
; 0000 0227                 sprintf(i_str, "%d", i + 1);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x43
	MOV  R30,R17
	CALL SUBOPT_0x4A
; 0000 0228                 glcd_puts(i_str, x * 8, y, 0, 1, 0);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x49
; 0000 0229 
; 0000 022A                 if (x + len > 15) {
	LDD  R26,Y+6
	CLR  R27
	LD   R30,Y
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,16
	BRLT _0x160
; 0000 022B                     x = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 022C                     y++;
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
; 0000 022D                 }
; 0000 022E                 else {
	RJMP _0x161
_0x160:
; 0000 022F                     x += len;
	LD   R30,Y
	LDD  R26,Y+6
	ADD  R30,R26
	STD  Y+6,R30
; 0000 0230                 }
_0x161:
; 0000 0231 
; 0000 0232                 count--;
	SUBI R19,1
; 0000 0233             }
	ADIW R28,5
; 0000 0234         }
_0x159:
	SUBI R17,-1
	RJMP _0x157
_0x158:
; 0000 0235     }
	ADIW R28,2
_0x155:
; 0000 0236 
; 0000 0237     glcd_puts("[OK]", 6 * 8, 7, 0, 1, 0);
	__POINTW1MN _0x14A,96
	CALL SUBOPT_0x28
	CALL SUBOPT_0x41
; 0000 0238 
; 0000 0239     /*
; 0000 023A         Init input handlers
; 0000 023B     */
; 0000 023C     keypad_handler = 0;
	CLR  R6
	CLR  R7
; 0000 023D     button_handler = &debug_window_button;
	LDI  R30,LOW(_debug_window_button)
	LDI  R31,HIGH(_debug_window_button)
	MOVW R8,R30
; 0000 023E }
	CALL __LOADLOCR4
	JMP  _0x20A0002
; .FEND

	.DSEG
_0x14A:
	.BYTE 0x65
;
;
;char main_window_selected;
;
;
;void main_window_button(char button_no)
; 0000 0245 {

	.CSEG
_main_window_button:
; .FSTART _main_window_button
; 0000 0246     switch (button_no) {
	CALL SUBOPT_0x1E
;	button_no -> Y+0
; 0000 0247         case 1: // Up
	BRNE _0x165
; 0000 0248             glcd_puts(" ", 0, main_window_selected, 0, 1, 0);
	__POINTW1MN _0x166,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4B
; 0000 0249             if (main_window_selected == 0) {
	LDS  R30,_main_window_selected
	CPI  R30,0
	BRNE _0x167
; 0000 024A                 main_window_selected = 3;
	LDI  R30,LOW(3)
	RJMP _0x19A
; 0000 024B             }
; 0000 024C             else {
_0x167:
; 0000 024D                 main_window_selected -= 1;
	LDS  R30,_main_window_selected
	SUBI R30,LOW(1)
_0x19A:
	STS  _main_window_selected,R30
; 0000 024E             }
; 0000 024F             glcd_puts(">", 0, main_window_selected, 0, 1, 0);
	__POINTW1MN _0x166,2
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4B
; 0000 0250         break;
	RJMP _0x164
; 0000 0251         case 4: // Down
_0x165:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x169
; 0000 0252             glcd_puts(" ", 0, main_window_selected, 0, 1, 0);
	__POINTW1MN _0x166,4
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4B
; 0000 0253             main_window_selected = (main_window_selected + 1) % 4;
	LDS  R30,_main_window_selected
	CALL SUBOPT_0x2C
	STS  _main_window_selected,R30
; 0000 0254             glcd_puts(">", 0, main_window_selected, 0, 1, 0);
	__POINTW1MN _0x166,6
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4B
; 0000 0255         break;
	RJMP _0x164
; 0000 0256         case 0: // OK
_0x169:
	SBIW R30,0
	BRNE _0x164
; 0000 0257         // Don't recieve temperatures from tempmicro
; 0000 0258         UCSRB.RXCIE = 0;
	CBI  0xA,7
; 0000 0259 
; 0000 025A         switch (main_window_selected) {
	LDS  R30,_main_window_selected
	LDI  R31,0
; 0000 025B             case 0: // Edit
	SBIW R30,0
	BRNE _0x170
; 0000 025C                 activate_window(1);
	LDI  R26,LOW(1)
	RCALL _activate_window
; 0000 025D             break;
	RJMP _0x16F
; 0000 025E             case 1: // Activate
_0x170:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x171
; 0000 025F                 activate_window(0);
	LDI  R26,LOW(0)
	RCALL _activate_window
; 0000 0260             break;
	RJMP _0x16F
; 0000 0261             case 2: // Debug
_0x171:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x172
; 0000 0262                 debug_window();
	RCALL _debug_window
; 0000 0263             break;
	RJMP _0x16F
; 0000 0264             case 3: // Temp range
_0x172:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x16F
; 0000 0265                 temp_window();
	RCALL _temp_window
; 0000 0266             break;
; 0000 0267         }
_0x16F:
; 0000 0268     }
_0x164:
; 0000 0269 }
_0x20A0004:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_0x166:
	.BYTE 0x8
;
;
;void main_window(void)
; 0000 026D {

	.CSEG
_main_window:
; .FSTART _main_window
; 0000 026E     char pattern_no_str[2];
; 0000 026F 
; 0000 0270     main_window_selected = 0;
	SBIW R28,2
;	pattern_no_str -> Y+0
	LDI  R30,LOW(0)
	STS  _main_window_selected,R30
; 0000 0271 
; 0000 0272     temp = 252;
	LDI  R30,LOW(252)
	MOV  R5,R30
; 0000 0273 
; 0000 0274     /*
; 0000 0275         Display
; 0000 0276     */
; 0000 0277     glcd_clear();
	CALL _glcd_clear
; 0000 0278 
; 0000 0279     glcd_puts(">Edit", 0, 0, 0, 1, 0);
	__POINTW1MN _0x174,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x0
	CALL SUBOPT_0x27
; 0000 027A     glcd_puts("Activate", 1*8, 1, 0, 1, 0);
	__POINTW1MN _0x174,6
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x3F
; 0000 027B     glcd_puts("Debug", 1*8, 2, 0, 1, 0);
	__POINTW1MN _0x174,15
	CALL SUBOPT_0x4C
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x32
; 0000 027C     glcd_puts("Temp range", 1*8, 3, 0, 1, 0);
	__POINTW1MN _0x174,21
	CALL SUBOPT_0x4C
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1D
; 0000 027D 
; 0000 027E     h_line(0, 5 * 8, 16 * 8, 0, 1);
	CALL SUBOPT_0x0
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _h_line
; 0000 027F 
; 0000 0280     glcd_puts("Pattern: ", 0, 6, 0, 1, 0);
	__POINTW1MN _0x174,32
	CALL SUBOPT_0x26
	CALL SUBOPT_0x29
; 0000 0281     sprintf(pattern_no_str, "%d", pattern_no + 1);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x43
	LDI  R26,LOW(_pattern_no)
	LDI  R27,HIGH(_pattern_no)
	CALL __EEPROMRDB
	CALL SUBOPT_0x4A
; 0000 0282     glcd_puts(pattern_no_str, 9*8, 6, 0, 1, 0);
	CALL SUBOPT_0x30
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x29
; 0000 0283 
; 0000 0284     glcd_puts("Temp: meausring", 0, 7, 0, 1, 0);
	__POINTW1MN _0x174,42
	CALL SUBOPT_0x26
	CALL SUBOPT_0x41
; 0000 0285 
; 0000 0286     // Receive temperatures from tempmicro
; 0000 0287     UCSRB.RXCIE = 1;
	SBI  0xA,7
; 0000 0288 
; 0000 0289     /*
; 0000 028A         Init input handlers
; 0000 028B     */
; 0000 028C     keypad_handler = 0;
	CLR  R6
	CLR  R7
; 0000 028D     button_handler = &main_window_button;
	LDI  R30,LOW(_main_window_button)
	LDI  R31,HIGH(_main_window_button)
	MOVW R8,R30
; 0000 028E }
	ADIW R28,2
	RET
; .FEND

	.DSEG
_0x174:
	.BYTE 0x3A
;
;void main(void)
; 0000 0291 {

	.CSEG
_main:
; .FSTART _main
; 0000 0292     /*
; 0000 0293 		Give pattern_no initial value
; 0000 0294 	*/
; 0000 0295     if (pattern_no == 0xFF) {
	LDI  R26,LOW(_pattern_no)
	LDI  R27,HIGH(_pattern_no)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xFF)
	BRNE _0x177
; 0000 0296         pattern_no = 0;
	LDI  R26,LOW(_pattern_no)
	LDI  R27,HIGH(_pattern_no)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0297     }
; 0000 0298 
; 0000 0299     /*
; 0000 029A 		Port initialize
; 0000 029B 	*/
; 0000 029C     DDRA = 0xFF;
_0x177:
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 029D 
; 0000 029E     DDRB = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 029F     PORTB = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 02A0 
; 0000 02A1     DDRC = 0x0F;
	OUT  0x14,R30
; 0000 02A2     PORTC |= 0xF0;
	IN   R30,0x15
	ORI  R30,LOW(0xF0)
	OUT  0x15,R30
; 0000 02A3 
; 0000 02A4     DDRD = 0b10010010;
	LDI  R30,LOW(146)
	OUT  0x11,R30
; 0000 02A5     PORTD |= 0b01001101;
	IN   R30,0x12
	ORI  R30,LOW(0x4D)
	OUT  0x12,R30
; 0000 02A6 
; 0000 02A7     /*
; 0000 02A8 		USART initialize
; 0000 02A9 	*/
; 0000 02AA     UCSRB = (1<<RXEN) | (1<<TXEN);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 02AB     UCSRC = (1<<UCSZ1)|(1<<UCSZ0)|(1<<URSEL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 02AC     UBRRL = 0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 02AD 
; 0000 02AE     /*
; 0000 02AF         External interrupt initialize
; 0000 02B0     */
; 0000 02B1     MCUCR = 0x0A;
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 02B2     GICR = (1<<INT0) | (1<<INT1);
	LDI  R30,LOW(192)
	OUT  0x3B,R30
; 0000 02B3 
; 0000 02B4     main_window();
	RCALL _main_window
; 0000 02B5 
; 0000 02B6     sei();
	sei
; 0000 02B7 
; 0000 02B8 
; 0000 02B9     /*
; 0000 02BA 		Program's main loop
; 0000 02BB 	*/
; 0000 02BC     while (1) {
_0x178:
; 0000 02BD     }
	RJMP _0x178
; 0000 02BE }
_0x17B:
	RJMP _0x17B
; .FEND
;
;
;/*
;    New temperature has been sent
;*/
;interrupt [USART_RXC] void usart_rxc_isr(void)
; 0000 02C5 {
_usart_rxc_isr:
; .FSTART _usart_rxc_isr
	CALL SUBOPT_0x4D
; 0000 02C6     char temp_str[2], new_temp;
; 0000 02C7 
; 0000 02C8     new_temp = UDR;
	SBIW R28,2
	ST   -Y,R17
;	temp_str -> Y+1
;	new_temp -> R17
	IN   R17,12
; 0000 02C9     if (new_temp == temp)
	CP   R5,R17
	BRNE _0x17C
; 0000 02CA         return;
	LDD  R17,Y+0
	ADIW R28,3
	RJMP _0x19C
; 0000 02CB     temp = new_temp;
_0x17C:
	MOV  R5,R17
; 0000 02CC     sprintf(temp_str, "%d", new_temp);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x43
	MOV  R30,R17
	CALL SUBOPT_0x1B
; 0000 02CD     glcd_puts("         ", 6*8, 7, 0, 1, 0);
	__POINTW1MN _0x17D,0
	CALL SUBOPT_0x28
	CALL SUBOPT_0x41
; 0000 02CE     glcd_puts(temp_str, 6*8, 7, 0, 1, 0);
	CALL SUBOPT_0x1A
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x41
; 0000 02CF }
	LDD  R17,Y+0
	ADIW R28,3
	RJMP _0x19C
; .FEND

	.DSEG
_0x17D:
	.BYTE 0xA
;
;
;/*
;    A button has been pressed
;*/
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 02D6 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x4D
; 0000 02D7     char button_no = 0;
; 0000 02D8 
; 0000 02D9     if (!button_handler)
	ST   -Y,R17
;	button_no -> R17
	LDI  R17,0
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x17E
; 0000 02DA         return;
	LD   R17,Y+
	RJMP _0x19C
; 0000 02DB 
; 0000 02DC     if (!PINC.7)
_0x17E:
	SBIC 0x13,7
	RJMP _0x17F
; 0000 02DD         button_no = 1; // Up
	LDI  R17,LOW(1)
; 0000 02DE     else if (!PINC.5)
	RJMP _0x180
_0x17F:
	SBIC 0x13,5
	RJMP _0x181
; 0000 02DF         button_no = 2; // Right
	LDI  R17,LOW(2)
; 0000 02E0     else if (!PINC.4)
	RJMP _0x182
_0x181:
	SBIC 0x13,4
	RJMP _0x183
; 0000 02E1         button_no = 3; // Left
	LDI  R17,LOW(3)
; 0000 02E2     else if (!PINC.6)
	RJMP _0x184
_0x183:
	SBIS 0x13,6
; 0000 02E3         button_no = 4; // Down
	LDI  R17,LOW(4)
; 0000 02E4 
; 0000 02E5 
; 0000 02E6     (*button_handler)(button_no);
_0x184:
_0x182:
_0x180:
	MOV  R26,R17
	MOVW R30,R8
	ICALL
; 0000 02E7 
; 0000 02E8 }
	LD   R17,Y+
	RJMP _0x19C
; .FEND
;
;
;/*
;    Keypad has been pressed
;*/
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 02EF {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x4D
; 0000 02F0     char pinb_rows,
; 0000 02F1          pinb_columns,
; 0000 02F2          i,
; 0000 02F3          j;
; 0000 02F4 
; 0000 02F5     if (!keypad_handler)
	CALL __SAVELOCR4
;	pinb_rows -> R17
;	pinb_columns -> R16
;	i -> R19
;	j -> R18
	MOV  R0,R6
	OR   R0,R7
	BREQ _0x19B
; 0000 02F6         return;
; 0000 02F7 
; 0000 02F8     pinb_rows = PINB | 0xF0;
	IN   R30,0x16
	ORI  R30,LOW(0xF0)
	MOV  R17,R30
; 0000 02F9 
; 0000 02FA     for (i = 0 ;; i++)
	LDI  R19,LOW(0)
_0x188:
; 0000 02FB         if (!(pinb_rows & (1<<i)))
	MOV  R30,R19
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R17
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x189
; 0000 02FC             break;
; 0000 02FD 
; 0000 02FE     DDRB = 0;
	SUBI R19,-1
	RJMP _0x188
_0x189:
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 02FF     PORTB = 0;
	OUT  0x18,R30
; 0000 0300 
; 0000 0301     DDRB = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0302     PORTB = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 0303 
; 0000 0304     pinb_columns = PINB>>4;
	IN   R30,0x16
	LDI  R31,0
	CALL __ASRW4
	MOV  R16,R30
; 0000 0305 
; 0000 0306     for (j = 0 ;; j++)
	LDI  R18,LOW(0)
_0x18C:
; 0000 0307         if (!(pinb_columns & (1<<j)))
	MOV  R30,R18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R16
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x18D
; 0000 0308             break;
; 0000 0309     DDRB = 0;
	SUBI R18,-1
	RJMP _0x18C
_0x18D:
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 030A     PORTB = 0;
	OUT  0x18,R30
; 0000 030B 
; 0000 030C     DDRB = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 030D     PORTB = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 030E 
; 0000 030F     (*keypad_handler)(i * 4 + j);
	MOV  R30,R19
	LSL  R30
	LSL  R30
	ADD  R30,R18
	MOV  R26,R30
	MOVW R30,R6
	ICALL
; 0000 0310 }
_0x19B:
	CALL __LOADLOCR4
	ADIW R28,4
_0x19C:
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
; .FEND
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include "usart.h"
;	data -> Y+0
;	pattern_no -> Y+0
;	pattern_no -> Y+0
;	block_no -> Y+0
;	byte_no -> Y+1
;	block_no -> Y+0
;	small -> Y+1
;	large -> Y+0
;	lightmicro_no -> Y+0
;
;void send_pattern(eeprom char pattern[16][8][2], char pattern_no)
; 0001 0006 {

	.CSEG
_send_pattern:
; .FSTART _send_pattern
; 0001 0007     char block_no,
; 0001 0008          byte_no;
; 0001 0009 
; 0001 000A     send_edit_pattern(pattern_no);
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	pattern_no -> Y+2
;	block_no -> R17
;	byte_no -> R16
	LDD  R26,Y+2
	ST   -Y,R26
	LD   R30,Y
	ORI  R30,0x10
	MOV  R26,R30
	ST   -Y,R26
_0xC022004:
	SBIS 0xB,5
	RJMP _0xC022004
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	ADIW R28,1
; 0001 000B 
; 0001 000C     for (block_no = 0; block_no < 16; block_no++) {
	LDI  R17,LOW(0)
_0x2000E:
	CPI  R17,16
	BRSH _0x2000F
; 0001 000D         for (byte_no = 0; byte_no < 2; byte_no++) {
	LDI  R16,LOW(0)
_0x20011:
	CPI  R16,2
	BRSH _0x20012
; 0001 000E             send_write_command(byte_no, block_no);
	ST   -Y,R16
	MOV  R26,R17
	ST   -Y,R26
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	LD   R26,Y
	ADD  R30,R26
	MOV  R26,R30
	ST   -Y,R26
_0x14024004:
	SBIS 0xB,5
	RJMP _0x14024004
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
	ADIW R28,2
; 0001 000F             send_usart(pattern[block_no][pattern_no][byte_no]);
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL __LSLW4
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL SUBOPT_0xC
	CALL __EEPROMRDB
	MOV  R26,R30
	ST   -Y,R26
_0x28020004:
	SBIS 0xB,5
	RJMP _0x28020004
	LD   R30,Y
	OUT  0xC,R30
	ADIW R28,1
; 0001 0010         }
	SUBI R16,-1
	RJMP _0x20011
_0x20012:
; 0001 0011     }
	SUBI R17,-1
	RJMP _0x2000E
_0x2000F:
; 0001 0012 }
	RJMP _0x20A0003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0xD
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0xD
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
_0x20A0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x4E
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x4E
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x4F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x50
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x51
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x51
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x52
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x52
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x4E
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x4E
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x50
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x4E
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x50
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
_0x20A0002:
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x53
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x53
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_prevLet_G000:
	.BYTE 0x2
_stat_G000:
	.BYTE 0x1
_prevX_G000:
	.BYTE 0x1
_prevY_G000:
	.BYTE 0x1

	.ESEG
_pattern:
	.BYTE 0x100
_pattern_no:
	.BYTE 0x1

	.DSEG
_edit_window_pattern:
	.BYTE 0x20
_activate_window_pattern_no:
	.BYTE 0x1
_edit_window_selected:
	.BYTE 0x1
_activate_window_selected:
	.BYTE 0x1
_activate_window_mode:
	.BYTE 0x1
_main_window_selected:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL __LSRW3
	MOVW R26,R30
	JMP  _goto_xy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDD  R30,Y+3
	LDI  R31,0
	ADIW R30,1
	LDI  R31,0
	LDI  R31,0
	__ADDWRR 16,17,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDD  R26,Y+12
	LDD  R30,Y+8
	SUB  R30,R26
	ST   -Y,R30
	LDD  R30,Y+6
	ST   -Y,R30
	LDD  R26,Y+6
	CALL _h_line
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R26,Y+7
	JMP  _v_line

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	CALL __LSLW3
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_font*2)
	SBCI R31,HIGH(-_font*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	__GETW2SX 71
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOV  R30,R17
	LDI  R31,0
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R30,_prevLet_G000
	LDS  R31,_prevLet_G000+1
	SUBI R30,LOW(193)
	SBCI R31,HIGH(193)
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12U
	SUBI R30,LOW(-_map*2)
	SBCI R31,HIGH(-_map*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(193)
	SBCI R31,HIGH(193)
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12U
	SUBI R30,LOW(-_map*2)
	SBCI R31,HIGH(-_map*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x12:
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ST   -Y,R30
	LDD  R26,Y+9
	JMP  _glcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDD  R30,Y+2
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADIW R30,8
	MOVW R26,R30
	LDD  R30,Y+3
	LDI  R31,0
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDD  R30,Y+3
	LDI  R26,LOW(8)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDD  R30,Y+3
	LDI  R31,0
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+5,R30
	STD  Y+5+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x17:
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Z+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDD  R30,Y+4
	LDI  R26,LOW(8)
	MUL  R30,R26
	MOVW R30,R0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R27
	ST   -Y,R26
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+7,R26
	STD  Y+7+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	CALL __LSLW3
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R11
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	LDI  R31,0
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	MOV  R30,R11
	LDI  R31,0
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(1)
	CALL _rectangle
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _rectangle

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x26:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 48 TIMES, CODE SIZE REDUCTION:232 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2B:
	LDS  R30,_edit_window_selected
	LDI  R31,0
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	LDI  R31,0
	CALL __LSLW4
	SUBI R30,LOW(-_pattern)
	SBCI R31,HIGH(-_pattern)
	MOVW R26,R30
	LDS  R30,_activate_window_pattern_no
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(_edit_window_pattern)
	LDI  R27,HIGH(_edit_window_pattern)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDS  R30,_activate_window_pattern_no
	LDI  R26,LOW(_pattern_no)
	LDI  R27,HIGH(_pattern_no)
	CALL __EEPROMWRB
	LDS  R26,_activate_window_pattern_no
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x30:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_activate_window_pattern_no
	LDI  R31,0
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x36:
	__POINTW1FN _0x0,4
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R12
	LDI  R31,0
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	MOV  R30,R12
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	LDI  R26,LOW(16)
	MULS R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	MOV  R26,R12
	LDI  R27,0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LDI  R26,LOW(16)
	MULS R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDI  R27,0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3B:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+4
	LDI  R27,0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+4
	LDI  R31,0
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3D:
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+2
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+3
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	__POINTW1FN _0x0,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x44:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_activate_window_selected
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_activate_window_selected
	LDI  R31,0
	ADIW R30,6
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	LDS  R30,_activate_window_selected
	LDI  R31,0
	ADIW R30,6
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	LDD  R30,Y+9
	LDI  R31,0
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	LDD  R26,Y+8
	LDI  R30,LOW(8)
	MUL  R30,R26
	ST   -Y,R1
	ST   -Y,R0
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	LDI  R31,0
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4B:
	LDS  R30,_main_window_selected
	LDI  R31,0
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x4D:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x51:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x52:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

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

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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

__LSRW3:
	LSR  R31
	ROR  R30
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

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
