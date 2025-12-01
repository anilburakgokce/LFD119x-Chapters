#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define GPIO2_PBs   0x80001800
#define GPIO2_INOUT 0x80001808

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define slowStepTime 0x2000
#define fastStepTime 0x800

int main ( void )
{
    int pbu = 0, pbc = 0, pbu_prev = 0, pbc_prev = 0;
    unsigned LEDs_value = 1;

    // init GPIOs
    WRITE_GPIO(GPIO_INOUT, 0xFFFF);
    WRITE_GPIO(GPIO2_INOUT, 0x0);
    WRITE_GPIO(GPIO_LEDs, LEDs_value);

    unsigned stepTime = slowStepTime;

    unsigned counter = 0;
    while (1) { 
        volatile int pbs_value = READ_GPIO(GPIO2_PBs);
        pbu = pbs_value & 1;
        pbc = (pbs_value >> 1) & 1;

        // if pbu is released, reset time counter and LEDs
        if(pbu_prev == 1){
            if(pbu == 0){
                counter = 0;
                LEDs_value = 1;
                WRITE_GPIO(GPIO_LEDs, LEDs_value);
            }
        }

        // if pbc is released, alternate the speed
        if(pbc_prev == 1){
            if(pbc == 0){
                stepTime ^= slowStepTime ^ fastStepTime;
            }
        }

        // update previousses
        pbu_prev = pbu;
        pbc_prev = pbc;

        // if the time has come, increment LED counter
        if(counter > stepTime){
            counter = 0;
            LEDs_value++;
            WRITE_GPIO(GPIO_LEDs, LEDs_value);
        }
        counter++;
    }

    return(0);
}
