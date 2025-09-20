#include <psp_api.h>
#include <stdlib.h>

// memory-mapped I/O addresses
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define DELAY_MS 0x3B9            /* Define the DELAY - empirical number approximately equal to 1 ms */

void initGPIO();
void delay(int num);
unsigned int readSwitches();

unsigned int waitForReset(){
  volatile unsigned int count = 0;
  volatile int sw15 = readSwitches() & 0x8000;

  // Wait for the left-most switch to be on
  while(!sw15){
    count++;
    sw15 = readSwitches() & 0x8000;
  }

  // Wait for the left-most switch to be off
  while(sw15){
    count++;
    sw15 = readSwitches() & 0x8000;
  }

  return count;
}

// returns 0 iff a reset is initiated
unsigned int waitForPlayer(int led_conf, int led_count){

  unsigned int count = 1;
  int switches_value = 0;
  int extracted_switches = readSwitches() & ((1 << led_count) - 1);

  while(extracted_switches != led_conf){
    count++;
    switches_value = readSwitches();

    // check for reset
    if(switches_value & 0x8000){
      return 0;
    }

    extracted_switches = switches_value & ((1 << led_count) - 1);
  }

  return count;
}

void writeLEDs(int led_conf){
  WRITE_GPIO(GPIO_LEDs, led_conf);
}

int main ( void )
{
  initGPIO();
  uartInit();
  
  while (1) { 
    unsigned int seed = waitForReset();
    srand(seed);
    writeLEDs(0); // turn off all LEDs
    delay(1000); // wait for one second

    for(int led_count = 3; led_count < 16; led_count++){
      int led_conf = rand() & ((1 << led_count) - 1);

      // blink the LEDs
      writeLEDs(led_conf);
      delay(1000); 
      writeLEDs(0);

      seed = waitForPlayer(led_conf, led_count);
      if(!seed){
        break;
      }

      // wait 1 second for the next round
      delay(1000);
    }
    
  }

  return(0);
}

void initGPIO(){
  int En_Value=0xFFFF;
  WRITE_GPIO(GPIO_INOUT, En_Value);
}

// delays for num milliseconds
void delay(int num) {
  volatile int i, j, cnt = DELAY_MS;
  for (i = 0; i < num; i++)
    for (j = 0; j < cnt; j++)
      ;
}

unsigned int readSwitches() {
    int switches_value = READ_GPIO(GPIO_SWs);   // read value on switches
    // int switches_value = 0xffff0000;
    switches_value = switches_value >> 16;  // shift into lower 16 bits

  return switches_value & 0xffff;
}