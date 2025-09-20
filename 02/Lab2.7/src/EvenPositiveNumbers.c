#include <psp_api.h>

#define length 12

int A[length] = {0,1,2,7,-8,4,5,12,11,-2,6,3};
int B[length] = {0};

int main ( void )
{
  int B_len = 0;
  for(int i = 0; i < length; i++){
    if((A[i] > 0) && ((A[i] & 1) == 0)) {
      B[B_len] = A[i];
      B_len++;
    }
  }

  uartInit();
  printfNexys("Number of elements in B = %d\n", B_len);

  return(0);
}

