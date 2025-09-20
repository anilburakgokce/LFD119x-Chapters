// memory-mapped I/O addresses
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

void initGPIO();
void delay(int num);

int main ( void )
{
  int switches_value, flash_on = 0;
  initGPIO();
  while (1) { 
    // switches_value = READ_GPIO(GPIO_SWs);   // read value on switches
    switches_value = 0xffff0000;
    switches_value = switches_value >> 16;  // shift into lower 16 bits
    flash_on ^= 0xffff;
    WRITE_GPIO(GPIO_LEDs, switches_value & flash_on);  // display switch value on LEDs
    delay(10000);
  }

  return(0);
}

void initGPIO(){
  int En_Value=0xFFFF;
  WRITE_GPIO(GPIO_INOUT, En_Value);
}

void delay(int num){
  for(int i = 0; i < num; i++);
}