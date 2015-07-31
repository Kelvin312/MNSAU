/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 29.07.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128.h>
#include <delay.h>
#include "Font16x16.c"
#include "SSD1963.c"
#include "TSC2046.c"

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

// USART2 Receiver buffer
#define RX_BUFFER_SIZE2 20
char rx_buffer2[RX_BUFFER_SIZE2];

#if RX_BUFFER_SIZE2 <= 256
unsigned char rx_wr_index2,rx_rd_index2,rx_counter2;
#else
unsigned int rx_wr_index2,rx_rd_index2,rx_counter2;
#endif

//Переключатель юарта
char uart_swap = 0;

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 256
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
{
   if(uart_swap) //Юарт 2
   {
      rx_buffer2[rx_wr_index2++]=data;
      if (rx_wr_index2 == RX_BUFFER_SIZE2) rx_wr_index2=0; 
      ++rx_counter2;
   }
   else //Юарт 0
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0)
      {
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      //rx_counter0=0;
#endif
      rx_buffer_overflow0=1;  //Ааааа переполнение
      rx_counter0=RX_BUFFER_SIZE0-1; 
      if(rx_wr_index0) rx_wr_index0--; else rx_wr_index0=rx_counter0;
      }
   }
}
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar0(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}


char getchar2(void) //Юарт 2
{
char data;
while (rx_counter2==0);
data=rx_buffer2[rx_rd_index2++];
if (rx_rd_index2 == RX_BUFFER_SIZE2) rx_rd_index2=0;
#asm("cli")
--rx_counter2;
#asm("sei")
return data;
}

#pragma used-
#endif

// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 8
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif

// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
inline void putchar0_i(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}

void putchar0(char c)
{
    uart_swap = 0;
    putchar0_i(c);
}

void putchar2(char c)
{
    uart_swap = 2;
    putchar0_i(c);
}

#pragma used-
#endif

// USART1 Receiver buffer
#define RX_BUFFER_SIZE1 32
char rx_buffer1[RX_BUFFER_SIZE1];

#if RX_BUFFER_SIZE1 <= 256
unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
#else
unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
#endif

// This flag is set on USART1 Receiver buffer overflow
bit rx_buffer_overflow1;

// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
char status,data;
status=UCSR1A;
data=UDR1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer1[rx_wr_index1++]=data;
#if RX_BUFFER_SIZE1 == 256
   // special case for receiver buffer size=256
   if (++rx_counter1 == 0)
      {
#else
   if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
   if (++rx_counter1 == RX_BUFFER_SIZE1)
      {
      rx_counter1=0;
#endif
      rx_buffer_overflow1=1;
      }
   }
}

// Get a character from the USART1 Receiver buffer
#pragma used+
char getchar(void)
{
char data;
while (rx_counter1==0);
data=rx_buffer1[rx_rd_index1++];
#if RX_BUFFER_SIZE1 != 256
if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
#endif
#asm("cli")
--rx_counter1;
#asm("sei")
return data;
}
#pragma used-
// USART1 Transmitter buffer
#define TX_BUFFER_SIZE1 64
char tx_buffer1[TX_BUFFER_SIZE1];

#if TX_BUFFER_SIZE1 <= 256
unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
#else
unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
#endif

// USART1 Transmitter interrupt service routine
interrupt [USART1_TXC] void usart1_tx_isr(void)
{
if (tx_counter1)
   {
   --tx_counter1;
   UDR1=tx_buffer1[tx_rd_index1++];
#if TX_BUFFER_SIZE1 != 256
   if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
#endif
   }
}

// Write a character to the USART1 Transmitter buffer
#pragma used+
void putchar(char c)
{
while (tx_counter1 == TX_BUFFER_SIZE1);
#asm("cli")
if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer1[tx_wr_index1++]=c;
#if TX_BUFFER_SIZE1 != 256
   if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
#endif
   ++tx_counter1;
   }
else
   UDR1=c;
#asm("sei")
}
#pragma used-

// Standard Input/Output functions
#include <stdio.h>


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
#define RS485 PORTD.4
#define BACKLIGHT PORTB.7

#define Graph_X_Min 0
#define Graph_X_Max 478
#define Graph_Y_Min 42
#define Graph_Y_Max 232
#define Graph_Step_N 2 //1..3

flash unsigned int Graph_X_Step = (Graph_X_Max-Graph_X_Min)/72;
flash unsigned int Graph_Y_Mid = (Graph_Y_Max-Graph_Y_Min)/2 + Graph_Y_Min;

#define Text_StartX 16 
#define Text_StartY 6

#define Value_StartX 290 
#define Value_StartY 6
#define Value_Lenght (16*4)

#define BTN_StartX 6
#define BTN_StartY 240
#define BTN_Width 100
#define BTN_Height 30
#define BTN_Between 20

flash unsigned int BTN1_Y_Begin = BTN_StartY;
flash unsigned int BTN1_Y_End = BTN_StartY + BTN_Height;
flash unsigned int BTN1_X_Begin = BTN_StartX;
flash unsigned int BTN1_X_End = BTN_StartX + BTN_Width;

flash unsigned int BTN2_Y_Begin = BTN_StartY;
flash unsigned int BTN2_Y_End = BTN_StartY + BTN_Height;
flash unsigned int BTN2_X_Begin = BTN_StartX + BTN_Width + BTN_Between;
flash unsigned int BTN2_X_End = BTN_StartX + (BTN_Width * 2) + BTN_Between;

flash unsigned int BTN3_Y_Begin = BTN_StartY;
flash unsigned int BTN3_Y_End = BTN_StartY + BTN_Height;
flash unsigned int BTN3_X_Begin = BTN_StartX + (BTN_Width * 2) + (BTN_Between * 2);
flash unsigned int BTN3_X_End = BTN_StartX + (BTN_Width * 3) + (BTN_Between * 2);

flash unsigned int BTN4_Y_Begin = BTN_StartY;
flash unsigned int BTN4_Y_End = BTN_StartY + BTN_Height;
flash unsigned int BTN4_X_Begin = BTN_StartX + (BTN_Width * 3) + (BTN_Between * 3);
flash unsigned int BTN4_X_End = BTN_StartX + (BTN_Width * 4) + (BTN_Between * 3);

void Repaint_Button(unsigned char* String, char Number, unsigned int Color, unsigned int BackColor)
{
  switch(Number)
  {
    case 1 :
      SSD1963_PutString16("     ", BTN1_X_Begin + 10, BTN1_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
      SSD1963_PutString16(String, BTN1_X_Begin + 10, BTN1_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
    break;
    case 2 :
      SSD1963_PutString16("     ", BTN2_X_Begin + 10, BTN2_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
      SSD1963_PutString16(String, BTN2_X_Begin + 10, BTN2_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
    break;
    case 3 :
      SSD1963_PutString16("     ", BTN3_X_Begin + 10, BTN3_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
      SSD1963_PutString16(String, BTN3_X_Begin + 10, BTN3_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
    break;
    case 4 :
      SSD1963_PutString16("     ", BTN4_X_Begin + 10, BTN4_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
      SSD1963_PutString16(String, BTN4_X_Begin + 10, BTN4_Y_Begin + (BTN_Height / 2) - (FONT_HEIGHT / 2), Color, BackColor);
    break;
  }
}

void Prepare_Screen(void)
{
  // рисуем кнопки
  SSD1963_DrawFillRect(BTN1_X_Begin, BTN1_X_End, BTN1_Y_Begin, BTN1_Y_End, WHITE);
  SSD1963_DrawFillRect(BTN2_X_Begin, BTN2_X_End, BTN2_Y_Begin, BTN2_Y_End, WHITE);
  SSD1963_DrawFillRect(BTN3_X_Begin, BTN3_X_End, BTN3_Y_Begin, BTN3_Y_End, WHITE);
  SSD1963_DrawFillRect(BTN4_X_Begin, BTN4_X_End, BTN4_Y_Begin, BTN4_Y_End, WHITE);
  // рисуем окантовку
  SSD1963_DrawRect(BTN1_X_Begin + 1, BTN1_X_End - 1, BTN1_Y_Begin + 1, BTN1_Y_End - 1, 1, BLACK);
  SSD1963_DrawRect(BTN2_X_Begin + 1, BTN2_X_End - 1, BTN2_Y_Begin + 1, BTN2_Y_End - 1, 1, BLACK);
  SSD1963_DrawRect(BTN3_X_Begin + 1, BTN3_X_End - 1, BTN3_Y_Begin + 1, BTN3_Y_End - 1, 1, BLACK);
  SSD1963_DrawRect(BTN4_X_Begin + 1, BTN4_X_End - 1, BTN4_Y_Begin + 1, BTN4_Y_End - 1, 1, BLACK);

  Repaint_Button("МЕНЮ", 1, BLACK, WHITE);
  Repaint_Button("  +", 2, BLACK, WHITE);
  Repaint_Button("  -", 3, BLACK, WHITE);
  Repaint_Button("ПАУЗА", 4, BLACK, WHITE);
}

char GetButton(void)
{
  char res = 0;
  if (TSC2046_GetCoordinates())
  {
    if ((TOUCH_X > BTN1_X_Begin) && (TOUCH_X < BTN1_X_End)) // если X внутри заданного диапазона
    {
      if ((TOUCH_Y > BTN1_Y_Begin) && (TOUCH_Y < BTN1_Y_End)) res = 1;
    }
    if ((TOUCH_X > BTN2_X_Begin) && (TOUCH_X < BTN2_X_End)) // если X внутри заданного диапазона
    {
      if ((TOUCH_Y > BTN2_Y_Begin) && (TOUCH_Y < BTN2_Y_End)) res = 2;
    }
    if ((TOUCH_X > BTN3_X_Begin) && (TOUCH_X < BTN3_X_End)) // если X внутри заданного диапазона
    {
      if ((TOUCH_Y > BTN3_Y_Begin) && (TOUCH_Y < BTN3_Y_End)) res = 3;
    }
    if ((TOUCH_X > BTN4_X_Begin) && (TOUCH_X < BTN4_X_End)) // если X внутри заданного диапазона
    {
      if ((TOUCH_Y > BTN4_Y_Begin) && (TOUCH_Y < BTN4_Y_End)) res = 4;
    }

  }
  return res;
}


///////////////////////////////////////////////
char State=0, ParameterState=0, ValueState=0, GraphState=0, ConfigState=0;
unsigned int WaitADC_mSec = 0, ValueUpd_mSec = 0, GraphUpd_mSec = 0;

unsigned int GraphUpdTime = 0;
signed int Graph_X = -Graph_X_Step; 
signed int Amplitude[3] = {90, 90, 50}; 
signed int ValueLast[3] = {0,0,0};

//////////////////////////////////////////////

void PutParameterText(char Number, unsigned int Color)
{
  int X = Text_StartX; 
  int Y = Text_StartY;
 
  SSD1963_PutString16("                ", X, Y, Color, BLACK);
  SSD1963_PutString16("                ", X, Y + FONT_HEIGHT, Color, BLACK);
  switch (Number)
  {
    case 0 :
      SSD1963_PutString16("НАПРЯЖЕНИЕ", X, Y, Color, BLACK);
      SSD1963_PutString16("ФАЗ", X, Y + FONT_HEIGHT, Color, BLACK);
    break;
    case 1 :
      SSD1963_PutString16("ТОК", X, Y, Color, BLACK);
      SSD1963_PutString16("ФАЗ", X, Y + FONT_HEIGHT, Color, BLACK);
    break;
    case 2 :
      SSD1963_PutString16("НАПРЯЖЕНИЕ И ТОК", X, Y, Color, BLACK);
      SSD1963_PutString16("ВОЗБУЖДЕНИЯ", X, Y + FONT_HEIGHT, Color, BLACK);
    break;
    /*
    case 3 :
      SSD1963_PutString16("ВРЕМЯ ОБРАБОТКИ", X, Y, Color, BLACK);
      SSD1963_PutString16("СКОРОСТИ", X, Y + FONT_HEIGHT, Color, BLACK);
    break;
    case 4 :
      SSD1963_PutString16("СКОРОСТЬ ТПЧ", X, Y, Color, BLACK);
      SSD1963_PutString16("МАКСИМАЛЬНАЯ", X, Y + FONT_HEIGHT, Color, BLACK);
    break;
   */
   
    case 5:
      SSD1963_PutString16("ДИС", X, Y, Color, BLACK);
      SSD1963_PutString16("АМП", X, Y + FONT_HEIGHT, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(GraphUpdTime, X, Y, 4, Color, BLACK);  
      X += Value_Lenght + FONT_HEIGHT + FONT_HEIGHT;
      SSD1963_PutString16("ОВЕ", X, Y, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(rx_buffer_overflow0, X, Y, 1, Color, BLACK);
      
      X = Text_StartX + Value_Lenght;
      Y = Text_StartY + FONT_HEIGHT;
      SSD1963_PutValue16(Amplitude[0], X, Y, 3, Color, DGRAY);
      X += Value_Lenght; 
      SSD1963_PutValue16(Amplitude[1], X, Y, 3, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(Amplitude[2], X, Y, 3, Color, BLACK);
    break; 
    case 6:
      SSD1963_PutString16("ДИС", X, Y, Color, BLACK);
      SSD1963_PutString16("АМП", X, Y + FONT_HEIGHT, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(GraphUpdTime, X, Y, 4, Color, BLACK);  
      X += Value_Lenght + FONT_HEIGHT;
      SSD1963_PutString16("ОВЕ", X, Y, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(rx_buffer_overflow0, X, Y, 1, Color, BLACK);
      
      X = Text_StartX + Value_Lenght;
      Y = Text_StartY + FONT_HEIGHT;
      SSD1963_PutValue16(Amplitude[0], X, Y, 3, Color, BLACK);
      X += Value_Lenght; 
      SSD1963_PutValue16(Amplitude[1], X, Y, 3, Color, DGRAY);
      X += Value_Lenght;
      SSD1963_PutValue16(Amplitude[2], X, Y, 3, Color, BLACK);
    break;
    case 7:
      SSD1963_PutString16("ДИС", X, Y, Color, BLACK);
      SSD1963_PutString16("АМП", X, Y + FONT_HEIGHT, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(GraphUpdTime, X, Y, 4, Color, BLACK);  
      X += Value_Lenght + FONT_HEIGHT;
      SSD1963_PutString16("ОВЕ", X, Y, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(rx_buffer_overflow0, X, Y, 1, Color, BLACK);
      
      X = Text_StartX + Value_Lenght;
      Y = Text_StartY + FONT_HEIGHT;
      SSD1963_PutValue16(Amplitude[0], X, Y, 3, Color, BLACK);
      X += Value_Lenght; 
      SSD1963_PutValue16(Amplitude[1], X, Y, 3, Color, BLACK);
      X += Value_Lenght;
      SSD1963_PutValue16(Amplitude[2], X, Y, 3, Color, DGRAY);
    break;
    case 8:
      SSD1963_PutString16(" KU", X, Y, Color, BLACK);
      SSD1963_PutString16(" KI", X, Y + FONT_HEIGHT, Color, BLACK);
      X += Value_Lenght;
      //SSD1963_PutValue16(Amplitude[0], X, Y, 3, Color, BLACK);
      X += Value_Lenght; 
      //SSD1963_PutValue16(Amplitude[1], X, Y, 3, Color, BLACK);
      X += Value_Lenght;
      //SSD1963_PutValue16(Amplitude[2], X, Y, 3, Color, BLACK);
    break;
    case 14:
      SSD1963_PutString16("KUI", X, Y, Color, BLACK);
      SSD1963_PutString16("FastADC", X, Y + FONT_HEIGHT, Color, BLACK);
      X += Value_Lenght;
      //SSD1963_PutValue16(Amplitude[0], X, Y, 3, Color, BLACK);
      X += Value_Lenght; 
      //SSD1963_PutValue16(Amplitude[1], X, Y, 3, Color, BLACK);
      X += Value_Lenght;
      //SSD1963_PutValue16(Amplitude[2], X, Y, 3, Color, BLACK);
    break;
  }
}

//Функция вывода напряжения(тока) и частоты
void PutParameterValue(char v1, char v2, char v3, char fHz)
{
    int X = Value_StartX;  
    int Y = Value_StartY ;
    unsigned int Color = BLUE;
   
    SSD1963_PutString16("            ", X, Y, Color, BLACK);
    SSD1963_PutString16("            ", X, Y + FONT_HEIGHT, Color, BLACK); 
    
    if(ParameterState != 2) 
    {
        SSD1963_PutValue16(v1, X, Y, 3, Color, BLACK);
        X += Value_Lenght;
        SSD1963_PutValue16(v2, X, Y, 3, Color, BLACK);
        X += Value_Lenght;
        SSD1963_PutValue16(v3, X, Y, 3, Color, BLACK);
        X = Value_StartX + Value_Lenght; 
        Y += FONT_HEIGHT;
        SSD1963_PutValue16(fHz, X, Y, 3, Color, BLACK); 
        X += Value_Lenght; 
        SSD1963_PutString16("ГЦ", X, Y, Color, BLACK);
    }
    else
    {
        X += Value_Lenght;
        SSD1963_PutValue16(v1, X, Y, 3, Color, BLACK);
        Y += FONT_HEIGHT; 
        SSD1963_PutValue16(v2, X, Y, 3, Color, BLACK);
    }
}

void StartPaint()
{
    //Чтоб первая точка легла
    Graph_X = -Graph_X_Step;   
}

inline void Paint_Phase(void)
{
    signed int Value[3];
    unsigned int Color[] = {RED, YELLOW, GREEN}; 
    signed int Lenght = Graph_X + (Graph_X_Step * Graph_Step_N); 
    signed int mid = Graph_Y_Mid;
    char i, j;
    
    if(Graph_X > Graph_X_Max)  //Некуда дальше 
    {
        GraphUpdTime = GraphUpd_mSec; 
        while(rx_counter0) getchar0(); 
        GraphState = 0;
    }
    
    if( rx_counter0 < 2 || (rx_counter0 < 3 && ParameterState != 2))
    {
        if(GraphUpd_mSec > 100) 
        {  
            GraphUpdTime = GraphUpd_mSec; 
            while(rx_counter0) getchar0(); 
            GraphState = 0;
        }      
    }
    
    if(GraphState == 0) return;
    
    if(Lenght > Graph_X_Max) Lenght = Graph_X_Max;  
    
    if(Graph_X >= Graph_X_Min)
    {
        // очищаем перед собой столбец пикселей
        SSD1963_DrawFillRect(Graph_X, Lenght+2, Graph_Y_Min, Graph_Y_Max+1, BLACK);
        //Линия нуля 
        SSD1963_DrawFastLine(Graph_X, Lenght, mid, mid, DGRAY);
        SSD1963_DrawFastLine(Graph_X, Lenght, mid+45, mid+45, DGRAY);
        SSD1963_DrawFastLine(Graph_X, Lenght, mid-45, mid-45, DGRAY);
        SSD1963_DrawFastLine(Graph_X, Lenght, mid+90, mid+90, DGRAY);
        SSD1963_DrawFastLine(Graph_X, Lenght, mid-90, mid-90, DGRAY);
    }
    
    if(ParameterState != 2)
    {
        for(j=0; j<Graph_Step_N; j++)
        {
            if(Graph_X > Graph_X_Max) break;
            Lenght = Graph_X + Graph_X_Step; 
            if(Lenght > Graph_X_Max) Lenght = Graph_X_Max; 
            
            if(rx_counter0 < 3 || (TOUCH_IRQ < 1)) break; 
            
            Value[0] = getchar0();
            Value[1] = getchar0(); 
            Value[2] = getchar0();
            
            for(i=0; i<3; i++)
            {
                Value[i] = 128 - Value[i];
                Value[i] *= Amplitude[ParameterState];
                Value[i] >>= 7; 
                if(Value[i]&0x0100) Value[i] |= 0xFF00;
        
                Value[i] += mid;
                if(Value[i] > Graph_Y_Max) Value[i] = Graph_Y_Max;
                if(Value[i] < Graph_Y_Min) Value[i] = Graph_Y_Min;
                
                if(Graph_X >= Graph_X_Min)
                {   // пишем точку в столбце
                    SSD1963_DrawLine(Graph_X, Lenght, ValueLast[i], Value[i], Color[i], 2); 
                }
                    // определяем предыдущую точку диограммы  
                    ValueLast[i] = Value[i];
            }
            Graph_X += Graph_X_Step; // увеличеваем Х диограммы  
        } 
    }
    else
    {
        for(j=0; j<Graph_Step_N; j++)
        {
            if(Graph_X > Graph_X_Max) break;
            Lenght = Graph_X + Graph_X_Step; 
            if(Lenght > Graph_X_Max) Lenght = Graph_X_Max; 
            
            if(rx_counter0 < 2 || (TOUCH_IRQ < 1)) break;
            
            Value[0] = getchar0();
            Value[1] = getchar0(); 
            
            for(i=0; i<2; i++)
            {
                Value[i] = 128 - Value[i];
                Value[i] *= Amplitude[ParameterState];
                Value[i] >>= 7; 
                if(Value[i]&0x0100) Value[i] |= 0xFF00;
        
                Value[i] += mid + ((i==1)?(45):(-45));
                if(Value[i] > Graph_Y_Max) Value[i] = Graph_Y_Max;
                if(Value[i] < Graph_Y_Min) Value[i] = Graph_Y_Min;
                
                if(Graph_X >= Graph_X_Min)
                {   // пишем точку в столбце
                    SSD1963_DrawLine(Graph_X, Lenght, ValueLast[i], Value[i], Color[i], 2); 
                }
                    // определяем предыдущую точку диограммы  
                    ValueLast[i] = Value[i];
            }
            Graph_X += Graph_X_Step; // увеличеваем Х диограммы  
        } 
    }  
}

//Функция посылающаа управление куда подальше
void TestParameterFun(char a, char b, char c, char fHz)
{
    RS485 = 1; //Передача
    if(b > 110) printf("Напругу убавь \n");
    if(b < 90)  printf("Напруги прибавь \n");
    if(fHz < 50)printf("Поддай оборотов \n"); 
    if(fHz > 50)printf("Не гони, помедленнее \n"); 
}

inline void main_loop()  // основной рабочий режим
{
    char fHz, a, b, c;
    
            switch(ValueState)
            {
                case 0: 
                  if(ValueUpd_mSec > 400) //Надо обновить значения, но как?
                  {
                      if(ValueState < 2) 
                      {
                          putchar2('S');
                          ValueState = 1;
                          ValueUpd_mSec = 0; 
                      }
                  }
                  if(GraphState == 0 && State == 0 && ValueState == 0) //Надо обновить график
                  {
                      StartPaint();
                      while(rx_counter0) getchar0(); 
                      switch(ParameterState) 
                      {
                          case 0: putchar0('U'); break; 
                          case 1: putchar0('I'); break;
                          case 2: putchar0('Z'); break;
                      }
                      ValueState = 2;
                      GraphState = 1; 
                      GraphUpd_mSec = 0;    
                  }
                break;
                case 1:
                  if(rx_counter2 > 8)
                  { 
                      fHz = getchar2();
                      a = getchar2();
                      b = getchar2(); 
                      c = getchar2();
                      TestParameterFun(a, b, c, fHz);
                      
                      if(State == 0) //Надо обновить значения на дисплее
                      {
                        switch(ParameterState) 
                        { 
                          case 2:
                              {
                              getchar2();
                              getchar2();
                              getchar2();
                              }
                              a = getchar2();
                              b = getchar2();
                              PutParameterValue(a, b, c, fHz);
                          break;
                          case 1:
                              a = getchar2();
                              b = getchar2(); 
                              c = getchar2();
                          case 0:
                              PutParameterValue(a, b, c, fHz);
                          break; 
                        }
                      }
                      
                      while(rx_counter2) getchar2();  
                      ValueState = 0;  
                  }
                break;
                case 2:
                    if(GraphUpd_mSec > 200)
                    {
                        ValueState = 0;
                    }
                break;
            } 
            
            switch(State)
            {
                case 0: // основной рабочий режим
                { 
                      if(GraphState) Paint_Phase(); //Рисуем график
                
                      switch (GetButton())
                      {
                          case 1:  //Переключение графиков
                              if(++ParameterState > 2) ParameterState = 0;
                              PutParameterText(ParameterState, BLUE); 
                              delay_ms(100);
                          break;
                          case 2: 
                              if(Amplitude[ParameterState] < 200) 
                              {
                                  Amplitude[ParameterState] += 10;
                                  delay_ms(20);
                              }
                          break;
                          case 3 :
                              if(Amplitude[ParameterState] > 20) 
                              {
                                  Amplitude[ParameterState] -= 10;
                                  delay_ms(20);
                              }
                          break;
                          case 4 :  //Уходим в настройки
                              State = 5;
                              ConfigState = 0;
                              Repaint_Button("СТАРТ", 4, BLACK, WHITE);
                              PutParameterText(ConfigState + State, PURPLE);
                              delay_ms(200);
                          break;
                      }
                }
                break;
                case 5: // настройки
                {
                    switch (GetButton())
                    {
                        case 1:
                            if(++ConfigState > 2) ConfigState = 0;
                            PutParameterText(ConfigState + State, PURPLE);
                            delay_ms(100);
                        break;
                        case 2:
                             if(Amplitude[ConfigState] < 200) 
                              {
                                  Amplitude[ConfigState] += 10;
                                  PutParameterText(ConfigState + State, PURPLE);
                                  delay_ms(20);
                              }
                        break;
                        case 3:
                              if(Amplitude[ConfigState] > 20) 
                              {
                                  Amplitude[ConfigState] -= 10;
                                  PutParameterText(ConfigState + State, PURPLE);
                                  delay_ms(20);
                              }
                        break;
                        case 4:
                            State = 0;
                            Repaint_Button("ПАУЗА", 4, BLACK, WHITE);
                            PutParameterText(ParameterState, BLUE);
                            delay_ms(200);
                        break;
                    }
                }
                break;
                case 200 : // пауза
                //Sleep_mSec = 0;
                    switch (GetButton())
                    {
                        case 1:
                        break;
                        case 2:
                        break;
                        case 3:
                        break;
                        case 4:
                            State = 0;
                            Repaint_Button("ПАУЗА", 4, BLACK, WHITE);
                            delay_ms(250);
                        break;
                    }
          
                break;
                case 250 : // сп¤щий режим
                {
                    if (TSC2046_GetCoordinates() > 0)
                    {
                        State = 0;
                        BACKLIGHT = 0; //On
                    }
                }
                break;
            }      
}

// Timer 0 overflow interrupt 1 ms
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x06;
// Place your code here
WaitADC_mSec++;
ValueUpd_mSec++;
GraphUpd_mSec++;
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
// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out 
// State7=1 State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0 
PORTB=0x80;
DDRB=0x87;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x10;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=1 State3=T State2=T State1=T State0=T 
PORTE=0x10;
DDRE=0x10;  //PE4 - CD off  

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 250,000 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x04;
TCNT0=0x06;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 115200
UCSR0A=0x00;
UCSR0B=0xD8;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x08;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 9600
UCSR1A=0x00;
UCSR1B=0xD8;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2*250,000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x52;
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;
}
{
// Global enable interrupts
#asm("sei")

SSD1963_Init();
TSC2046_Init();
SSD1963_ClearScreen(BLACK);

  SSD1963_PutString16("ДЕСКОМ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) - FONT_HEIGHT, BLUE, BLACK);
  BACKLIGHT = 0; //On
  delay_ms(200);
  SSD1963_PutString16("ДЕСКОМ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2), RED, BLACK);
  delay_ms(200);
  SSD1963_PutString16("ДЕСКОМ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) + FONT_HEIGHT, GREEN, BLACK);
  delay_ms(200);
  SSD1963_PutString16("      ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) - FONT_HEIGHT, BLACK, BLACK);
  delay_ms(200);
  SSD1963_PutString16("      ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2), BLACK, BLACK);
  delay_ms(200);
  SSD1963_PutString16("      ", 240 - 3 * FONT_WIDTH, (272 / 2) - (FONT_HEIGHT / 2) + FONT_HEIGHT, BLACK, BLACK);

Prepare_Screen();

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
#asm("wdr")
//WDTCR=0x1F;
//WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
}

PutParameterText(ParameterState, BLUE);
while (1)
      {
      #asm("wdr") 
      main_loop();
      }
}
