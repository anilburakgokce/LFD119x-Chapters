// memory-mapped I/O addresses
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

void initGPIO();
unsigned int getSwitchesInvert();

int main ( void )
{
  initGPIO();
  while (1) {
    WRITE_GPIO(GPIO_LEDs, getSwitchesInvert());  // display switch value on LEDs
  }
  return(0);
}

void initGPIO(){
  int En_Value=0xFFFF;
  WRITE_GPIO(GPIO_INOUT, En_Value);
}

unsigned int getSwitchesInvert(){
    // int switches_value = READ_GPIO(GPIO_SWs);   // read value on switches
    int switches_value = 0xcccc0000;
    return ((switches_value >> 16) & 0xffff) ^ 0xffff;
}

