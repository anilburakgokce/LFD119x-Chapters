#define length 12

int A[length] = {0,1,2,7,-8,4,5,12,11,-2,6,3};

void switchPlaces(int *a, int *b){
  int temp = *b;
  *b = *a;
  *a = temp;
}

int main ( void )
{
  while(1){
    int switch_done = 0;
    for(int i = 0; i < length - 1; i++){
      if(A[i] > A[i+1]){
        switchPlaces(A + i, A + i + 1);
        switch_done = 1;
      }

    }
    

    if(switch_done == 0)
      break;
  }

  return(0);
}

