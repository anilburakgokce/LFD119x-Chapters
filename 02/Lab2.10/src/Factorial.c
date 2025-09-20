#include <psp_api.h>

static int n = 7;

int main ( void )
{
  int result = 1;
  for(int i = 2; i <= n; i++){
    result *= i;
  }

  // Initialize UART
  uartInit();
  printfNexys("Result: %d\n", result);

  return(0);
}

