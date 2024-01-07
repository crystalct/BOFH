#include <stdio.h>
#include <math.h>
#include <stdlib.h>


void main(void)
{
        int c;
        printf("sintable: dc.b \n");
        for (c = 0; c < 256; c++)
        {
                double angle = c * 2.0 / 256.0 * 3.141592654;
                double value = sin(angle);
                int integer = value * 127.0;
                printf("%d,", integer);
                if ((c & 15) == 15) printf("\ndc.b ");
        }
}
