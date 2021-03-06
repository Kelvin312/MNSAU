#define flipState       0x03
#define DISP_WIDTH      480
#define DISP_HEIGHT     272

#define HDP    (DISP_WIDTH - 1)
#define HT     900                       
#define HPS    90                       
#define LPS    8             
#define HPW    10

#define VDP    (DISP_HEIGHT - 1)
#define VT     300
#define VPS    12                                             
#define FPS    4
#define VPW    10

#define SSD1963_SET_COLUMN_ADDRESS 0x2A
#define SSD1963_SET_PAGE_ADDRESS 0x2B

// ���� ������������ �� ������� RGB565
// � ������ �������� ��� �� ���������
// ������ 0bRRRRRGGGGGGBBBBB
// 0bGGGRRRRRBBBBBGGG

// 0bRRRRR GGGGGG BBBBB
// 0b01111 011111 01111

// 0bGGGRRRRRBBBBBGGG
// 0b0010000100001000
#define   BLACK        0x0000
#define   NAVY         0b111100000000000
#define   DGREEN       0x03E0
#define   DCYAN        0x03EF                       
#define   MAROON       0x7800
#define   PURPLE       0x780F
#define   OLIVE        0x7BE0
#define   GREY         0xF7DE
#define   LGRAY        0xC618
#define   DGRAY        0b0010000100001000
#define   BLUE         0b0000000011111000
#define   GREEN        0b1110000000000111
#define   CYAN         0x07FF
#define   RED          0b0001111100000000
#define   MAGENTA      0xF81F
#define   YELLOW       0b1111111100000111
#define   WHITE        0xFFFF

#define  SSD1963_RS     PORTD.7
#define  SSD1963_WR     PORTD.6
#define  SSD1963_RD     PORTD.5
#define  SSD1963_CS     PORTE.7
#define  SSD1963_RESET  PORTE.5
#define  SSD1963_PORT1  PORTA
#define  SSD1963_PORT2  PORTC

#define  BACKGROUND_COLOR 0x0000
#define  FONT_WIDTH 16
#define  FONT_HEIGHT 16

void SSD1963_PortInit(void)
{
    //SSD1963_PORT
    DDRA = 0xFF;
    DDRC = 0xFF;
    //SSD1963 76543210
    DDRD |= 0b11100000;
    DDRE |= 0b10100000;
}

#pragma used+

unsigned char RotateByte(unsigned char Value)
{
  //Value = RotationByte[Value];
  Value = ((Value >> 1) & 0x55) | ((Value << 1) & 0xaa);
  Value = ((Value >> 2) & 0x33) | ((Value << 2) & 0xcc);
  Value = ((Value >> 4) & 0x0f) | ((Value << 4) & 0xf0);
  return Value;
}

void SSD1963_Reset(void)
{
  SSD1963_RD = 0;  
  SSD1963_RESET = 1;
  delay_ms(100);
  SSD1963_RESET = 0;
  delay_ms(100);
  SSD1963_RESET = 1;
  SSD1963_RD = 1;
  delay_ms(100);
}

// ������ ������� � SSD1963
inline void SSD1963_WriteCmd(unsigned char cmd)
{
  SSD1963_RD = 1;
  SSD1963_RS = 0;                                                  //������ �������   
  SSD1963_PORT1 = RotateByte(cmd);  
  SSD1963_PORT2 = 0x00; 
  #asm("nop")
  //delay_us(5);  
  SSD1963_CS = 0;
  SSD1963_WR = 0;  
  #asm("nop")
  //delay_us(5);  
  SSD1963_CS = 1;
  SSD1963_WR = 1;
  #asm("nop")
} // SSD1963_WriteCmd

// ������ ������ � SSD1963
inline void SSD1963_WriteData_b8(unsigned char data)
{
  SSD1963_RD = 1;
  SSD1963_RS = 1;                                                  //������ ������  
  SSD1963_PORT1 = RotateByte(data); 
  SSD1963_PORT2 = 0x00;
  #asm("nop")
  //delay_us(5);
  SSD1963_CS = 0;
  SSD1963_WR = 0;  
  #asm("nop")
  //delay_us(5);  
  SSD1963_CS = 1;
  SSD1963_WR = 1;
  #asm("nop")
} // SSD1963_Writedata

// ������ ������ � SSD1963
inline void SSD1963_WriteData_b16(unsigned int data)
{
  char a, b;
  a = data;
  b = data >> 8;
  SSD1963_RD = 1;
  SSD1963_RS = 1;                                                  //������ ������  
  SSD1963_PORT1 = a; 
  SSD1963_PORT2 = b;
  #asm("nop")
  //delay_us(5);  
  SSD1963_CS = 0;
  SSD1963_WR = 0;  
  #asm("nop")
  //delay_us(5);  
  SSD1963_CS = 1;
  SSD1963_WR = 1;
  #asm("nop")
} // SSD1963_Writedata

// ������������� �������
void SSD1963_Init(void)
{
  SSD1963_PortInit();
  SSD1963_Reset();
  // Soft reset  
  SSD1963_WriteCmd(0x01); //software reset
  SSD1963_WriteCmd(0x01); //software reset
  SSD1963_WriteCmd(0x01); //software reset
  delay_ms(200); //��������

  SSD1963_WriteCmd(0xE2); //PLLmultiplier, set PLL clock to 120M
  SSD1963_WriteData_b8(0x23); // ���������PLL(M)// N=0x36 for 6.5M, 0x23 for 10M crystal
  SSD1963_WriteData_b8(0x02); // ��������PLL(N)
  SSD1963_WriteData_b8(0x04); // ������� �� ������������� ���������� � �������� PLL  
  /*SSD1963_WriteData_b8(0x23); // ���������PLL(M)// N=0x36 for 6.5M, 0x23 for 10M crystal
  SSD1963_WriteData_b8(0x02); // ��������PLL(N)
  SSD1963_WriteData_b8(0x04); // ������� �� ������������� ���������� � �������� PLL*/
  SSD1963_WriteCmd(0xE0); // ������ PLL
  SSD1963_WriteData_b8(0x01); // PLL �������� � ������������ ���������� ��������� ��� ���������
  delay_ms(1);//�������� ������� PLL

  SSD1963_WriteCmd(0xE0); // ������������ ������� � ����������� ���������� �� PLL
  SSD1963_WriteData_b8(0x03);
  SSD1963_WriteCmd(0x01); //software reset
  delay_ms(120); //� ����� ����� ������� 120 ������ 5

  SSD1963_WriteCmd(0xE6); //��������� ������� ������������ �������
  //PLL setting for PCLK, depends on resolution
  SSD1963_WriteData_b8(0x01); //5,3��� = PLLfreqx ((�������������������+1)/2^20)
  SSD1963_WriteData_b8(0xDA); // ��� 100��� ������ ���� 0�00D916
  SSD1963_WriteData_b8(0x73);
  
  SSD1963_WriteCmd(0xB0); //Set LCD mode
  SSD1963_WriteData_b8(0x24); //24bit
  SSD1963_WriteData_b8(0x00); //0x0000 � 20 - TFT �����, 40 serial RGB �����
  SSD1963_WriteData_b8((HDP>>8)&0xFF); //���������� �� ����������� //SetHDP
  SSD1963_WriteData_b8(HDP&0xFF);
  SSD1963_WriteData_b8((VDP>>8)&0xFF); // ���������� �� ��������� //SetVDP
  SSD1963_WriteData_b8(VDP&0xFF);
  SSD1963_WriteData_b8(0x00); // � ����� �������� ��������� 0�2D � ����� �� ���� ������ 36 �������
  //00101101-G[5..3]=101
  //G[2..0]=101-BGR

  //�4 � �6 ������� ���������� �� ����������� � ��������� (����������)
  SSD1963_WriteCmd(0xB4); //Sethorizontalperiod
  SSD1963_WriteData_b8((HT>>8)&0xFF); //SetHT
  SSD1963_WriteData_b8(HT&0xFF);
  SSD1963_WriteData_b8((HPS>>8)&0XFF); //SetHPS
  SSD1963_WriteData_b8(HPS&0xFF);
  SSD1963_WriteData_b8(HPW); //SetHPW
  SSD1963_WriteData_b8((LPS>>8)&0XFF); //SetHPS
  SSD1963_WriteData_b8(LPS&0XFF);
  SSD1963_WriteData_b8(0x00);  

  SSD1963_WriteCmd(0xB6); //Set vertical period
  SSD1963_WriteData_b8((VT>>8)&0xFF); //SetVT
  SSD1963_WriteData_b8(VT&0xFF);
  SSD1963_WriteData_b8((VPS>>8)&0xFF); //SetVPS
  SSD1963_WriteData_b8(VPS&0xFF);
  SSD1963_WriteData_b8(VPW); //SetVPW
  SSD1963_WriteData_b8((FPS>>8)&0xFF); //SetFPS
  SSD1963_WriteData_b8(FPS&0xFF);     

  //�� � �8 ������������ ������ ����� SSD1963 � ��������
  SSD1963_WriteCmd(0xBA);
  SSD1963_WriteData_b8(0x0F); //GPIO[3:0]out1
  SSD1963_WriteCmd(0xB8);
  SSD1963_WriteData_b8(0x07); //0x07 GPIO3 = input, GPIO[2:0] = output
  SSD1963_WriteData_b8(0x01); //0x01 GPIO0 normal
  
  SSD1963_WriteCmd(0x36); //Set Address mode - rotation
  SSD1963_WriteData_b8(flipState); //���0 - flipvertical ���1 - fliphorizontal
  
  SSD1963_WriteCmd(0xBC); //��������� ������� � ��
  SSD1963_WriteData_b8(0x50); //��������
  SSD1963_WriteData_b8(0x90); //�������
  SSD1963_WriteData_b8(0x50); //����������� �����
  SSD1963_WriteData_b8(0x01); //������������� (1 - ��� ���������, 0 - ����)

  SSD1963_WriteCmd(0xF0); //pixel data interface
  SSD1963_WriteData_b8(0x03); //03h - RGB565
  
  delay_ms(5);

  SSD1963_WriteCmd(0x29); //display on

  SSD1963_WriteCmd(0xD0); //��������� ������ ���������� �������� //Dynamic Bright Control
  SSD1963_WriteData_b8(0x0D); //����� ���������������� - �����������
} // SSD1963_Init

void SSD1963_SetArea(unsigned int StartX, unsigned int EndX, unsigned int StartY, unsigned int EndY)
{
  SSD1963_WriteCmd(SSD1963_SET_COLUMN_ADDRESS);  
  SSD1963_WriteData_b8(StartX >> 8);
  SSD1963_WriteData_b8(StartX);
  SSD1963_WriteData_b8((EndX >> 8));
  SSD1963_WriteData_b8(EndX);

  SSD1963_WriteCmd(SSD1963_SET_PAGE_ADDRESS);  
  SSD1963_WriteData_b8((StartY >> 8));
  SSD1963_WriteData_b8(StartY);
  SSD1963_WriteData_b8((EndY >> 8));
  SSD1963_WriteData_b8(EndY);
}

void SSD1963_ClearScreen(unsigned int color)           
{
  unsigned int x,y;
  SSD1963_WriteCmd(0x28);
  SSD1963_SetArea(0, HDP , 0, VDP);
  SSD1963_WriteCmd(0x2c);
  x=0;
  while(x <= VDP)   
  {
    y=0;
    while(y <= HDP)   
    {
      SSD1963_WriteData_b16(color);        
      y++;
    }
  x++;
  }
  SSD1963_WriteCmd(0x29);
}                                                                                          

void SSD1963_PrintSymbol16(flash char Symb[32], unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
{
  char i, j;
  SSD1963_SetArea(X, X + FONT_WIDTH - 1, Y, Y + FONT_HEIGHT - 1);
  SSD1963_WriteCmd(0x2c);
  for (i = 0; i < 32; i++)
  {
    for (j = 0; j < 8; j++)    
    {
      if ((Symb[i] & (0b10000000 >> j)) > 0) SSD1963_WriteData_b16(Color);
      else SSD1963_WriteData_b16(BackColor);
    }
  }         
}
                                                           
void SSD1963_PutChar16(char Value, unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
{
  switch(Value)
  {
    case '0' : SSD1963_PrintSymbol16(S_48, X, Y, Color, BackColor);
    break;
    case '1' : SSD1963_PrintSymbol16(S_49, X, Y, Color, BackColor);
    break;
    case '2' : SSD1963_PrintSymbol16(S_50, X, Y, Color, BackColor);
    break;
    case '3' : SSD1963_PrintSymbol16(S_51, X, Y, Color, BackColor);
    break;
    case '4' : SSD1963_PrintSymbol16(S_52, X, Y, Color, BackColor);
    break;
    case '5' : SSD1963_PrintSymbol16(S_53, X, Y, Color, BackColor);
    break;
    case '6' : SSD1963_PrintSymbol16(S_54, X, Y, Color, BackColor);
    break;
    case '7' : SSD1963_PrintSymbol16(S_55, X, Y, Color, BackColor);
    break;
    case '8' : SSD1963_PrintSymbol16(S_56, X, Y, Color, BackColor);
    break;
    case '9' : SSD1963_PrintSymbol16(S_57, X, Y, Color, BackColor);
    break;

    case '!' : SSD1963_PrintSymbol16(S_33, X, Y, Color, BackColor);
    break;
    case '(' : SSD1963_PrintSymbol16(S_40, X, Y, Color, BackColor);
    break;
    case ')' : SSD1963_PrintSymbol16(S_41, X, Y, Color, BackColor);
    break;
    case '/' : SSD1963_PrintSymbol16(S_47, X, Y, Color, BackColor);
    break;
    case ':' : SSD1963_PrintSymbol16(S_58, X, Y, Color, BackColor);
    break;
    case '<' : SSD1963_PrintSymbol16(S_60, X, Y, Color, BackColor);
    break;
    case '=' : SSD1963_PrintSymbol16(S_61, X, Y, Color, BackColor);
    break;
    case '>' : SSD1963_PrintSymbol16(S_62, X, Y, Color, BackColor);
    break;
    case '?' : SSD1963_PrintSymbol16(S_63, X, Y, Color, BackColor);
    break;
    case '+' : SSD1963_PrintSymbol16(S_43, X, Y, Color, BackColor);
    break;
    case '-' : SSD1963_PrintSymbol16(S_45, X, Y, Color, BackColor);
    break;

    case '�' : SSD1963_PrintSymbol16(S_192, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_193, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_194, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_195, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_196, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_197, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_198, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_199, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_200, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_201, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_202, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_203, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_204, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_205, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_206, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_207, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_208, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_209, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_210, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_211, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_212, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_213, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_214, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_215, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_216, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_217, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_218, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_219, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_220, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_221, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_222, X, Y, Color, BackColor);
    break;
    case '�' : SSD1963_PrintSymbol16(S_223, X, Y, Color, BackColor);
    break;

    case '.' : SSD1963_PrintSymbol16(S_46, X, Y, Color, BackColor);
    break;
    case ' ' : SSD1963_PrintSymbol16(S_32, X, Y, Color, BackColor);
    break;
    case 1 : SSD1963_PrintSymbol16(S_UP, X, Y, Color, BackColor);
    break;
    case 2 : SSD1963_PrintSymbol16(S_DOWN, X, Y, Color, BackColor);
    break;
    case 3 : SSD1963_PrintSymbol16(blank_symb, X, Y, Color, BackColor);
    break;
  }
}
                                  
void SSD1963_PutString16(unsigned char* string, unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
{
  while (*string) {SSD1963_PutChar16(*string++, X, Y, Color, BackColor); X += FONT_WIDTH;}
}

void SSD1963_PutValue16(unsigned int Value, unsigned int X, unsigned int Y, char N, unsigned int Color, unsigned int BackColor)
{
  char strVal[5] = {'0', '0', ' ', ' ', ' '}; 
  char i=0; 
  while(Value)
  {
      strVal[i] = (Value%10) + 48;
      Value /= 10;
      i++;
  }
  
  while(N)
  {
      --N;
      SSD1963_PutChar16(strVal[N], X, Y, Color, BackColor);
      X += FONT_WIDTH;
  }
}

void SSD1963_DrawFastLine(unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Color)
{
  signed int j;
  long i, k;
  SSD1963_SetArea(StartX, StopX, StartY, StopY);
  SSD1963_WriteCmd(0x2c);
  j = StopX - StartX + 1;
  if (j < 0) j *= -1;
  k = StopY - StartY + 1;
  if (k < 0) k *= -1;
  k = k * j;
  for (i = 0; i < k; i++) SSD1963_WriteData_b16(Color);
}

void SSD1963_DrawLine (unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Color, char Width)
{
	int i, k;
  int deltaX, deltaY, signX, signY, error, error2; 
  deltaX = (StopX - StartX);
  if (deltaX < 0) deltaX *= -1;
	deltaY = (StopY - StartY);            
  if (deltaY < 0) deltaY *= -1;
	signX = StartX < StopX ? 1 : -1;
	signY = StartY < StopY ? 1 : -1;
	error = deltaX - deltaY;
	
	while(1)
	{
	  SSD1963_SetArea(StartX, StartX + Width, StartY, StartY + Width);
    SSD1963_WriteCmd(0x2c);   
    k = Width * Width;
    for (i = 0; i <= k; i++) SSD1963_WriteData_b16(Color);    
		                              
		if(StartX == StopX && StartY == StopY)
		break;
		
		error2 = error * 2;
		
		if(error2 > -deltaY)
		{
			error -= deltaY;
			StartX += signX;
		}
		
		if(error2 < deltaX)
		{
			error += deltaX;
			StartY += signY;
		}
	}
}

void SSD1963_DrawRect(unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Width, unsigned int Color)
{
  SSD1963_DrawFastLine(StartX, StopX, StartY, StartY + Width, Color);
  SSD1963_DrawFastLine(StartX, StartX + Width, StartY, StopY, Color);  
  SSD1963_DrawFastLine(StartX, StopX, StopY - Width, StopY, Color);
  SSD1963_DrawFastLine(StopX - Width, StopX, StartY, StopY, Color);  
}

void SSD1963_DrawFillRect(unsigned int StartX, unsigned int StopX, unsigned int StartY, unsigned int StopY, unsigned int Color)
{
  signed int j; 
  long i, k;
  SSD1963_SetArea(StartX, StopX, StartY, StopY);
  SSD1963_WriteCmd(0x2c);
  j = StopX - StartX + 1;
  if (j < 0) j *= -1;
  k = StopY - StartY + 1;
  if (k < 0) k *= -1;
  k = k * j;
  for (i = 0; i < k; i++) SSD1963_WriteData_b16(Color);
}

void SSD1963_PutFloatValue16(unsigned int Value, unsigned int X, unsigned int Y, unsigned int Color, unsigned int BackColor)
{
  SSD1963_PutChar16(Value / 10000 + 48, X, Y, Color, BackColor);
  Value %= 10000;
  X += FONT_WIDTH;
  SSD1963_PutChar16(Value / 1000 + 48, X, Y, Color, BackColor);
  Value %= 1000;
  X += FONT_WIDTH;
  SSD1963_PutChar16('.', X, Y, Color, BackColor);
  X += FONT_WIDTH;
  SSD1963_PutChar16(Value / 100 + 48, X, Y, Color, BackColor);
  Value %= 100;
  X += FONT_WIDTH;
  SSD1963_PutChar16(Value / 10 + 48, X, Y, Color, BackColor);
  Value %= 10;
  X += FONT_WIDTH;
  SSD1963_PutChar16(Value + 48, X, Y, Color, BackColor);
}

#pragma used-
           