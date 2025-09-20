// memory-mapped I/O addresses
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

static int a, b;

int gcd(int a, int b){
  if(a == 0){
    return b;
  }
  if(b == 0){
    return a;
  }
  int c = a / b;
  int temp = a;
  a = b;
  b = temp - b*c;
  return gcd(a,b);
}

int main ( void )
{
  int En_Value=0xFFFF;
  WRITE_GPIO(GPIO_INOUT, En_Value);

  while (1) {
    a = 15;
    b = 9;
    int result = gcd(a,b);

    WRITE_GPIO(GPIO_LEDs, result);  // display switch value on LEDs
  }

  return(0);
}

