// memory-mapped I/O addresses
#define GPIO_IN     0x80001400
#define GPIO_OUT    0x80001404
#define GPIO_INOUT  0x80001408

#define PTC2_ADDR_BASE  0x80001240
#define PTC3_ADDR_BASE  0x80001280
#define PTC4_ADDR_BASE  0x800012C0

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define WRITE_PTC_HRC(base, value) {(*(volatile int *) (base+4)) = (value);}
#define WRITE_PTC_LRC(base, value) {(*(volatile int *) (base+8)) = (value);}
#define WRITE_PTC_CTRL(base, value) {(*(volatile int *) (base+12)) = (value);}

int main(){
    int En_Value=0xFFFF, switches_value = 0;

    WRITE_GPIO(GPIO_INOUT, En_Value);

    // fix LRC registers to 65 so that it is always 0.5 < (64-[switch value])/65 < 1
    int lrc_value = 65;
    WRITE_PTC_LRC(PTC2_ADDR_BASE, lrc_value);
    WRITE_PTC_LRC(PTC3_ADDR_BASE, lrc_value);
    WRITE_PTC_LRC(PTC4_ADDR_BASE, lrc_value);

    while(1){
        // read switches and extract PWM values for BGR
        switches_value = (READ_GPIO(GPIO_IN)) >> 16;
        int b = switches_value & 0x1f;
        int g = (switches_value >> 5) & 0x1f;
        int r = (switches_value >> 10) & 0x1f;

        // set HRC registers according to the inputs (64-[switch value])
        WRITE_PTC_HRC(PTC2_ADDR_BASE, lrc_value - 1 - b);
        WRITE_PTC_HRC(PTC3_ADDR_BASE, lrc_value - 1 - g);
        WRITE_PTC_HRC(PTC4_ADDR_BASE, lrc_value - 1 - r);

        // reset PTC modules
        int reset_value = 0xc0;
        WRITE_PTC_CTRL(PTC2_ADDR_BASE,reset_value);
        WRITE_PTC_CTRL(PTC3_ADDR_BASE,reset_value);
        WRITE_PTC_CTRL(PTC4_ADDR_BASE,reset_value);

        // start PTC modules in PWM mode
        int start_value = 0x9;
        WRITE_PTC_CTRL(PTC2_ADDR_BASE,start_value);
        WRITE_PTC_CTRL(PTC3_ADDR_BASE,start_value);
        WRITE_PTC_CTRL(PTC4_ADDR_BASE,start_value);

        // delay
        for(int j = 0; j < 0x2000; j++);
    }

    return 0;
}
