#include <stdio.h>
#include <math.h>

void main(void)
{
        int x,y;
        for (y = 0; y < 16; y++)
        {
                for (x = 0; x < 16; x++)
                {
                        double xd,yd;
                        xd = x;
                        yd = y;

                        if (yd == 0) yd = 0.000000000001;

                        printf("%02d,", (int)(atan(xd/yd)/(3.141592654/2)*64.000001));
                }
                printf("\n");
        }
}
