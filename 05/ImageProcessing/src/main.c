#if defined(D_NEXYS_A7)
   #include "bsp_printf.h"
   #include "bsp_mem_map.h"
   #include "bsp_version.h"
#else
   PRE_COMPILED_MSG("no platform was defined")
#endif

#include "psp_api.h"


typedef struct {
    unsigned char R;
    unsigned char G;
    unsigned char B;
} RGB;


#define N 256
#define M 256
extern unsigned char TheScream_256x256[];
RGB ColourImage[N][M];
unsigned char GreyImage[N][M];


void initColourImage(RGB image[N][M]) {
    int i,j;

    for (i=0;i<N;i++)
        for (j=0; j<M; j++) {
            image[i][j].R = TheScream_256x256[(i*M + j)*3];
            image[i][j].G = TheScream_256x256[(i*M + j)*3 + 1];
            image[i][j].B = TheScream_256x256[(i*M + j)*3 + 2];
        }
}

#if 0
extern int ColourToGrey_Pixel(int R, int G, int B);

void ColourToGrey(RGB Colour[N][M], unsigned char Grey[N][M]) {
    int i,j;
    
    for (i=0;i<N;i++)
        for (j=0; j<M; j++)
            Grey[i][j] =  ColourToGrey_Pixel(Colour[i][j].R, Colour[i][j].G, Colour[i][j].B); 
}
#else
int ColourToGrey_Pixel(int R, int G, int B){
    return (R*306 + G*601 + B*117) >> 10;
}

extern void ColourToGrey(RGB Colour[N][M], unsigned char Grey[N][M]);

#endif



int closeToWhite = 0;
int closeToBlack = 0;
int countExtremes(unsigned char Grey[N][M]){

    for(int i = 0; i < N; i++){
        for(int j = 0; j < M; j++){
            if(Grey[i][j] > 235){
                closeToWhite++;
            }
            else if(Grey[i][j] < 20){
                closeToBlack++;
            }
        }
    }
}


int main(void) {
    // Create an NxM matrix using the input image
    initColourImage(ColourImage);

    // Transform Colour Image to Grey Image
    ColourToGrey(ColourImage,GreyImage);

    // Initialize Uart
    uartInit();
    // Print message on the serial output
    printfNexys("Created Grey Image");

    // Lab 5.2
    countExtremes(GreyImage);
    printfNexys("\nNumber of pixels close to white: %d\n", closeToWhite);
    printfNexys("Number of pixels close to black: %d\n", closeToBlack);

    while(1);

    return 0;
}


