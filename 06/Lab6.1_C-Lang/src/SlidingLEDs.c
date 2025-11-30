#if 0
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define slowStepTime (1<<11)
#define fastStepTime (1<<9)

typedef enum {
    left, right
} direction;

unsigned nextLEDs_value(unsigned LEDs_value, direction d){
    if(d == left){
        switch (LEDs_value){
            case 0x0:
                return 0x1;
            case 0x1:
                return 0x3;
            case 0x3:
                return 0x7;
            case 0x7:
                return 0xF;
            default:
                return (LEDs_value << 1) & 0xFFFF;
        }
    }
    else{
        switch (LEDs_value){
            case 0x0:
                return 0x8000;
            case 0x8000:
                return 0xC000;
            case 0xC000:
                return 0xE000;
            case 0xE000:
                return 0xF000;
            default:
                return LEDs_value >> 1;
        }
    }
}

int main ( void )
{
    int En_Value=0xFFFF, switches_value;
    unsigned LEDs_value = 0;

    WRITE_GPIO(GPIO_INOUT, En_Value);

    volatile unsigned stepTime = slowStepTime;
    direction d = left;

    unsigned counter = 0;
    while (1) { 
        switches_value = READ_GPIO(GPIO_SWs);
        switches_value = (switches_value >> 16) & 0x3;

        if(switches_value == 0){
            d = left;
            stepTime = slowStepTime;
        }
        else if(switches_value == 1){
            d = left;
            stepTime = fastStepTime;
        }
        else if(switches_value == 2){
            d = right;
            stepTime = slowStepTime;
        }
        else {
            d = right;
            stepTime = fastStepTime;
        }

        // if the time has come, move LEDs
        if(counter > stepTime){
            counter = 0;

            // move LEDs
            LEDs_value = nextLEDs_value(LEDs_value, d);
            WRITE_GPIO(GPIO_LEDs, LEDs_value);
        }
        counter++;
    }

    return(0);
}
#endif