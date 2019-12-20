;Objective:
;You are required to program the ability to detect button presses on the carrier board
;and light LED’s on ARM Cortex M3 microcontroller using general purpose I/O.

; GPIO Test programer - LiPan


;;; Directives
            PRESERVE8
            THUMB       

        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value


;PORT A GPIO - Base Addr: 0x40010800
GPIOA_CRL	EQU		0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOA_CRH	EQU		0x40010804	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOA_IDR	EQU		0x40010808	; (0x08) Port Input Data Register
GPIOA_ODR	EQU		0x4001080C	; (0x0C) Port Output Data Register
GPIOA_BSRR	EQU		0x40010810	; (0x10) Port Bit Set/Reset Register
GPIOA_BRR	EQU		0x40010814	; (0x14) Port Bit Reset Register
GPIOA_LCKR	EQU		0x40010818	; (0x18) Port Configuration Lock Register

;PORT B GPIO - Base Addr: 0x40010C00
GPIOB_CRL	EQU		0x40010C00	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOB_CRH	EQU		0x40010C04	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOB_IDR	EQU		0x40010C08	; (0x08) Port Input Data Register
GPIOB_ODR	EQU		0x40010C0C	; (0x0C) Port Output Data Register
GPIOB_BSRR	EQU		0x40010C10	; (0x10) Port Bit Set/Reset Register
GPIOB_BRR	EQU		0x40010C14	; (0x14) Port Bit Reset Register
GPIOB_LCKR	EQU		0x40010C18	; (0x18) Port Configuration Lock Register

;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOC_CRH	EQU		0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOC_IDR	EQU		0x40011008	; (0x08) Port Input Data Register
GPIOC_ODR	EQU		0x4001100C	; (0x0C) Port Output Data Register
GPIOC_BSRR	EQU		0x40011010	; (0x10) Port Bit Set/Reset Register
GPIOC_BRR	EQU		0x40011014	; (0x14) Port Bit Reset Register
GPIOC_LCKR	EQU		0x40011018	; (0x18) Port Configuration Lock Register

;Registers for configuring and enabling the clocks
;RCC Registers - Base Addr: 0x40021000
RCC_CR		EQU		0x40021000	; Clock Control Register
RCC_CFGR	EQU		0x40021004	; Clock Configuration Register
RCC_CIR		EQU		0x40021008	; Clock Interrupt Register
RCC_APB2RSTR	EQU	0x4002100C	; APB2 Peripheral Reset Register
RCC_APB1RSTR	EQU	0x40021010	; APB1 Peripheral Reset Register
RCC_AHBENR	EQU		0x40021014	; AHB Peripheral Clock Enable Register

RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register  -- Used

RCC_APB1ENR	EQU		0x4002101C	; APB1 Peripheral Clock Enable Register
RCC_BDCR	EQU		0x40021020	; Backup Domain Control Register
RCC_CSR		EQU		0x40021024	; Control/Status Register
RCC_CFGR2	EQU		0x4002102C	; Clock Configuration Register 2

; Times for delay routines
        
DELAYTIME	EQU		1600000		; (200 ms/24MHz PLL)


; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
			
            AREA    MYCODE, CODE, READONLY
	    EXPORT	Reset_Handler
	    ENTRY

Reset_Handler PROC

		BL GPIO_ClockInit
		BL GPIO_init
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
		ldr r0,=GPIOA_ODR
		ldr r1,[r0]
		orr r1,r1,#0x00001e00
		str r1,[r0]
mainLoop
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check the SW2 of PB8 on the bit 8 is active low
;red
		ldr r0,=GPIOB_IDR
		ldr r1,[r0]
		lsr r1,#8
		and r1,#1
		cmp r1,#0
		BEQ red_on
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check the SW3 of PB9 on the bit 9 is active low
black	

		ldr r0,=GPIOB_IDR
		ldr r1,[r0]
		lsr r1,#9
		and r1,#1
		cmp r1,#0
		BEQ black_on
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check the SW4 PC12 on the bit 12 is active low
blue
		ldr r0,=GPIOC_IDR
		ldr r1,[r0]
		lsr r1,#12
		and r1,#1
		cmp r1,#0
		BEQ blue_on

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check the SW5 PA5 on the bit 5 is active low
green
		ldr r0,=GPIOA_IDR
		ldr r1,[r0]
		lsr r1,#5
		and r1,#1
		cmp r1,#0
		BEQ green_on


turn_off_all
		ldr r0,=GPIOA_ODR
		orr r1,r1,#0x00001e00
		str r1,[r0]
			
		
		B	mainLoop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;For GPIOx_ODR find the right bit, make it active low for the led is on 
;
red_on
		ldr r0,=GPIOA_ODR
		ldr r1,[r0]
		ldr r4,=0xfffffdff
		and r1,r1,r4
		str r1,[r0]
		B black
	
black_on
		ldr r0,=GPIOA_ODR
		ldr r1,[r0]
		ldr r4,=0xfffffbff
		and r1,r1,r4
		str r1,[r0]
		B blue
blue_on
		ldr r0,=GPIOA_ODR
		ldr r1,[r0]
		ldr r4,=0xfffff7ff
		and r1,r1,r4
		str r1,[r0]
		B green
green_on
		ldr r0,=GPIOA_ODR
		ldr r1,[r0]
		ldr r4,=0xffffefff
		and r1,r1,r4
		str r1,[r0]
		B turn_off_all

		ENDP


;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;This routine will enable the clock for the Ports that you need	
	ALIGN
GPIO_ClockInit PROC

	; Students to write.  Registers   .. RCC_APB2ENR
	; ENEL 384 Pushbuttons: SW2(Red): PB8, SW3(Black): PB9, SW4(Blue): PC12 *****NEW for 2015**** SW5(Green): PA5
	; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;RCC_APB2ENR is enable the CLOCK
;find the register map for RCC_APB2ENR
;enable port a , port b, and port c

	ldr r0,=RCC_APB2ENR
	ldr r1,[r0]					
	ldr r4,=0x1c			;for active port a,b,c: 0001 1100
	orr r1,r1,r4
	str r1,[r0]
	
	BX LR
	ENDP
		
	
	
;This routine enables the GPIO for the LED's.  By default the I/O lines are input so we only need to configure for ouptut.
	ALIGN
GPIO_init  PROC
	
; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;for enable GPIOA_CRH P112 memory map;The reset value:ox4444 4444
;CNF:General purpose 00  MODE:ourput 50MHz 11
;make PIN 9,10,11,12 --0011
	
	LDR R0, =GPIOA_CRH
	ldr r1,=0x44433334
	str r1,[r0]

    	BX LR
	ENDP
		




	ALIGN
	END
