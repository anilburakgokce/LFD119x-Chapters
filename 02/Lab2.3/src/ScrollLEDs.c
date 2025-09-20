// memory-mapped I/O addresses
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main ( void )
{
  int En_Value=0xFFFF, led_conf = 0;

  WRITE_GPIO(GPIO_INOUT, En_Value);

  while (1) { 
    int led_counter = 1;
    while(led_counter < 17){
      led_conf = (1 << led_counter) - 1;
      for(int i = 0; i < 16 - led_counter; i++){
        WRITE_GPIO(GPIO_LEDs, led_conf);  // set LEDs
        led_conf <<= 1;
      }
      WRITE_GPIO(GPIO_LEDs, led_conf);  // set LEDs for the edge case (leftmost)
      led_conf >>= 1; // pull from 15th to 14th bit index

      for(int i = 0; i < 16 - led_counter; i++){
        if(i == 13){
          system("PAUSE");
        }
        WRITE_GPIO(GPIO_LEDs, led_conf);  // set LEDs
        led_conf >>= 1;
      }
    led_counter += 1;
    }
  }

  return(0);
}

