#define Seg_ADDR 0x80001038

#define WRITE_7Seg(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main ( void )
{
    int ello = ~0x4f0e0e7e;
    int h = ~0x37;

    WRITE_7Seg(Seg_ADDR, ello);
    WRITE_7Seg((Seg_ADDR+4), h);

    return(0);
}
