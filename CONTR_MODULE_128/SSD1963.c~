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

// цвет определяется по системе RGB565
// у пульта лебёдчика идёт всё запутанно
// вместо 0bRRRRRGGGGGGBBBBB
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

/*flash char RotationByte[256] =
{
0b00000000, //0
0b10000000, //128
0b01000000, //64
0b11000000, //192
0b00100000, //32
0b10100000, //160
0b01100000, //96
0b11100000, //224
0b00010000, //16
0b10010000, //144
0b01010000, //80
0b11010000, //208
0b00110000, //48
0b10110000, //176
0b01110000, //112
0b11110000, //240
0b00001000, //8
0b10001000, //136
0b01001000, //72
0b11001000, //200
0b00101000, //40
0b10101000, //168
0b01101000, //104
0b11101000, //232
0b00011000, //24
0b10011000, //152
0b01011000, //88
0b11011000, //216
0b00111000, //56
0b10111000, //184
0b01111000, //120
0b11111000, //248
0b00000100, //4
0b10000100, //132
0b01000100, //68
0b11000100, //196
0b00100100, //36
0b10100100, //164
0b01100100, //100
0b11100100, //228
0b00010100, //20
0b10010100, //148
0b01010100, //84
0b11010100, //212
0b00110100, //52
0b10110100, //180
0b01110100, //116
0b11110100, //244
0b00001100, //12
0b10001100, //140
0b01001100, //76
0b11001100, //204
0b00101100, //44
0b10101100, //172
0b01101100, //108
0b11101100, //236
0b00011100, //28
0b10011100, //156
0b01011100, //92
0b11011100, //220
0b00111100, //60
0b10111100, //188
0b01111100, //124
0b11111100, //252
0b00000010, //2
0b10000010, //130
0b01000010, //66
0b11000010, //194
0b00100010, //34
0b10100010, //162
0b01100010, //98
0b11100010, //226
0b00010010, //18
0b10010010, //146
0b01010010, //82
0b11010010, //210
0b00110010, //50
0b10110010, //178
0b01110010, //114
0b11110010, //242
0b00001010, //10
0b10001010, //138
0b01001010, //74
0b11001010, //202
0b00101010, //42
0b10101010, //170
0b01101010, //106
0b11101010, //234
0b00011010, //26
0b10011010, //154
0b01011010, //90
0b11011010, //218
0b00111010, //58
0b10111010, //186
0b01111010, //122
0b11111010, //250
0b00000110, //6
0b10000110, //134
0b01000110, //70
0b11000110, //198
0b00100110, //38
0b10100110, //166
0b01100110, //102
0b11100110, //230
0b00010110, //22
0b10010110, //150
0b01010110, //86
0b11010110, //214
0b00110110, //54
0b10110110, //182
0b01110110, //118
0b11110110, //246
0b00001110, //14
0b10001110, //142
0b01001110, //78
0b11001110, //206
0b00101110, //46
0b10101110, //174
0b01101110, //110
0b11101110, //238
0b00011110, //30
0b10011110, //158
0b01011110, //94
0b11011110, //222
0b00111110, //62
0b10111110, //190
0b01111110, //126
0b11111110, //254
0b00000001, //1
0b10000001, //129
0b01000001, //65
0b11000001, //193
0b00100001, //33
0b10100001, //161
0b01100001, //97
0b11100001, //225
0b00010001, //17
0b10010001, //145
0b01010001, //81
0b11010001, //209
0b00110001, //49
0b10110001, //177
0b01110001, //113
0b11110001, //241
0b00001001, //9
0b10001001, //137
0b01001001, //73
0b11001001, //201
0b00101001, //41
0b10101001, //169
0b01101001, //105
0b11101001, //233
0b00011001, //25
0b10011001, //153
0b01011001, //89
0b11011001, //217
0b00111001, //57
0b10111001, //185
0b01111001, //121
0b11111001, //249
0b00000101, //5
0b10000101, //133
0b01000101, //69
0b11000101, //197
0b00100101, //37
0b10100101, //165
0b01100101, //101
0b11100101, //229
0b00010101, //21
0b10010101, //149
0b01010101, //85
0b11010101, //213
0b00110101, //53
0b10110101, //181
0b01110101, //117
0b11110101, //245
0b00001101, //13
0b10001101, //141
0b01001101, //77
0b11001101, //205
0b00101101, //45
0b10101101, //173
0b01101101, //109
0b11101101, //237
0b00011101, //29
0b10011101, //157
0b01011101, //93
0b11011101, //221
0b00111101, //61
0b10111101, //189
0b01111101, //125
0b11111101, //253
0b00000011, //3
0b10000011, //131
0b01000011, //67
0b11000011, //195
0b00100011, //35
0b10100011, //163
0b01100011, //99
0b11100011, //227
0b00010011, //19
0b10010011, //147
0b01010011, //83
0b11010011, //211
0b00110011, //51
0b10110011, //179
0b01110011, //115
0b11110011, //243
0b00001011, //11
0b10001011, //139
0b01001011, //75
0b11001011, //203
0b00101011, //43
0b10101011, //171
0b01101011, //107
0b11101011, //235
0b00011011, //27
0b10011011, //155
0b01011011, //91
0b11011011, //219
0b00111011, //59
0b10111011, //187
0b01111011, //123
0b11111011, //251
0b00000111, //7
0b10000111, //135
0b01000111, //71
0b11000111, //199
0b00100111, //39
0b10100111, //167
0b01100111, //103
0b11100111, //231
0b00010111, //23
0b10010111, //151
0b01010111, //87
0b11010111, //215
0b00110111, //55
0b10110111, //183
0b01110111, //119
0b11110111, //247
0b00001111, //15
0b10001111, //143
0b01001111, //79
0b11001111, //207
0b00101111, //47
0b10101111, //175
0b01101111, //111
0b11101111, //239
0b00011111, //31
0b10011111, //159
0b01011111, //95
0b11011111, //223
0b00111111, //63
0b10111111, //191
0b01111111, //127
0b11111111, //255 
};
*/
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

// Запись команды в SSD1963
inline void SSD1963_WriteCmd(unsigned char cmd)
{
  SSD1963_RD = 1;
  SSD1963_RS = 0;                                                  //запись команды   
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

// Запись данных в SSD1963
inline void SSD1963_WriteData_b8(unsigned char data)
{
  SSD1963_RD = 1;
  SSD1963_RS = 1;                                                  //запись ДАННЫХ  
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

// Запись данных в SSD1963
inline void SSD1963_WriteData_b16(unsigned int data)
{
  char a, b;
  a = data;
  b = data >> 8;
  SSD1963_RD = 1;
  SSD1963_RS = 1;                                                  //запись ДАННЫХ  
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

// Инициализация дисплея
void SSD1963_Init(void)
{
  SSD1963_Reset();
  // Soft reset  
  SSD1963_WriteCmd(0x01); //software reset
  SSD1963_WriteCmd(0x01); //software reset
  SSD1963_WriteCmd(0x01); //software reset
  delay_ms(200); //задержка

  SSD1963_WriteCmd(0xE2); //PLLmultiplier, set PLL clock to 120M
  SSD1963_WriteData_b8(0x23); // множительPLL(M)// N=0x36 for 6.5M, 0x23 for 10M crystal
  SSD1963_WriteData_b8(0x02); // делительPLL(N)
  SSD1963_WriteData_b8(0x04); // команда на использование умножителя и делителя PLL  
  /*SSD1963_WriteData_b8(0x23); // множительPLL(M)// N=0x36 for 6.5M, 0x23 for 10M crystal
  SSD1963_WriteData_b8(0x02); // делительPLL(N)
  SSD1963_WriteData_b8(0x04); // команда на использование умножителя и делителя PLL*/
  SSD1963_WriteCmd(0xE0); // запуск PLL
  SSD1963_WriteData_b8(0x01); // PLL включена и использовать внутренний генератор как системный
  delay_ms(1);//ожидание запуска PLL

  SSD1963_WriteCmd(0xE0); // Переключение системы с внутреннего генератора на PLL
  SSD1963_WriteData_b8(0x03);
  SSD1963_WriteCmd(0x01); //software reset
  delay_ms(120); //а здесь лучше сделать 120 вместо 5

  SSD1963_WriteCmd(0xE6); //Установка частоты переключения пикселя
  //PLL setting for PCLK, depends on resolution
  SSD1963_WriteData_b8(0x01); //5,3мГц = PLLfreqx ((частотапереключения+1)/2^20)
  SSD1963_WriteData_b8(0xDA); // для 100мГц должно быть 0х00D916
  SSD1963_WriteData_b8(0x73);
  
  SSD1963_WriteCmd(0xB0); //Set LCD mode
  SSD1963_WriteData_b8(0x24); //24bit
  SSD1963_WriteData_b8(0x00); //0x0000 и 20 - TFT режим, 40 serial RGB режим
  SSD1963_WriteData_b8((HDP>>8)&0xFF); //Разрешение по горизонтали //SetHDP
  SSD1963_WriteData_b8(HDP&0xFF);
  SSD1963_WriteData_b8((VDP>>8)&0xFF); // Разрешение по вертикали //SetVDP
  SSD1963_WriteData_b8(VDP&0xFF);
  SSD1963_WriteData_b8(0x00); // а здесь попробуй поставить 0х2D и тогда не надо мучать 36 регистр
  //00101101-G[5..3]=101
  //G[2..0]=101-BGR

  //В4 и В6 частота обновления по горизонтали и вертикали (этовкратце)
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

  //ВА и В8 конфигурация портов между SSD1963 и дисплеем
  SSD1963_WriteCmd(0xBA);
  SSD1963_WriteData_b8(0x0F); //GPIO[3:0]out1
  SSD1963_WriteCmd(0xB8);
  SSD1963_WriteData_b8(0x07); //0x07 GPIO3 = input, GPIO[2:0] = output
  SSD1963_WriteData_b8(0x01); //0x01 GPIO0 normal
  
  SSD1963_WriteCmd(0x36); //Set Address mode - rotation
  SSD1963_WriteData_b8(flipState); //бит0 - flipvertical бит1 - fliphorizontal
  
  SSD1963_WriteCmd(0xBC); //настройка яркости и тд
  SSD1963_WriteData_b8(0x50); //контраст
  SSD1963_WriteData_b8(0x90); //яркость
  SSD1963_WriteData_b8(0x50); //насыщеность цвета
  SSD1963_WriteData_b8(0x01); //постпроцессор (1 - вкл параметры, 0 - выкл)

  SSD1963_WriteCmd(0xF0); //pixel data interface
  SSD1963_WriteData_b8(0x03); //03h - RGB565
  
  delay_ms(5);

  SSD1963_WriteCmd(0x29); //display on

  SSD1963_WriteCmd(0xD0); //отключено ручное управление яркостью //Dynamic Bright Control
  SSD1963_WriteData_b8(0x0D); //режим энергосбережения - агрессивный
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

    case 'А' : SSD1963_PrintSymbol16(S_192, X, Y, Color, BackColor);
    break;
    case 'Б' : SSD1963_PrintSymbol16(S_193, X, Y, Color, BackColor);
    break;
    case 'В' : SSD1963_PrintSymbol16(S_194, X, Y, Color, BackColor);
    break;
    case 'Г' : SSD1963_PrintSymbol16(S_195, X, Y, Color, BackColor);
    break;
    case 'Д' : SSD1963_PrintSymbol16(S_196, X, Y, Color, BackColor);
    break;
    case 'Е' : SSD1963_PrintSymbol16(S_197, X, Y, Color, BackColor);
    break;
    case 'Ж' : SSD1963_PrintSymbol16(S_198, X, Y, Color, BackColor);
    break;
    case 'З' : SSD1963_PrintSymbol16(S_199, X, Y, Color, BackColor);
    break;
    case 'И' : SSD1963_PrintSymbol16(S_200, X, Y, Color, BackColor);
    break;
    case 'Й' : SSD1963_PrintSymbol16(S_201, X, Y, Color, BackColor);
    break;
    case 'К' : SSD1963_PrintSymbol16(S_202, X, Y, Color, BackColor);
    break;
    case 'Л' : SSD1963_PrintSymbol16(S_203, X, Y, Color, BackColor);
    break;
    case 'М' : SSD1963_PrintSymbol16(S_204, X, Y, Color, BackColor);
    break;
    case 'Н' : SSD1963_PrintSymbol16(S_205, X, Y, Color, BackColor);
    break;
    case 'О' : SSD1963_PrintSymbol16(S_206, X, Y, Color, BackColor);
    break;
    case 'П' : SSD1963_PrintSymbol16(S_207, X, Y, Color, BackColor);
    break;
    case 'Р' : SSD1963_PrintSymbol16(S_208, X, Y, Color, BackColor);
    break;
    case 'С' : SSD1963_PrintSymbol16(S_209, X, Y, Color, BackColor);
    break;
    case 'Т' : SSD1963_PrintSymbol16(S_210, X, Y, Color, BackColor);
    break;
    case 'У' : SSD1963_PrintSymbol16(S_211, X, Y, Color, BackColor);
    break;
    case 'Ф' : SSD1963_PrintSymbol16(S_212, X, Y, Color, BackColor);
    break;
    case 'Х' : SSD1963_PrintSymbol16(S_213, X, Y, Color, BackColor);
    break;
    case 'Ц' : SSD1963_PrintSymbol16(S_214, X, Y, Color, BackColor);
    break;
    case 'Ч' : SSD1963_PrintSymbol16(S_215, X, Y, Color, BackColor);
    break;
    case 'Ш' : SSD1963_PrintSymbol16(S_216, X, Y, Color, BackColor);
    break;
    case 'Щ' : SSD1963_PrintSymbol16(S_217, X, Y, Color, BackColor);
    break;
    case 'Ъ' : SSD1963_PrintSymbol16(S_218, X, Y, Color, BackColor);
    break;
    case 'Ы' : SSD1963_PrintSymbol16(S_219, X, Y, Color, BackColor);
    break;
    case 'Ь' : SSD1963_PrintSymbol16(S_220, X, Y, Color, BackColor);
    break;
    case 'Э' : SSD1963_PrintSymbol16(S_221, X, Y, Color, BackColor);
    break;
    case 'Ю' : SSD1963_PrintSymbol16(S_222, X, Y, Color, BackColor);
    break;
    case 'Я' : SSD1963_PrintSymbol16(S_223, X, Y, Color, BackColor);
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
  switch(N)
  {
    case 5 :
      SSD1963_PutChar16(Value / 10000 + 48, X, Y, Color, BackColor);
      Value %= 10000;
      X += FONT_WIDTH;
    case 4 :                                                      
      SSD1963_PutChar16(Value / 1000 + 48, X, Y, Color, BackColor);
      Value %= 1000;
      X += FONT_WIDTH;
    case 3 :
      SSD1963_PutChar16(Value / 100 + 48, X, Y, Color, BackColor);
      Value %= 100;
      X += FONT_WIDTH;
    case 2 :
      SSD1963_PutChar16(Value / 10 + 48, X, Y, Color, BackColor);
      Value %= 10;
      X += FONT_WIDTH;
    case 1 :
      SSD1963_PutChar16(Value + 48, X, Y, Color, BackColor);
    break;
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
           