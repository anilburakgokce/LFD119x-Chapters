// memory-mapped I/O addresses
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define length 12

int numbers[length] = {0};


static int fib_n = 0, fib_n_m1 = 1;
static int fib_i = 0;

// sets b <= a and a <= a+b
void fib_next(){
  int temp = fib_n_m1;
  fib_n_m1 = fib_n;
  fib_n = temp + fib_n;
  fib_i++;
}

int main ( void )
{
  int En_Value=0xFFFF, testcounter = 3;

  while(1){
    // int switches_value = READ_GPIO(GPIO_SWs) >> 16;
    int switches_value = testcounter;
    while(fib_i < switches_value){
      fib_next();
    }
    for(int i = 0; i < length; i++){
      numbers[i] = fib_n;
      fib_next();
    }
    testcounter++;
  }
  return(0);
}

