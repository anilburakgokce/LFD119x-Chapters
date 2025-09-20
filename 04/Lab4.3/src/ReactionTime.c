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
int waitForTheUser();
void displayReactionTime(unsigned int time);

int main ( void )
{
  initGPIO();
  uartInit();

  volatile int switches_value;
  
  while (1) { 

    switches_value = readSwitches();

    if(! (switches_value & 1) ){

      WRITE_GPIO(GPIO_LEDs, 0); // turn all the LEDs off

      // wait between 500 ms and 3000 ms
      int time = (rand() % 2500) + 500;
      delay(time);

      WRITE_GPIO(GPIO_LEDs, 0xffff); // turn all the LEDs on

      int result = waitForTheUser();

     displayReactionTime(result);
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
    // int switches_value = (GPIO_SWs);   // read value on switches
    int switches_value = 0xffff0000;
    switches_value = switches_value >> 16;  // shift into lower 16 bits

  return switches_value & 0xffff;
}

int waitForTheUser(){
  volatile int count = 0;
  
  while(!(readSwitches() & 1)){
    count++;
  }
  return count/DELAY_MS;
}

// display reaction time on LEDs and serial monitor
void displayReactionTime(unsigned int time) {
  WRITE_GPIO(GPIO_LEDs, time);       
  printfNexys("Reaction Time: %d ms\n", time);
}