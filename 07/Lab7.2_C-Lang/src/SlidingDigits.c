#define SegEn_ADDR    0x80001038
#define SegDig_ADDR   0x8000103C

#define GPIO_SWs      0x80001400
#define GPIO_LEDs     0x80001404
#define GPIO_INOUT    0x80001408

#define WRITE_7Seg(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

# define stepTime 0x1000

int main ( void )
{
    int switches_value, seven_segment_value = 0, seven_segment_value_counter = 0, counter = 0, enabled_7seg = 0xFF;

    WRITE_GPIO(GPIO_INOUT, 0xFFFF);

    while (1) {
        switches_value = READ_GPIO(GPIO_SWs);
        int sw0 = (switches_value >> 16) & 1;

        // turn off if switch[0] is off
        if(!sw0){
            // turn off all the leds, reset and continue
            enabled_7seg = 0xFF;
            WRITE_7Seg(SegEn_ADDR, enabled_7seg);
            seven_segment_value_counter = 0;
            counter = 0;
            continue;
        }

        // if the limit is reached, wait for reset
        if(seven_segment_value_counter > 8){
            continue;
        }
        
        // operate normally when switch[0] is on
        if(counter > stepTime){
            counter = 0;

            enabled_7seg <<= 1;
            WRITE_7Seg(SegEn_ADDR, enabled_7seg)

            seven_segment_value <<= 4;
            seven_segment_value += seven_segment_value_counter;
            WRITE_7Seg(SegDig_ADDR, seven_segment_value);
            seven_segment_value_counter++;
        }

        counter++;
    }

    return(0);
}
