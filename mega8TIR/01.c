/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 19.09.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <delay.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)


char uart_timeout=0;

// USART Receiver buffer
#define RX_BUFFER_SIZE 32
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   { 
   uart_timeout = 0;
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 32
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>


#define LEDBLUE PORTB.0
#define LEDGREEN PORTB.1
#define RS485 PORTB.4
//#define DR1 PORTD.5
//#define DR2 PORTD.6
//#define DR3 PORTD.7
inline void DrOff(char n)
{
    PORTD |= 1<<(n+4);
}
inline void DrOn(char n)
{
    PORTD &= ~(1<<(n+4));
}

char test;

signed int regVal[4] = {0,20000,20000,20000}; //0 - 20000
signed int stepVal[4] = {10,10,10,10}; //1 - 100
char flipFlop[4] = {0,0,0,0}; //0-1
signed int temp[4];
char index=0;


#define T_FREE 0x00
/*#define T_ON1  0x11
#define T_OFF1 0x01
#define T_ON2  0x12
#define T_OFF2 0x02
#define T_ON3  0x13
#define T_OFF3 0x03*/
#define TIME_OFF 100

char tValA = T_FREE, tValB = T_FREE;
char uart_firstByte=0;

 
// Timer 0 overflow interrupt service routine 1 ms
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x06;

if(++uart_timeout>15) //&& uart_timeout < 17)
{
   // RS485 = 1;
   // delay_ms(5);
    //putchar(0xEE);
   // putchar(test);
     
    while (rx_counter) getchar(); 
    uart_firstByte = 1;
}   

//if(uart_timeout > 50) RS485 = 0;

if(uart_timeout>250) LEDBLUE = 1;

}



inline void TimeAdd(char i)
{
    if(regVal[i] < 8)
    {
        DrOn(i);
        if(tValA == T_FREE)
        {
            OCR1A = TCNT1+TIME_OFF;
            tValA = i;  
        } 
        else if(tValB == T_FREE)
        { 
            OCR1B = TCNT1+TIME_OFF;
            tValB = i; 
        }    
    }
    else
    {
        if(tValA == T_FREE)
        {
            OCR1A = TCNT1+regVal[i];
            tValA = i|0x10;  
        } 
        else if(tValB == T_FREE)
        { 
            OCR1B = TCNT1+regVal[i];
            tValB = i|0x10; 
        }
    }   
}



// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    TimeAdd(1);
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    TimeAdd(2);
}

// External Interrupt 2 service routine
interrupt [EXT_INT2] void ext_int2_isr(void)
{
    TimeAdd(3);
}


// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    if(tValA & 0x10)
    {
        OCR1A = TCNT1+TIME_OFF;
        tValA &= 0x07; 
        DrOn(tValA);     
    } 
    else if(tValA)
    {
        DrOff(tValA);
        tValA = 0;   
    }

}

// Timer1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
    if(tValB & 0x10)
    {
        OCR1B = TCNT1+TIME_OFF;
        tValB &= 0x07; 
        DrOn(tValB);     
    } 
    else if(tValB)
    {
        DrOff(tValB);
        tValB = 0;   
    }

}








// Declare your global variables here

void main(void)
{
// Declare your local variables here
{
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=0 State3=T State2=T State1=0 State0=0 
PORTB=0x00;
DDRB=0x13;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=1 State6=1 State5=1 State4=T State3=T State2=T State1=T State0=T 
PORTD=0xE0;
DDRD=0xE0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 250,000 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x03;
TCNT0=0x06;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 2000,000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: On
TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x01;
OCR1BH=0x00;
OCR1BL=0x01;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: On
// INT2 Mode: Falling Edge
GICR|=0xE0;
MCUCR=0x0A;
MCUCSR=0x00;
GIFR=0xE0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x19;


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")
}
RS485 = 0;
LEDGREEN = 0;
LEDBLUE = 1;

while (1)
      {
          if(rx_counter > 6 && uart_firstByte)
          { 
              if(getchar() == 0x66)
              if(getchar() == 0x06)
              if(getchar() == 0x60)
              {
                LEDBLUE = 0;
                for(index=0; index<3; index++)
                {
                    temp[index] = getchar();
                    temp[index] -= 100; 
                    if(flipFlop[index] && temp[index] > 0 || !flipFlop[index] && temp[index] < 0) 
                    {
                        stepVal[index]<<=1;
                        if(stepVal[index] > 100) stepVal[index] = 100; 
                    }
                    else if(temp[index] != 0)
                    {
                        stepVal[index]>>=1;
                        if(stepVal[index] < 1) stepVal[index] = 1;
                    }
                     
                    
                    if(temp[index]<0)
                    {
                        #asm("cli")
                        regVal[index+1] += stepVal[index]*temp[index];
                        if(regVal[index+1] < 1) regVal[index+1] = 1;
                        #asm("sei")
                        flipFlop[index] = 0;
                    }
                    else if(temp[index] > 0)
                    {
                        #asm("cli")
                        regVal[index+1] += stepVal[index]*temp[index];
                        if(regVal[index+1] > 20000 || regVal[index+1] < 1) regVal[index+1] = 20000;
                        #asm("sei")
                        flipFlop[index] = 1;
                    }
                }
  
              }
             uart_firstByte = 0; 
              
          }   
      }
}



