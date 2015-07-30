#include <spi.h>
#include <delay.h>

#define TOUCH_CS PORTE.2
#define TOUCH_IRQ_PORT PORTE.3
#define TOUCH_IRQ PINE.3

#define ADC_X_MIN 1300
#define ADC_Y_MIN 2100 
#define ADC_X_K 61.458333333333333333333333333333
#define ADC_Y_K 103.30882352941176470588235294118

#define TOUCH_Calc_Max 16

void TSC2046_PortInit(void)
{
  DDRE |= 0b00000100; 
  DDRE &= 0b11110111;
}

#pragma used+

long tempX, tempY;
unsigned int TOUCH_X, TOUCH_Y, TOUCH_X_LAST, TOUCH_Y_LAST;

unsigned int TSC2046_getADC_Bat(void)
{
  unsigned int res;
  TOUCH_CS = 0;
  delay_ms(1);
  spi(0b10100011);
  delay_us(100);
  res = spi(0x00);
  res = res << 8;
  res += spi(0x00);
  //res = res >> 3;
  TOUCH_CS = 1;
  return res;    
}

unsigned int TSC2046_getADC_X(void)
{
  unsigned int res;
  TOUCH_CS = 0;
  delay_ms(1);
  spi(0b11010011);
  delay_us(100);
  res = spi(0x00);
  res = res << 8;
  res += spi(0x00);
  //res = res >> 3;
  TOUCH_CS = 1;
  return res;    
}

unsigned int TSC2046_getADC_Y(void)
{
  unsigned int res;
  TOUCH_CS = 0;
  delay_ms(1);
  spi(0b10010011);
  delay_us(100);
  res = spi(0x00);
  res = res << 8;
  res += spi(0x00);
  //res = res >> 3;
  TOUCH_CS = 1;
  return res;    
}

void TSC2046_Stop()
{  
  TOUCH_CS = 0;
  delay_ms(5);
  spi(0b10010000);
  delay_us(100);
  spi(0x00);  
  spi(0x00);
  TOUCH_CS = 1;
}

unsigned int TSC2046_getX(void)
{
  signed int res;
  res = TSC2046_getADC_X() - ADC_X_MIN;
  if (res < 0) res = 0;
  res = res / ADC_X_K;  
  return res;
}

unsigned int TSC2046_getY(void)
{
  signed int res;
  res = TSC2046_getADC_Y() - ADC_Y_MIN;
  if (res < 0) res = 0;
  res = res / ADC_Y_K;  
  return res;
}

char TSC2046_GetCoordinates(void)
{
  char res = 0, i;
  //TOUCH_CS = 0;
  //TOUCH_IRQ_PORT = 0;
  //delay_us(10);
  //TOUCH_IRQ_PORT = 1;
  //TOUCH_CS = 1;
  if (TOUCH_IRQ < 1)
  {
    tempX = 0;
    tempY = 0;
    for (i = 0; i < TOUCH_Calc_Max; i++)
    {
      tempX += TSC2046_getADC_X();
      tempY += TSC2046_getADC_Y();      
    }
    tempX -= ADC_X_MIN * TOUCH_Calc_Max;  
    tempY -= ADC_Y_MIN * TOUCH_Calc_Max;
    if(tempX < 0) tempX = 0; 
    if(tempY < 0) tempY = 0;
    
    TOUCH_X = tempX / (TOUCH_Calc_Max * ADC_X_K);
    TOUCH_Y = tempY / (TOUCH_Calc_Max * ADC_Y_K); 
    
    TSC2046_Stop(); 
    res = 1;
  }
  //TOUCH_IRQ_PORT = 0;
  return res;
}

void TSC2046_Init(void)
{
  TSC2046_PortInit();
  TOUCH_CS = 0;
  TOUCH_IRQ_PORT = 0;   
  delay_us(10);
  TOUCH_CS = 1;
  TOUCH_IRQ_PORT = 1;
  tempX = 0;
  tempY = 0;

    TOUCH_X = TSC2046_getX();
    TOUCH_Y = TSC2046_getY(); 
    TSC2046_Stop();    
}

#pragma used-
