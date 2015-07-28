/*
  CodeVisionAVR C Compiler
  (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.

  Prototypes for the Philips PCF8583 I2C
  bus Real Time Clock functions

  BEFORE #include -ING THIS FILE YOU
  MUST DECLARE THE I/O ADDRESS OF THE
  DATA REGISTER OF THE PORT AT WHICH
  THE I2C BUS IS CONNECTED AND
  THE DATA BITS USED FOR SDA & SCL

  EXAMPLE FOR PORTB:

    #asm
        .equ __i2c_port=0x18
        .equ __sda_bit=3
        .equ __scl_bit=4
    #endasm
    #include <pcf8583.h>
*/

#ifndef _PCF8583_INCLUDED_
#define _PCF8583_INCLUDED_

#include <i2c.h>   
#include <bcd.h>   
#include "PCF8583.c"

#pragma used+

unsigned char rtc_read(unsigned char chip,unsigned char address);
void rtc_write(unsigned char chip, unsigned char address,unsigned char data);
unsigned char rtc_get_status(unsigned char chip);
void rtc_init(unsigned char chip,unsigned char dated_alarm);
void rtc_get_time(unsigned char chip,unsigned char *hour,unsigned char *min,
unsigned char *sec,unsigned char *hsec);
void rtc_set_time(unsigned char chip,unsigned char hour,unsigned char min,
unsigned char sec,unsigned char hsec);
void rtc_get_date(unsigned char chip,unsigned char *date,unsigned char *month,
unsigned *year);
void rtc_set_date(unsigned char chip,unsigned char date,unsigned char month,
unsigned year);

#endif