#include <stdlib.h>
#include <math.h>

int fwdsub(unsigned long n, double alpha, double **R, double *b)
{
    double temp;
    for (size_t k = 0; k < n; k++)
    {
        temp = 0;
        for (size_t i = 0; i < k; i++) {
            temp = temp + b[i]*R[i][k];
        }
        //Ensure that division by zero is not carried out.
        if (alpha + R[k][k] == 0){return -1;}
        b[k] = (b[k]-temp)/(alpha+R[k][k]);
    }
    return 0;
  }