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


#define N 128
#define M 128
extern unsigned char VanGogh_128x128[];
RGB ColourImage[N][M];
unsigned char GreyImage[N][M];


void initColourImage(RGB image[N][M]) {
    int i,j;

    for (i=0;i<N;i++)
        for (j=0; j<M; j++) {
            image[i][j].R = VanGogh_128x128[(i*M + j)*3];
            image[i][j].G = VanGogh_128x128[(i*M + j)*3 + 1];
            image[i][j].B = VanGogh_128x128[(i*M + j)*3 + 2];
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

// lab 5.4
#define filterWidth 5
#define filterHeight 5

int blurFilter[filterHeight][filterWidth] =
{
  0, 0, 1, 0, 0,
  0, 1, 1, 1, 0,
  1, 1, 1, 1, 1,
  0, 1, 1, 1, 0,
  0, 0, 1, 0, 0,
};

double factor = 1.0 / 13.0;

RGB BlurredImage[N][M];

void blurImage(RGB blurredImage[N][M], RGB image[N][M]){
    for(int i=0;i<N;i++){
        for (int j=0; j<M; j++) {
            double red = 0, green = 0, blue = 0;
            for(int mIndex = 0; mIndex < filterHeight; mIndex++){
                for(int mJindex = 0; mJindex < filterWidth; mJindex++){
                    RGB pixel = image[(i+mIndex-(filterHeight/2)+N)%N][(j+mJindex-(filterWidth/2)+M)%M];
                    red += pixel.R * blurFilter[mIndex][mJindex];
                    green += pixel.G * blurFilter[mIndex][mJindex];
                    blue += pixel.B * blurFilter[mIndex][mJindex];
                }
            }
            blurredImage[i][j].R = (char) (red*factor);
            blurredImage[i][j].G = (char) (green*factor);
            blurredImage[i][j].B = (char) (blue*factor);
        }
    }
}

int main(void) {
    // Create an NxM matrix using the input image
    initColourImage(ColourImage);

    // Transform Colour Image to Grey Image
    // ColourToGrey(ColourImage,GreyImage);

    // Initialize Uart
    uartInit();
    // Print message on the serial output
    // printfNexys("Created Grey Image");

#if 0
    // Lab 5.2
    countExtremes(GreyImage);
    printfNexys("\nNumber of pixels close to white: %d\n", closeToWhite);
    printfNexys("Number of pixels close to black: %d\n", closeToBlack);
#endif

    // Lab 5.4
    blurImage(BlurredImage, ColourImage);
    printfNexys("Created Blurred Image");

    while(1);

    return 0;
}


