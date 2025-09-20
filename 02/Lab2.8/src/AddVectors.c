#define length 12

int A[length] = {0,1,2,7,-8,4,5,12,11,-2,6,3};
int B[length] = {0,1,2,7,-8,4,5,12,11,-2,6,3};
int C[length] = {0};

int main ( void )
{
  for(int i = 0; i < length; i++){
    C[i] = A[i] + B[i];
  }

  return(0);
}

