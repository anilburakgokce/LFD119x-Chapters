#define SevSeg_BASE     0x80001038
#define PTC_ADDR_BASE   0x80001200

#define WRITE_7Seg(dir, value) { (*(volatile char *)dir) = (value); }
#define WRITE_PTC_HRC(value) {(*(volatile int *) (PTC_ADDR_BASE+4)) = (value);}
#define WRITE_PTC_LRC(value) {(*(volatile int *) (PTC_ADDR_BASE+8)) = (value);}
#define WRITE_PTC_CTRL(value) {(*(volatile int *) (PTC_ADDR_BASE+12)) = (value);}
#define PTC_CTRL_INT_IS_SET (((*(volatile int *) (PTC_ADDR_BASE+12)) & 0x40) != 0)

// digits for SevSeg from 0 to 9
const char decoded_digits[10] = {0x81,0xcf,0x92,0x86,0xcc,0xa4,0xa0,0x8f,0x80,0x8c};

// input a0: number to print on seven segment
void write_number(int number){
    int rem = 0;
    for(int i = 0; i < 8; i++){
        rem = number % 10;
        WRITE_7Seg((SevSeg_BASE+i), decoded_digits[rem]);
        number = number / 10;
    }
}
int main(){

    int number = 0;

    write_number(number);

    // init and begin PTC
    WRITE_PTC_LRC(0x18000)
    WRITE_PTC_CTRL(0xc0)
    WRITE_PTC_CTRL(0x21)

    while(1){
        if(PTC_CTRL_INT_IS_SET){

            // restart the timer
            WRITE_PTC_CTRL(0xc0)
            WRITE_PTC_CTRL(0x21)

            // increment and then write the number
            write_number(++number);
        }
    }
    return 0;
}
