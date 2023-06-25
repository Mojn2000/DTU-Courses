#include <stdlib.h>
#include <math.h>
#include "matrix.h"

/* Function that solves exercise 1 in assignment 1 in PMS course @DTU */
int fwdsub(unsigned long n,  double alpha,  double **R,  double *b){
  // Define temporary variable
  double temp;
  for (size_t k = 0; k < n; k++) {
    // Compute sum
    temp = 0;
    for (size_t i = 0; i < k; i++) {
      temp += b[i]*R[i][k];
    }

    // Check we dont divide by 0
    if ((alpha + R[k][k]) == 0) {
      return -1;
    }

    // Compute bk
    b[k] = (b[k] - temp)/(alpha + R[k][k]);
  }
  return 0;
}

/* Function that solves exercise 2 in assignment 1 in PMS course @DTU */
int tri_sylvester_solve(const matrix_t *R, matrix_t *C) {
  // Check existence
  if (R == NULL || C == NULL) {
    return -2;
  }
  // Check dimension error
  if (!((R->m)==(R->n)) || !((R->m)==(C->m)) || !((C->m)==(C->n)) ) {
    return -2;
  }
  double temp;
  // Iterate over k
  for (size_t k = 0; k < (C->m); k++) {
    for (size_t i = 0; i < (C->n); i++) {
      temp = 0;
      // Compute gamma
      for (size_t j = 0; j < k; j++) {
        temp += (C->A)[j][i] * (R->A)[j][k];
      }
      // Deine c_ki
      (C->A)[k][i] += -temp;
    }
    // Perform forward substitution
    if (fwdsub((C->n),(R->A)[k][k],(R->A),(C->A)[k]) == -1){
      return -1;
    }
  }
  return 0;
}