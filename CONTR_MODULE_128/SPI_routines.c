//**************************************************
// ***** SOURCE FILE : SPI_routines.c ******
//**************************************************
#include "SPI_routines.h"

unsigned char SPI_transmit(unsigned char data)
{
// Start transmission
SPDR = data;

// Wait for transmission complete
while(!(SPSR & (1<<SPIF)));
  data = SPDR;

return(data);
}

unsigned char SPI_receive(void)
{
unsigned char data;
// Wait for reception complete

SPDR = 0xff;
while(!(SPSR & (1<<SPIF)));
  data = SPDR;

// Return data register
return data;
}