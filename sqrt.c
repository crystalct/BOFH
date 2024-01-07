#include <stdio.h>
#include <math.h>
#include <stdlib.h>


void main(void)
{
        int c;
        printf("sqrttbl: dc.b \n");
        for (c = 0; c < 256; c++)
        {
                int integer = sqrt(c);
                printf("%d,", integer);
                if ((c & 15) == 15) printf("\ndc.b ");
        }
}
