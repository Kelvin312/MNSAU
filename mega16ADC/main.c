/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 28.07.2015
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

// USART Receiver buffer
#define RX_BUFFER_SIZE 4
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
/*
// USART Transmitter buffer
#define TX_BUFFER_SIZE 128
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
*/
// Standard Input/Output functions
#include <stdio.h>

#define MIGMIG PORTB.5


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCCR0=0x00;
TCNT0=0x00;
}
 
#define FIRST_U_ADC_INPUT 5
#define FIRST_I_ADC_INPUT 1
#define ZU_ADC_INPUT 4
#define ZI_ADC_INPUT 0   
#define FREQUENCY_ADC_INPUT 6
#define ADC_BUF_SIZE 64   //Больше - глючит
#define ADC_VREF_TYPE 0x00

unsigned char adc_data[8][ADC_BUF_SIZE];
unsigned long adc_current[8], adc_real[8];
unsigned char adc_count[8], s_val[8];
unsigned char adc_temp;
unsigned char adc_rd_input, adc_wr_input, adc_wr_index, adc_rd_index;
unsigned char isRising[8] = {0,0,0,0,0,0,0,0}, isUpdate[8] = {0,0,0,0,0,0,0,0}, isFregUpd = 0;
unsigned int last_time = 0;
unsigned int freg = 0;


// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCNT2=0x06;
// Place your code here

if(adc_rd_input == 0)
{
     TCNT0=0xEC; //10us
     TCCR0=0x02;
     MIGMIG ^= 1;
}
}


// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
    adc_temp = ADCW>>2;
// Select next ADC input
    adc_rd_input = adc_wr_input + 1;
    if(adc_rd_input > 7) adc_rd_input = 0;
    ADMUX=(ADC_VREF_TYPE & 0xff) | adc_rd_input;
// Delay needed for the stabilization of the ADC input voltage
    if(adc_rd_input)
    {
      TCNT0=0xEC;  //10us
      TCCR0=0x02;
    }

adc_data[adc_wr_input][adc_wr_index] = adc_temp;

if(adc_temp & 0x80)
{
  if(!isRising[adc_wr_input])  
  {
    //Нарастающий  
    if(adc_wr_input == FREQUENCY_ADC_INPUT)
    {
        last_time = TCNT1;
        TCNT1H=0x00;
        TCNT1L=0x00;
        isFregUpd = 1;  
    }
    adc_real[adc_wr_input] =  adc_current[adc_wr_input];
    adc_current[adc_wr_input] = 0;
    isRising[adc_wr_input] = 1;
    isUpdate[adc_wr_input] = adc_count[adc_wr_input]; 
    adc_count[adc_wr_input] = 0;
  }
}
else
{
  if(adc_temp < 120) isRising[adc_wr_input] = 0;
  adc_temp = 127 - adc_temp;
}

adc_temp &= 0x7F;
adc_current[adc_wr_input] += adc_temp * adc_temp; 
adc_count[adc_wr_input]++;

// Select next ADC input
if (++adc_wr_input > 7) 
{
    adc_wr_input = 0;
    if(++adc_wr_index >= ADC_BUF_SIZE) adc_wr_index = 0; 
	if(adc_wr_index == adc_rd_index)
	{
		if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
	}
}
}

unsigned char isqrt( unsigned int from) 
{
     unsigned int mask = 0x4000, sqr = 0, temp;
     do 
     {
         temp = sqr | mask;
         sqr >>= 1;
         if( temp <= from ) {
             sqr |= mask;
             from -= temp;
         }
     } while( mask >>= 2 );
     //округление 
     if( sqr < from ) ++sqr;
     return (unsigned char)sqr;
}

inline void main_loop()
{
    char i, j;
    unsigned int s_tval;
    for(i=0; i<8; i++)
    {
        if(isUpdate[i])
        {
            s_tval = adc_real[i]/isUpdate[i];
            isUpdate[i] = 0;
            s_val[i] = isqrt(s_tval);
        }
    }
    if(isFregUpd)
    {
      // Период в тиках 62,500 kHz
      freg = 62500 / last_time; 
      isFregUpd = 0;
    }
    
    
    if(rx_counter)
    {
        switch(getchar())
        {
            case 'U':  
                j = FIRST_U_ADC_INPUT + 3; 
                while(adc_rd_index != adc_wr_index)
                {
                        for(i=FIRST_U_ADC_INPUT; i<j; i++)
                        {
                            putchar(adc_data[i][adc_rd_index]); 
                            #asm("nop")
                            #asm("wdr")
                            #asm("nop")
                        }
                    if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
                }
            break;
            case 'I':
                j = FIRST_I_ADC_INPUT + 3; 
                while(adc_rd_index != adc_wr_index)
                {
                        for(i=FIRST_I_ADC_INPUT; i<j; i++)
                        {
                            putchar(adc_data[i][adc_rd_index]);
                            #asm("nop")
                            #asm("wdr")
                            #asm("nop")
                        }
                    if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
                }
            break;
            case 'Z':
                while(adc_rd_index != adc_wr_index)
                {   
                    putchar(adc_data[ZU_ADC_INPUT][adc_rd_index]); 
                    #asm("nop")
                    #asm("wdr")
                    #asm("nop")
                    putchar(adc_data[ZI_ADC_INPUT][adc_rd_index]);
					          #asm("nop")
                    #asm("wdr")
                    #asm("nop")
                    if(++adc_rd_index >= ADC_BUF_SIZE) adc_rd_index = 0;
                }
            break;
            case 'S': 
                // Частота Гц
                putchar(freg & 0xFF); 
                // Среднеквадратичные
                for(i=0; i<8; i++)
                {
                    putchar(s_val[i]);
                    #asm("nop")
                    #asm("wdr")
                    #asm("nop")
                }
            break;
        }
    }
}


// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x20;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 2000,000 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
//TCCR0=0x02;
TCNT0=0xE2;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 62,500 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x04;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 250,000 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x04;
TCNT2=0x06;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x41;

// USART initialization  
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x08;

// USART initialization  // Без ТХ прерывания
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x08;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 250,000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: Timer0 Overflow
ADMUX=(ADC_VREF_TYPE & 0xff);
ADCSRA=0xAE;
SFIOR&=0x1F;
SFIOR|=0x80;

// ADC initialization // На штатной частоте
// ADC Clock frequency: 125,000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: Timer0 Overflow
ADMUX= (ADC_VREF_TYPE & 0xff);
ADCSRA=0xAF;
SFIOR&=0x1F;
SFIOR|=0x80;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/256k
#pragma optsize-
WDTCR=0x1C;
WDTCR=0x0C;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")

while (1)
      {
      #asm("wdr")
      main_loop();
      }
}
