
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
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
	.DEF _x=R4
	.DEF _x_msb=R5
	.DEF _pos_x=R6
	.DEF _pos_x_msb=R7
	.DEF _pos_y=R8
	.DEF _pos_y_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _j=R12
	.DEF _j_msb=R13

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x50,0x61
	.DB  0x73,0x73,0x20,0x74,0x6F,0x20,0x53,0x49
	.DB  0x47,0x4E,0x55,0x50,0x20,0x0,0x20,0x20
	.DB  0x54,0x68,0x65,0x6E,0x20,0x50,0x72,0x65
	.DB  0x73,0x73,0x20,0x3C,0x23,0x3E,0x20,0x0
	.DB  0x3D,0x3D,0x3E,0x20,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x50,0x61,0x73,0x73,0x20
	.DB  0x74,0x6F,0x20,0x6C,0x6F,0x67,0x69,0x6E
	.DB  0x0,0x55,0x53,0x45,0x52,0x20,0x4E,0x4F
	.DB  0x54,0x20,0x46,0x4F,0x55,0x4E,0x44,0x0
	.DB  0x20,0x20,0x45,0x52,0x52,0x4F,0x52,0x20
	.DB  0x20,0x20,0x20,0x45,0x52,0x52,0x4F,0x52
	.DB  0x0,0x4C,0x4F,0x47,0x45,0x44,0x20,0x49
	.DB  0x4E,0x20,0x53,0x75,0x63,0x63,0x65,0x73
	.DB  0x66,0x75,0x6C,0x6C,0x79,0x0,0x50,0x41
	.DB  0x53,0x53,0x20,0x49,0x4E,0x43,0x4F,0x52
	.DB  0x52,0x45,0x43,0x54,0x0,0x25,0x64,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x49,0x44
	.DB  0x20,0x74,0x6F,0x20,0x53,0x49,0x47,0x4E
	.DB  0x20,0x55,0x50,0x20,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x49,0x44,0x20,0x74,0x6F
	.DB  0x20,0x6C,0x6F,0x67,0x20,0x69,0x6E,0x20
	.DB  0x0,0x4C,0x4F,0x47,0x45,0x44,0x20,0x49
	.DB  0x4E,0x20,0x41,0x53,0x20,0x3A,0x20,0x41
	.DB  0x44,0x4D,0x49,0x4E,0x0,0x31,0x2D,0x20
	.DB  0x41,0x44,0x44,0x20,0x55,0x53,0x45,0x52
	.DB  0x0,0x32,0x2D,0x20,0x53,0x45,0x54,0x20
	.DB  0x54,0x49,0x4D,0x45,0x20,0x2F,0x20,0x44
	.DB  0x41,0x54,0x45,0x20,0x0,0x33,0x2D,0x20
	.DB  0x4C,0x4F,0x47,0x20,0x4F,0x55,0x54,0x0
	.DB  0x4C,0x4F,0x47,0x45,0x44,0x20,0x49,0x4E
	.DB  0x20,0x41,0x53,0x20,0x3A,0x20,0x55,0x53
	.DB  0x45,0x52,0x0,0x31,0x2D,0x20,0x43,0x48
	.DB  0x45,0x43,0x4B,0x20,0x44,0x41,0x54,0x45
	.DB  0x2F,0x54,0x49,0x4D,0x45,0x0,0x32,0x2D
	.DB  0x20,0x54,0x45,0x4D,0x50,0x45,0x52,0x41
	.DB  0x54,0x55,0x52,0x45,0x20,0x0,0x33,0x2D
	.DB  0x20,0x53,0x54,0x45,0x50,0x20,0x4D,0x4F
	.DB  0x54,0x4F,0x52,0x0,0x54,0x6F,0x20,0x53
	.DB  0x45,0x54,0x20,0x70,0x72,0x65,0x73,0x73
	.DB  0x20,0x3C,0x2A,0x3E,0x20,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x59,0x65,0x61,0x72
	.DB  0x20,0x3A,0x20,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x6D,0x6F,0x75,0x6E,0x74,0x20
	.DB  0x3A,0x20,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x64,0x61,0x79,0x20,0x3A,0x20,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x68,0x6F
	.DB  0x75,0x72,0x20,0x3A,0x20,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x6D,0x69,0x6E,0x75
	.DB  0x74,0x65,0x20,0x3A,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x3C,0x3C,0x20,0x44,0x41
	.DB  0x54,0x45,0x20,0x3E,0x3E,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x64,0x20,0x2F,0x20,0x25,0x64,0x20
	.DB  0x2F,0x20,0x25,0x64,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x3C,0x3C,0x20,0x54,0x49
	.DB  0x4D,0x45,0x20,0x3E,0x3E,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x25,0x64,0x20,0x3A,0x20,0x25,0x64
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x54,0x45
	.DB  0x4D,0x50,0x0,0x54,0x65,0x6D,0x70,0x20
	.DB  0x3D,0x0,0x20,0x20,0x65,0x6E,0x74,0x65
	.DB  0x72,0x20,0x73,0x74,0x65,0x70,0x20,0x6D
	.DB  0x6F,0x74,0x6F,0x72,0x20,0x20,0x0,0x73
	.DB  0x74,0x65,0x70,0x73,0x20,0x62,0x65,0x74
	.DB  0x77,0x65,0x65,0x6E,0x28,0x32,0x2D,0x34
	.DB  0x2D,0x38,0x29,0x0,0x73,0x74,0x65,0x70
	.DB  0x20,0x25,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x16
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x12
	.DW  _0x6+22
	.DW  _0x0*2+22

	.DW  0x05
	.DW  _0x6+40
	.DW  _0x0*2+40

	.DW  0x14
	.DW  _0x6+45
	.DW  _0x0*2+45

	.DW  0x12
	.DW  _0x6+65
	.DW  _0x0*2+22

	.DW  0x05
	.DW  _0x6+83
	.DW  _0x0*2+40

	.DW  0x0F
	.DW  _0x6+88
	.DW  _0x0*2+65

	.DW  0x11
	.DW  _0x6+103
	.DW  _0x0*2+80

	.DW  0x15
	.DW  _0x6+120
	.DW  _0x0*2+97

	.DW  0x0F
	.DW  _0x6+141
	.DW  _0x0*2+118

	.DW  0x11
	.DW  _0x6+156
	.DW  _0x0*2+80

	.DW  0x15
	.DW  _0x43
	.DW  _0x0*2+136

	.DW  0x12
	.DW  _0x43+21
	.DW  _0x0*2+22

	.DW  0x05
	.DW  _0x43+39
	.DW  _0x0*2+40

	.DW  0x14
	.DW  _0x43+44
	.DW  _0x0*2+157

	.DW  0x12
	.DW  _0x43+64
	.DW  _0x0*2+22

	.DW  0x05
	.DW  _0x43+82
	.DW  _0x0*2+40

	.DW  0x14
	.DW  _0x43+87
	.DW  _0x0*2+177

	.DW  0x0C
	.DW  _0x43+107
	.DW  _0x0*2+197

	.DW  0x14
	.DW  _0x43+119
	.DW  _0x0*2+209

	.DW  0x0B
	.DW  _0x43+139
	.DW  _0x0*2+229

	.DW  0x13
	.DW  _0x43+150
	.DW  _0x0*2+240

	.DW  0x13
	.DW  _0x43+169
	.DW  _0x0*2+259

	.DW  0x10
	.DW  _0x43+188
	.DW  _0x0*2+278

	.DW  0x0E
	.DW  _0x43+204
	.DW  _0x0*2+294

	.DW  0x15
	.DW  _0x43+218
	.DW  _0x0*2+136

	.DW  0x12
	.DW  _0x43+239
	.DW  _0x0*2+22

	.DW  0x05
	.DW  _0x43+257
	.DW  _0x0*2+40

	.DW  0x12
	.DW  _0x43+262
	.DW  _0x0*2+308

	.DW  0x0E
	.DW  _0x43+280
	.DW  _0x0*2+326

	.DW  0x05
	.DW  _0x43+294
	.DW  _0x0*2+40

	.DW  0x12
	.DW  _0x43+299
	.DW  _0x0*2+308

	.DW  0x0F
	.DW  _0x43+317
	.DW  _0x0*2+340

	.DW  0x05
	.DW  _0x43+332
	.DW  _0x0*2+40

	.DW  0x12
	.DW  _0x43+337
	.DW  _0x0*2+308

	.DW  0x0D
	.DW  _0x43+355
	.DW  _0x0*2+355

	.DW  0x05
	.DW  _0x43+368
	.DW  _0x0*2+40

	.DW  0x12
	.DW  _0x43+373
	.DW  _0x0*2+308

	.DW  0x0E
	.DW  _0x43+391
	.DW  _0x0*2+368

	.DW  0x05
	.DW  _0x43+405
	.DW  _0x0*2+40

	.DW  0x12
	.DW  _0x43+410
	.DW  _0x0*2+308

	.DW  0x10
	.DW  _0x43+428
	.DW  _0x0*2+382

	.DW  0x05
	.DW  _0x43+444
	.DW  _0x0*2+40

	.DW  0x14
	.DW  _0x43+449
	.DW  _0x0*2+398

	.DW  0x14
	.DW  _0x43+469
	.DW  _0x0*2+438

	.DW  0x05
	.DW  _0x43+489
	.DW  _0x0*2+478

	.DW  0x07
	.DW  _0x43+494
	.DW  _0x0*2+483

	.DW  0x15
	.DW  _0x43+501
	.DW  _0x0*2+490

	.DW  0x15
	.DW  _0x43+522
	.DW  _0x0*2+511

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;/*******************************************************
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
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
;#include <alcd.h>
;#include <stdio.h>
;#include <delay.h>
;
;
;#define   ROW1   PORTC.0
;#define   ROW2   PORTC.1
;#define   ROW3   PORTC.2
;#define   ROW4   PORTC.3
;#define   C1     PINC.4
;#define   C2     PINC.5
;#define   C3     PINC.6
;
;#define   RED     PORTD.6
;#define   GREEN   PORTD.7
;
;int x , pos_x , pos_y , i , j , log_id ;
;bit press,new_id,new_pass,break_mode,error,id_chk  ;
;unsigned char c[20] ;
;
;long int id[10],pass[10];
;long int check ;
;
;
;int year , mounth , day , hour , minute ;
;
;
;void show()
; 0000 0027 {

	.CSEG
_show:
; .FSTART _show
; 0000 0028     if(press == 1)
	SBRS R2,0
	RJMP _0x3
; 0000 0029     {
; 0000 002A         press = 0 ;
	CLT
	BLD  R2,0
; 0000 002B 
; 0000 002C         if(x == 200)
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R30,R4
	CPC  R31,R5
	BREQ PC+2
	RJMP _0x4
; 0000 002D         {
; 0000 002E             if(new_id == 1)
	SBRS R2,1
	RJMP _0x5
; 0000 002F             {
; 0000 0030              new_id = 0 ;
	BLD  R2,1
; 0000 0031              new_pass = 1 ;
	SET
	BLD  R2,2
; 0000 0032              lcd_clear() ;
	CALL SUBOPT_0x0
; 0000 0033              lcd_gotoxy(0,0);
; 0000 0034             lcd_puts("Enter Pass to SIGNUP ");
	__POINTW2MN _0x6,0
	CALL SUBOPT_0x1
; 0000 0035             lcd_gotoxy(1,1);
; 0000 0036             lcd_puts("  Then Press <#> ");
	__POINTW2MN _0x6,22
	CALL SUBOPT_0x2
; 0000 0037 
; 0000 0038             lcd_gotoxy(0,3);
; 0000 0039             lcd_puts("==> ");
	__POINTW2MN _0x6,40
	CALL SUBOPT_0x3
; 0000 003A 
; 0000 003B                 pos_x = 4 ;
; 0000 003C                 pos_y = 3 ;
; 0000 003D             }
; 0000 003E             else if(new_pass == 1)
	RJMP _0x7
_0x5:
	SBRS R2,2
	RJMP _0x8
; 0000 003F             {
; 0000 0040              i++  ;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
; 0000 0041              new_pass = 0 ;
	CLT
	BLD  R2,2
; 0000 0042              lcd_clear();
	CALL _lcd_clear
; 0000 0043              break_mode = 1;
	SET
	BLD  R2,3
; 0000 0044             }
; 0000 0045             else if(id_chk == 1) // id check
	RJMP _0x9
_0x8:
	SBRS R2,5
	RJMP _0xA
; 0000 0046             {
; 0000 0047             error = 1 ;
	SET
	BLD  R2,4
; 0000 0048                for(j = 0 ; j < i ; j++ )
	CLR  R12
	CLR  R13
_0xC:
	__CPWRR 12,13,10,11
	BRGE _0xD
; 0000 0049                 {
; 0000 004A                     if(check == id[j])
	MOVW R30,R12
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRNE _0xE
; 0000 004B                     {
; 0000 004C                         id_chk = 0 ;
	CALL SUBOPT_0x6
; 0000 004D                         check = 0 ;
; 0000 004E 
; 0000 004F                         lcd_clear() ;
; 0000 0050                         lcd_gotoxy(0,0);
; 0000 0051                         lcd_puts("Enter Pass to login");
	__POINTW2MN _0x6,45
	CALL SUBOPT_0x1
; 0000 0052                         lcd_gotoxy(1,1);
; 0000 0053                         lcd_puts("  Then Press <#> ");
	__POINTW2MN _0x6,65
	CALL SUBOPT_0x2
; 0000 0054 
; 0000 0055                         lcd_gotoxy(0,3);
; 0000 0056                         lcd_puts("==> ");
	__POINTW2MN _0x6,83
	CALL SUBOPT_0x3
; 0000 0057 
; 0000 0058                             pos_x = 4 ;
; 0000 0059                             pos_y = 3 ;
; 0000 005A                             error = 0 ;
	CALL SUBOPT_0x7
; 0000 005B                         GREEN = 1 ;
; 0000 005C                         delay_ms(500);
; 0000 005D                         GREEN = 0 ;
; 0000 005E 
; 0000 005F                         log_id = j ;
	__PUTWMRN _log_id,0,12,13
; 0000 0060                     }
; 0000 0061                 }
_0xE:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0xC
_0xD:
; 0000 0062 
; 0000 0063                 if(error == 1)
	SBRS R2,4
	RJMP _0x13
; 0000 0064                 {
; 0000 0065                         lcd_clear() ;
	CALL SUBOPT_0x8
; 0000 0066                         lcd_gotoxy(3,0);
; 0000 0067                         lcd_puts("USER NOT FOUND");
	__POINTW2MN _0x6,88
	CALL SUBOPT_0x9
; 0000 0068                         lcd_gotoxy(1,2);
; 0000 0069                         lcd_puts("  ERROR    ERROR");
	__POINTW2MN _0x6,103
	CALL _lcd_puts
; 0000 006A                         RED = 1 ;
	SBI  0x12,6
; 0000 006B 
; 0000 006C                 }
; 0000 006D             }
_0x13:
; 0000 006E             else if(id_chk == 0) // pass check
	RJMP _0x16
_0xA:
	SBRC R2,5
	RJMP _0x17
; 0000 006F             {
; 0000 0070             error = 1 ;
	SET
	BLD  R2,4
; 0000 0071 
; 0000 0072                     if(check == pass[log_id])
	LDS  R30,_log_id
	LDS  R31,_log_id+1
	CALL SUBOPT_0xA
	CALL SUBOPT_0x5
	BRNE _0x18
; 0000 0073                     {
; 0000 0074                         id_chk = 0 ;
	CALL SUBOPT_0x6
; 0000 0075                         check = 0 ;
; 0000 0076 
; 0000 0077                         lcd_clear() ;
; 0000 0078                         lcd_gotoxy(0,0);
; 0000 0079                         lcd_puts("LOGED IN Succesfully");
	__POINTW2MN _0x6,120
	CALL _lcd_puts
; 0000 007A                         break_mode = 1 ;
	SET
	BLD  R2,3
; 0000 007B                         error = 0 ;
	CALL SUBOPT_0x7
; 0000 007C 
; 0000 007D                         GREEN = 1 ;
; 0000 007E                         delay_ms(500);
; 0000 007F                         GREEN = 0 ;
; 0000 0080                     }
; 0000 0081 
; 0000 0082                 if(error == 1)
_0x18:
	SBRS R2,4
	RJMP _0x1D
; 0000 0083                 {
; 0000 0084                         lcd_clear() ;
	CALL SUBOPT_0x8
; 0000 0085                         lcd_gotoxy(3,0);
; 0000 0086                         lcd_puts("PASS INCORRECT");
	__POINTW2MN _0x6,141
	CALL SUBOPT_0x9
; 0000 0087                         lcd_gotoxy(1,2);
; 0000 0088                         lcd_puts("  ERROR    ERROR");
	__POINTW2MN _0x6,156
	CALL _lcd_puts
; 0000 0089                         RED = 1 ;
	SBI  0x12,6
; 0000 008A 
; 0000 008B                 }
; 0000 008C               }
_0x1D:
; 0000 008D 
; 0000 008E 
; 0000 008F         }
_0x17:
_0x16:
_0x9:
_0x7:
; 0000 0090         else if(x == 100)
	RJMP _0x20
_0x4:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x21
; 0000 0091         {
; 0000 0092             break_mode = 1;
	SET
	BLD  R2,3
; 0000 0093         }
; 0000 0094         else
	RJMP _0x22
_0x21:
; 0000 0095         {
; 0000 0096             lcd_gotoxy(pos_x,pos_y);
	ST   -Y,R6
	MOV  R26,R8
	CALL SUBOPT_0xB
; 0000 0097             sprintf(c,"%d",x);
	__POINTW1FN _0x0,133
	CALL SUBOPT_0xC
; 0000 0098             lcd_puts(c);
	CALL _lcd_puts
; 0000 0099             pos_x++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 009A 
; 0000 009B             if(new_id == 1)
	SBRS R2,1
	RJMP _0x23
; 0000 009C             {
; 0000 009D 
; 0000 009E                 id[i] *= 10 ;
	MOVW R30,R10
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 009F                 id[i] += x ;
	MOVW R30,R10
	CALL SUBOPT_0x4
	CALL SUBOPT_0xE
; 0000 00A0             }
; 0000 00A1             else if(new_pass == 1)
	RJMP _0x24
_0x23:
	SBRS R2,2
	RJMP _0x25
; 0000 00A2             {
; 0000 00A3 
; 0000 00A4                 pass[i] *= 10 ;
	MOVW R30,R10
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00A5                 pass[i] += x ;
	MOVW R30,R10
	CALL SUBOPT_0xA
	CALL SUBOPT_0xE
; 0000 00A6             }
; 0000 00A7             else
	RJMP _0x26
_0x25:
; 0000 00A8             {
; 0000 00A9                 check *= 10 ;
	LDS  R30,_check
	LDS  R31,_check+1
	LDS  R22,_check+2
	LDS  R23,_check+3
	__GETD2N 0xA
	CALL __MULD12
	CALL SUBOPT_0xF
; 0000 00AA                 check += x ;
	MOVW R30,R4
	LDS  R26,_check
	LDS  R27,_check+1
	LDS  R24,_check+2
	LDS  R25,_check+3
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0xF
; 0000 00AB             }
_0x26:
_0x24:
; 0000 00AC         }
_0x22:
_0x20:
; 0000 00AD     }
; 0000 00AE 
; 0000 00AF }
_0x3:
	RET
; .FEND

	.DSEG
_0x6:
	.BYTE 0xAD
;
;   void keyboard()
; 0000 00B2         {

	.CSEG
_keyboard:
; .FSTART _keyboard
; 0000 00B3 
; 0000 00B4         ROW1 = 0 ;
	CALL SUBOPT_0x10
; 0000 00B5         delay_ms(50);   // in normal we use 2ms but proteus can not detect
; 0000 00B6         if(C1==0) x = 1  ,press = 1  ;
	SBIC 0x13,4
	RJMP _0x29
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00B7         if(C2==0) x = 2  ,press = 1   ;
_0x29:
	SBIC 0x13,5
	RJMP _0x2A
	CALL SUBOPT_0x11
; 0000 00B8         if(C3==0) x = 3  ,press = 1   ;
_0x2A:
	SBIC 0x13,6
	RJMP _0x2B
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00B9         delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x2B:
	CALL SUBOPT_0x12
; 0000 00BA         ROW1 = 1 ;
	SBI  0x15,0
; 0000 00BB show();
	RCALL _show
; 0000 00BC         ROW2 = 0 ;
	CBI  0x15,1
; 0000 00BD         delay_ms(50);   // in normal we use 2ms but proteus can not detect
	CALL SUBOPT_0x12
; 0000 00BE         if(C1==0) x = 4   ,press = 1  ;
	SBIC 0x13,4
	RJMP _0x30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00BF         if(C2==0) x = 5   ,press = 1  ;
_0x30:
	SBIC 0x13,5
	RJMP _0x31
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00C0         if(C3==0) x = 6   ,press = 1  ;
_0x31:
	SBIC 0x13,6
	RJMP _0x32
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00C1         delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x32:
	CALL SUBOPT_0x12
; 0000 00C2         ROW2 = 1 ;
	SBI  0x15,1
; 0000 00C3 show();
	RCALL _show
; 0000 00C4         ROW3 = 0 ;
	CBI  0x15,2
; 0000 00C5         delay_ms(50);   // in normal we use 2ms but proteus can not detect
	CALL SUBOPT_0x12
; 0000 00C6         if(C1==0) x = 7   ,press = 1  ;
	SBIC 0x13,4
	RJMP _0x37
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00C7         if(C2==0) x = 8   ,press = 1  ;
_0x37:
	SBIC 0x13,5
	RJMP _0x38
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00C8         if(C3==0) x = 9   ,press = 1  ;
_0x38:
	SBIC 0x13,6
	RJMP _0x39
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00C9         delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x39:
	CALL SUBOPT_0x12
; 0000 00CA         ROW3 = 1 ;
	SBI  0x15,2
; 0000 00CB show();
	RCALL _show
; 0000 00CC         ROW4 = 0 ;
	CBI  0x15,3
; 0000 00CD         delay_ms(50);   // in normal we use 2ms but proteus can not detect
	CALL SUBOPT_0x12
; 0000 00CE         if(C1==0) x = 100  ,press = 1   ;
	SBIC 0x13,4
	RJMP _0x3E
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00CF         if(C2==0) x = 0    ,press = 1 ;
_0x3E:
	SBIC 0x13,5
	RJMP _0x3F
	CLR  R4
	CLR  R5
	SET
	BLD  R2,0
; 0000 00D0         if(C3==0) x = 200  ,press = 1   ;
_0x3F:
	SBIC 0x13,6
	RJMP _0x40
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 00D1         delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x40:
	CALL SUBOPT_0x12
; 0000 00D2         ROW4 = 1 ;
	SBI  0x15,3
; 0000 00D3 show();
	RCALL _show
; 0000 00D4         }
	RET
; .FEND
;
;
;void main(void)
; 0000 00D8 {
_main:
; .FSTART _main
; 0000 00D9 
; 0000 00DA // USART initialization
; 0000 00DB // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00DC // USART Receiver: On
; 0000 00DD // USART Transmitter: On
; 0000 00DE // USART Mode: Asynchronous
; 0000 00DF // USART Baud Rate: 9600
; 0000 00E0 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00E1 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00E2 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00E3 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00E4 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00E5 
; 0000 00E6 DDRC = 0X0F ;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 00E7 DDRD = 0XC0 ;
	LDI  R30,LOW(192)
	OUT  0x11,R30
; 0000 00E8 
; 0000 00E9 
; 0000 00EA lcd_init(20);
	LDI  R26,LOW(20)
	CALL _lcd_init
; 0000 00EB 
; 0000 00EC lcd_gotoxy(1,0);
	CALL SUBOPT_0x13
; 0000 00ED lcd_puts("Enter ID to SIGN UP ");
	__POINTW2MN _0x43,0
	CALL SUBOPT_0x1
; 0000 00EE lcd_gotoxy(1,1);
; 0000 00EF lcd_puts("  Then Press <#> ");
	__POINTW2MN _0x43,21
	CALL SUBOPT_0x2
; 0000 00F0 
; 0000 00F1 lcd_gotoxy(0,3);
; 0000 00F2 lcd_puts("==> ");
	__POINTW2MN _0x43,39
	CALL SUBOPT_0x3
; 0000 00F3 
; 0000 00F4     pos_x = 4 ;
; 0000 00F5     pos_y = 3 ;
; 0000 00F6     new_id = 1 ;
	SET
	BLD  R2,1
; 0000 00F7 while (1)
_0x44:
; 0000 00F8       {
; 0000 00F9         keyboard();
	RCALL _keyboard
; 0000 00FA 
; 0000 00FB         if(break_mode == 1)
	SBRS R2,3
	RJMP _0x47
; 0000 00FC         {
; 0000 00FD         break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 00FE         break ;
	RJMP _0x46
; 0000 00FF         }
; 0000 0100 
; 0000 0101       }
_0x47:
	RJMP _0x44
_0x46:
; 0000 0102 
; 0000 0103 start :
_0x48:
; 0000 0104 
; 0000 0105 lcd_gotoxy(1,0);
	CALL SUBOPT_0x13
; 0000 0106 lcd_puts("Enter ID to log in ");
	__POINTW2MN _0x43,44
	CALL SUBOPT_0x1
; 0000 0107 lcd_gotoxy(1,1);
; 0000 0108 lcd_puts("  Then Press <#> ");
	__POINTW2MN _0x43,64
	CALL SUBOPT_0x2
; 0000 0109 
; 0000 010A lcd_gotoxy(0,3);
; 0000 010B lcd_puts("==> ");
	__POINTW2MN _0x43,82
	CALL SUBOPT_0x3
; 0000 010C     pos_x = 4 ;
; 0000 010D     pos_y = 3 ;
; 0000 010E     id_chk = 1 ;
	SET
	BLD  R2,5
; 0000 010F 
; 0000 0110 while (1)
_0x49:
; 0000 0111       {
; 0000 0112         keyboard();
	RCALL _keyboard
; 0000 0113 
; 0000 0114         if(break_mode == 1)
	SBRS R2,3
	RJMP _0x4C
; 0000 0115         {
; 0000 0116         break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 0117         break ;
	RJMP _0x4B
; 0000 0118         }
; 0000 0119 
; 0000 011A       }
_0x4C:
	RJMP _0x49
_0x4B:
; 0000 011B 
; 0000 011C delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 011D lcd_clear();
	CALL _lcd_clear
; 0000 011E 
; 0000 011F 
; 0000 0120 while(1)
_0x4D:
; 0000 0121 {
; 0000 0122         lcd_clear();
	CALL _lcd_clear
; 0000 0123         if(log_id == 0)
	LDS  R30,_log_id
	LDS  R31,_log_id+1
	SBIW R30,0
	BRNE _0x50
; 0000 0124         {
; 0000 0125             lcd_gotoxy(0,0);
	CALL SUBOPT_0x14
; 0000 0126             lcd_puts("LOGED IN AS : ADMIN");
	__POINTW2MN _0x43,87
	CALL SUBOPT_0x15
; 0000 0127                 lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0128             lcd_puts("1- ADD USER");
	__POINTW2MN _0x43,107
	CALL SUBOPT_0x15
; 0000 0129                 lcd_gotoxy(0,2);
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 012A             lcd_puts("2- SET TIME / DATE ");
	__POINTW2MN _0x43,119
	CALL SUBOPT_0x2
; 0000 012B                 lcd_gotoxy(0,3);
; 0000 012C             lcd_puts("3- LOG OUT");
	__POINTW2MN _0x43,139
	RJMP _0x9B
; 0000 012D         }
; 0000 012E         else
_0x50:
; 0000 012F         {
; 0000 0130             lcd_gotoxy(0,0);
	CALL SUBOPT_0x14
; 0000 0131             lcd_puts("LOGED IN AS : USER");
	__POINTW2MN _0x43,150
	CALL SUBOPT_0x15
; 0000 0132 
; 0000 0133                 lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0134             lcd_puts("1- CHECK DATE/TIME");
	__POINTW2MN _0x43,169
	CALL SUBOPT_0x15
; 0000 0135                 lcd_gotoxy(0,2);
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 0136             lcd_puts("2- TEMPERATURE ");
	__POINTW2MN _0x43,188
	CALL SUBOPT_0x2
; 0000 0137                 lcd_gotoxy(0,3);
; 0000 0138             lcd_puts("3- STEP MOTOR");
	__POINTW2MN _0x43,204
_0x9B:
	CALL _lcd_puts
; 0000 0139         }
; 0000 013A         while(1)
_0x52:
; 0000 013B         {
; 0000 013C         ROW1 = 0 ;
	CALL SUBOPT_0x10
; 0000 013D         delay_ms(50);   // in normal we use 2ms but proteus can not detect
; 0000 013E         if(C1==0) x = 1  ,press = 1  ;
	SBIC 0x13,4
	RJMP _0x57
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 013F         if(C2==0) x = 2  ,press = 1   ;
_0x57:
	SBIC 0x13,5
	RJMP _0x58
	CALL SUBOPT_0x11
; 0000 0140         if(C3==0) x = 3  ,press = 1   ;
_0x58:
	SBIC 0x13,6
	RJMP _0x59
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 0141         delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x59:
	CALL SUBOPT_0x12
; 0000 0142         ROW1 = 1 ;
	SBI  0x15,0
; 0000 0143 
; 0000 0144         if(press == 1)
	SBRC R2,0
; 0000 0145         {
; 0000 0146           break ;
	RJMP _0x54
; 0000 0147         }
; 0000 0148         }
	RJMP _0x52
_0x54:
; 0000 0149 
; 0000 014A press = 0 ;
	CLT
	BLD  R2,0
; 0000 014B delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 014C         if(log_id == 0 && x == 1)
	CALL SUBOPT_0x16
	BRNE _0x5E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
; 0000 014D         {
; 0000 014E             lcd_clear();
	CALL _lcd_clear
; 0000 014F             lcd_gotoxy(1,0);
	CALL SUBOPT_0x13
; 0000 0150             lcd_puts("Enter ID to SIGN UP ");
	__POINTW2MN _0x43,218
	CALL SUBOPT_0x1
; 0000 0151             lcd_gotoxy(1,1);
; 0000 0152             lcd_puts("  Then Press <#> ");
	__POINTW2MN _0x43,239
	CALL SUBOPT_0x2
; 0000 0153 
; 0000 0154             lcd_gotoxy(0,3);
; 0000 0155             lcd_puts("==> ");
	__POINTW2MN _0x43,257
	CALL SUBOPT_0x3
; 0000 0156 
; 0000 0157                 pos_x = 4 ;
; 0000 0158                 pos_y = 3 ;
; 0000 0159                 new_id =1 ;
	SET
	BLD  R2,1
; 0000 015A 
; 0000 015B            while(1)
_0x60:
; 0000 015C            {
; 0000 015D                 keyboard();
	RCALL _keyboard
; 0000 015E 
; 0000 015F                         if(break_mode == 1)
	SBRS R2,3
	RJMP _0x63
; 0000 0160                     {
; 0000 0161                     break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 0162                     break ;
	RJMP _0x62
; 0000 0163                     }
; 0000 0164            }
_0x63:
	RJMP _0x60
_0x62:
; 0000 0165 
; 0000 0166                    goto start ;
	RJMP _0x48
; 0000 0167         }
; 0000 0168 
; 0000 0169         if(log_id == 0 && x == 2)
_0x5D:
	CALL SUBOPT_0x16
	BRNE _0x65
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x66
_0x65:
	RJMP _0x64
_0x66:
; 0000 016A         {
; 0000 016B         lcd_clear();
	RCALL _lcd_clear
; 0000 016C         new_id = 0 ;
	CLT
	BLD  R2,1
; 0000 016D         new_pass = 0 ;
	BLD  R2,2
; 0000 016E         lcd_gotoxy(0,0);
	CALL SUBOPT_0x14
; 0000 016F         lcd_puts("To SET press <*> ");
	__POINTW2MN _0x43,262
	CALL SUBOPT_0x15
; 0000 0170         lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0171         lcd_puts("Enter Year : ");
	__POINTW2MN _0x43,280
	CALL SUBOPT_0x2
; 0000 0172         lcd_gotoxy(0,3);
; 0000 0173         lcd_puts("==> ");
	__POINTW2MN _0x43,294
	RCALL _lcd_puts
; 0000 0174 
; 0000 0175             while(1)
_0x67:
; 0000 0176             {
; 0000 0177                 keyboard();
	RCALL _keyboard
; 0000 0178                 if(break_mode == 1)
	SBRS R2,3
	RJMP _0x6A
; 0000 0179                 {
; 0000 017A                 break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 017B                 break ;
	RJMP _0x69
; 0000 017C                 }
; 0000 017D             }
_0x6A:
	RJMP _0x67
_0x69:
; 0000 017E             year = check ;
	CALL SUBOPT_0x17
	STS  _year,R30
	STS  _year+1,R31
; 0000 017F             check = 0 ;
	CALL SUBOPT_0x18
; 0000 0180             lcd_clear();
; 0000 0181         lcd_gotoxy(0,0);
; 0000 0182         lcd_puts("To SET press <*> ");
	__POINTW2MN _0x43,299
	CALL SUBOPT_0x15
; 0000 0183         lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0184         lcd_puts("Enter mount : ");
	__POINTW2MN _0x43,317
	CALL SUBOPT_0x2
; 0000 0185         lcd_gotoxy(0,3);
; 0000 0186         lcd_puts("==> ");
	__POINTW2MN _0x43,332
	RCALL _lcd_puts
; 0000 0187 
; 0000 0188             while(1)
_0x6B:
; 0000 0189             {
; 0000 018A                 keyboard();
	RCALL _keyboard
; 0000 018B                 if(break_mode == 1)
	SBRS R2,3
	RJMP _0x6E
; 0000 018C                 {
; 0000 018D                 break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 018E                 break ;
	RJMP _0x6D
; 0000 018F                 }
; 0000 0190             }
_0x6E:
	RJMP _0x6B
_0x6D:
; 0000 0191             mounth = check ;
	CALL SUBOPT_0x17
	STS  _mounth,R30
	STS  _mounth+1,R31
; 0000 0192             check = 0 ;
	CALL SUBOPT_0x18
; 0000 0193             lcd_clear();
; 0000 0194         lcd_gotoxy(0,0);
; 0000 0195         lcd_puts("To SET press <*> ");
	__POINTW2MN _0x43,337
	CALL SUBOPT_0x15
; 0000 0196             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0197             lcd_puts("Enter day : ");
	__POINTW2MN _0x43,355
	CALL SUBOPT_0x2
; 0000 0198             lcd_gotoxy(0,3);
; 0000 0199             lcd_puts("==> ");
	__POINTW2MN _0x43,368
	RCALL _lcd_puts
; 0000 019A 
; 0000 019B             while(1)
_0x6F:
; 0000 019C             {
; 0000 019D                 keyboard();
	RCALL _keyboard
; 0000 019E                 if(break_mode == 1)
	SBRS R2,3
	RJMP _0x72
; 0000 019F                 {
; 0000 01A0                 break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 01A1                 break ;
	RJMP _0x71
; 0000 01A2                 }
; 0000 01A3             }
_0x72:
	RJMP _0x6F
_0x71:
; 0000 01A4             day = check ;
	CALL SUBOPT_0x17
	STS  _day,R30
	STS  _day+1,R31
; 0000 01A5             check = 0 ;
	CALL SUBOPT_0x18
; 0000 01A6             lcd_clear();
; 0000 01A7         lcd_gotoxy(0,0);
; 0000 01A8         lcd_puts("To SET press <*> ");
	__POINTW2MN _0x43,373
	CALL SUBOPT_0x15
; 0000 01A9             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 01AA             lcd_puts("Enter hour : ");
	__POINTW2MN _0x43,391
	CALL SUBOPT_0x2
; 0000 01AB             lcd_gotoxy(0,3);
; 0000 01AC             lcd_puts("==> ");
	__POINTW2MN _0x43,405
	RCALL _lcd_puts
; 0000 01AD 
; 0000 01AE             while(1)
_0x73:
; 0000 01AF             {
; 0000 01B0                 keyboard();
	RCALL _keyboard
; 0000 01B1                 if(break_mode == 1)
	SBRS R2,3
	RJMP _0x76
; 0000 01B2                 {
; 0000 01B3                 break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 01B4                 break ;
	RJMP _0x75
; 0000 01B5                 }
; 0000 01B6             }
_0x76:
	RJMP _0x73
_0x75:
; 0000 01B7             hour = check ;
	CALL SUBOPT_0x17
	STS  _hour,R30
	STS  _hour+1,R31
; 0000 01B8             check = 0 ;
	CALL SUBOPT_0x18
; 0000 01B9             lcd_clear();
; 0000 01BA         lcd_gotoxy(0,0);
; 0000 01BB         lcd_puts("To SET press <*> ");
	__POINTW2MN _0x43,410
	CALL SUBOPT_0x15
; 0000 01BC             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 01BD             lcd_puts("Enter minute : ");
	__POINTW2MN _0x43,428
	CALL SUBOPT_0x2
; 0000 01BE             lcd_gotoxy(0,3);
; 0000 01BF             lcd_puts("==> ");
	__POINTW2MN _0x43,444
	RCALL _lcd_puts
; 0000 01C0 
; 0000 01C1             while(1)
_0x77:
; 0000 01C2             {
; 0000 01C3                 keyboard();
	RCALL _keyboard
; 0000 01C4                 if(break_mode == 1)
	SBRS R2,3
	RJMP _0x7A
; 0000 01C5                 {
; 0000 01C6                 break_mode = 0 ;
	CLT
	BLD  R2,3
; 0000 01C7                 break ;
	RJMP _0x79
; 0000 01C8                 }
; 0000 01C9             }
_0x7A:
	RJMP _0x77
_0x79:
; 0000 01CA             minute = check ;
	CALL SUBOPT_0x17
	STS  _minute,R30
	STS  _minute+1,R31
; 0000 01CB             check = 0 ;
	LDI  R30,LOW(0)
	STS  _check,R30
	STS  _check+1,R30
	STS  _check+2,R30
	STS  _check+3,R30
; 0000 01CC         }
; 0000 01CD 
; 0000 01CE         if(log_id == 0 && x == 3)
_0x64:
	CALL SUBOPT_0x16
	BRNE _0x7C
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
; 0000 01CF         {
; 0000 01D0             lcd_clear();
	RCALL _lcd_clear
; 0000 01D1             goto start ;
	RJMP _0x48
; 0000 01D2         }
; 0000 01D3 
; 0000 01D4         if(log_id == 1 && x == 1)
_0x7B:
	CALL SUBOPT_0x19
	BRNE _0x7F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x80
_0x7F:
	RJMP _0x7E
_0x80:
; 0000 01D5         {
; 0000 01D6             lcd_clear();
	CALL SUBOPT_0x0
; 0000 01D7 
; 0000 01D8             lcd_gotoxy(0,0);
; 0000 01D9             lcd_puts( "     << DATE >>    ");
	__POINTW2MN _0x43,449
	CALL SUBOPT_0x15
; 0000 01DA 
; 0000 01DB                 lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0xB
; 0000 01DC             sprintf(c,"      %d / %d / %d ",year , mounth , day);
	__POINTW1FN _0x0,418
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_year
	LDS  R31,_year+1
	CALL SUBOPT_0x1A
	LDS  R30,_mounth
	LDS  R31,_mounth+1
	CALL SUBOPT_0x1A
	LDS  R30,_day
	LDS  R31,_day+1
	CALL SUBOPT_0x1A
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01DD             lcd_puts(c);
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL SUBOPT_0x15
; 0000 01DE                 lcd_gotoxy(0,2);
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 01DF             lcd_puts( "     << TIME >>    ");
	__POINTW2MN _0x43,469
	CALL SUBOPT_0x2
; 0000 01E0                 lcd_gotoxy(0,3);
; 0000 01E1             sprintf(c,"       %d : %d     ",hour , minute);
	LDI  R30,LOW(_c)
	LDI  R31,HIGH(_c)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,458
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_hour
	LDS  R31,_hour+1
	CALL SUBOPT_0x1A
	LDS  R30,_minute
	LDS  R31,_minute+1
	CALL SUBOPT_0x1A
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 01E2             lcd_puts(c);
	CALL SUBOPT_0x1B
; 0000 01E3 
; 0000 01E4             delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 01E5             press = 0 ;
	CLT
	BLD  R2,0
; 0000 01E6         }
; 0000 01E7 
; 0000 01E8         if(log_id == 1 && x == 2)
_0x7E:
	CALL SUBOPT_0x19
	BRNE _0x82
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 01E9         {
; 0000 01EA             puts("TEMP");
	__POINTW2MN _0x43,489
	CALL _puts
; 0000 01EB             lcd_clear();
	CALL SUBOPT_0x0
; 0000 01EC             lcd_gotoxy(0,0);
; 0000 01ED             lcd_puts("Temp =");
	__POINTW2MN _0x43,494
	RCALL _lcd_puts
; 0000 01EE             lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0xB
; 0000 01EF             gets(c,15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _gets
; 0000 01F0             lcd_puts(c);
	CALL SUBOPT_0x1B
; 0000 01F1 
; 0000 01F2             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 01F3 
; 0000 01F4 
; 0000 01F5 
; 0000 01F6         }
; 0000 01F7 
; 0000 01F8         if(log_id == 1 && x == 3)
_0x81:
	CALL SUBOPT_0x19
	BRNE _0x85
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x86
_0x85:
	RJMP _0x84
_0x86:
; 0000 01F9         {
; 0000 01FA             lcd_clear();
	CALL SUBOPT_0x0
; 0000 01FB             lcd_gotoxy(0,0);
; 0000 01FC             lcd_puts("  enter step motor  ");
	__POINTW2MN _0x43,501
	CALL SUBOPT_0x15
; 0000 01FD             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 01FE             lcd_puts("steps between(2-4-8)");
	__POINTW2MN _0x43,522
	RCALL _lcd_puts
; 0000 01FF 
; 0000 0200                     while(1)
_0x87:
; 0000 0201                     {
; 0000 0202                     ROW1 = 0 ;
	CALL SUBOPT_0x10
; 0000 0203                     delay_ms(50);   // in normal we use 2ms but proteus can not detect
; 0000 0204                     if(C2==0) x = 2  ,press = 1   ;
	SBIC 0x13,5
	RJMP _0x8C
	CALL SUBOPT_0x11
; 0000 0205                     delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x8C:
	CALL SUBOPT_0x12
; 0000 0206                     ROW1 = 1 ;
	SBI  0x15,0
; 0000 0207                     ROW2 = 0 ;
	CBI  0x15,1
; 0000 0208                     delay_ms(50);   // in normal we use 2ms but proteus can not detect
	CALL SUBOPT_0x12
; 0000 0209                     if(C1==0) x = 4   ,press = 1  ;
	SBIC 0x13,4
	RJMP _0x91
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 020A                     delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x91:
	CALL SUBOPT_0x12
; 0000 020B                     ROW2 = 1 ;
	SBI  0x15,1
; 0000 020C                     ROW3 = 0 ;
	CBI  0x15,2
; 0000 020D                     delay_ms(50);   // in normal we use 2ms but proteus can not detect
	CALL SUBOPT_0x12
; 0000 020E                     if(C2==0) x = 8   ,press = 1  ;
	SBIC 0x13,5
	RJMP _0x96
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R4,R30
	SET
	BLD  R2,0
; 0000 020F                     delay_ms(50);   // in normal we use 2ms but proteus can not detect
_0x96:
	CALL SUBOPT_0x12
; 0000 0210                     ROW3 = 1 ;
	SBI  0x15,2
; 0000 0211 
; 0000 0212 
; 0000 0213                         if(press == 1)
	SBRS R2,0
	RJMP _0x99
; 0000 0214                         {
; 0000 0215                         press = 0 ;
	CLT
	BLD  R2,0
; 0000 0216                           break ;
	RJMP _0x89
; 0000 0217                         }
; 0000 0218                     }
_0x99:
	RJMP _0x87
_0x89:
; 0000 0219              sprintf(c,"step %d",x);
	LDI  R30,LOW(_c)
	LDI  R31,HIGH(_c)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,532
	CALL SUBOPT_0xC
; 0000 021A 
; 0000 021B              puts(c);
	CALL _puts
; 0000 021C              lcd_gotoxy(3,3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 021D              lcd_puts(c);
	CALL SUBOPT_0x1B
; 0000 021E 
; 0000 021F              delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0220 
; 0000 0221 
; 0000 0222         }
; 0000 0223 }
_0x84:
	RJMP _0x4D
; 0000 0224 
; 0000 0225 
; 0000 0226 }
_0x9A:
	RJMP _0x9A
; .FEND

	.DSEG
_0x43:
	.BYTE 0x21F
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	JMP  _0x2080003
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	JMP  _0x2080003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1C
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1C
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	JMP  _0x2080003
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	JMP  _0x2080003
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	CALL SUBOPT_0x1D
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	JMP  _0x2080002
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	JMP  _0x2080003
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
_getchar:
; .FSTART _getchar
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
; .FEND
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2080003:
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020003:
	CALL SUBOPT_0x1D
	BREQ _0x2020005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2020003
_0x2020005:
	LDI  R26,LOW(10)
	RCALL _putchar
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_gets:
; .FSTART _gets
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	__GETWRS 16,17,6
	__GETWRS 18,19,8
_0x2020009:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x202000B
_0x202000C:
	RCALL _getchar
	MOV  R21,R30
	CPI  R21,8
	BRNE _0x202000D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R16,R26
	CPC  R17,R27
	BRSH _0x202000E
	__SUBWRN 18,19,1
	__ADDWRN 16,17,1
_0x202000E:
	RJMP _0x202000C
_0x202000D:
	CPI  R21,10
	BREQ _0x202000B
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOV  R30,R21
	POP  R26
	POP  R27
	ST   X,R30
	__SUBWRN 16,17,1
	RJMP _0x2020009
_0x202000B:
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
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
_0x2020016:
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
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x1F
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x1F
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x20
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x21
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x1F
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
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
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x21
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x21
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x24
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x24
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
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

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

	.DSEG
_log_id:
	.BYTE 0x2
_c:
	.BYTE 0x14
_id:
	.BYTE 0x28
_pass:
	.BYTE 0x28
_check:
	.BYTE 0x4
_year:
	.BYTE 0x2
_mounth:
	.BYTE 0x2
_day:
	.BYTE 0x2
_hour:
	.BYTE 0x2
_minute:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x0:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	CALL _lcd_puts
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x2:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(3)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	CALL _lcd_puts
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R6,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_id)
	LDI  R27,HIGH(_id)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	LDS  R26,_check
	LDS  R27,_check+1
	LDS  R24,_check+2
	LDS  R25,_check+3
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
	STS  _check,R30
	STS  _check+1,R30
	STS  _check+2,R30
	STS  _check+3,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	CLT
	BLD  R2,4
	SBI  0x12,7
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	CALL _lcd_clear
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	CALL _lcd_puts
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	CALL _lcd_gotoxy
	LDI  R30,LOW(_c)
	LDI  R31,HIGH(_c)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	MOVW R26,R30
	CALL __GETD1P
	__GETD2N 0xA
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R4
	CALL __CWD1
	CALL __ADDD12
	MOVW R26,R0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	STS  _check,R30
	STS  _check+1,R31
	STS  _check+2,R22
	STS  _check+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	CBI  0x15,0
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
	SET
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x15:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDS  R26,_log_id
	LDS  R27,_log_id+1
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDS  R30,_check
	LDS  R31,_check+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	STS  _check,R30
	STS  _check+1,R30
	STS  _check+2,R30
	STS  _check+3,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDS  R26,_log_id
	LDS  R27,_log_id+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
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
SUBOPT_0x23:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
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
