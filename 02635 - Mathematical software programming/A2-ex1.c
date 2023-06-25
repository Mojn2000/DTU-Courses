#include "matrix_io.h"
//#include <Accelerate/Accelerate.h>

/* C prototype for LAPACK routine DGESV */
void dgesv_(const int *n,    /* columns/rows in A          */
            const int *nrhs, /* number of right-hand sides */
            double *A,       /* array A                    */
            const int *lda,  /* leading dimension of A     */
            int *ipiv,       /* pivoting array             */
            double *B,       /* array B                    */
            const int *ldb,  /* leading dimension of B     */
            int *info        /* status code                */
            );

/* call_dgesv : wrapper for LAPACK's DGESV routine

Purpose:
Solves system of equations A*x=b using LAPACK's DGESV routine
Upon exit, the input vector b is overwriten by the solution x.

Return value:
The function returns the output `info` from DGESV with the
following exceptions: the return value is

   -9 if the input A is NULL and/or the input B is NULL
   -10 if A is not a square matrix
   -11 if the dimensions of A and b are incompatible
   -12 in case of memory allocation errors.
*/

int call_dgesv(matrix_t * A, vector_t * b) {
  /* Insert your code here */
  if (A == NULL || b == NULL) return -9;
  if (A->m != A->n) return -10;
  if (A->m != b->n) return -11;
  int nrhs, info;
  nrhs = 1;
  const int n = (int) A->n;
  int *ipiv;
  ipiv = malloc(sizeof(int)*A->n);
  if (ipiv == NULL) return -12;
  // "Unpack" A
  double *data;
	data = malloc((A->n)*(A->m)*sizeof(double));
	if(data == NULL){
    free(data);
    free(ipiv);
		return -12;
	}
  int N=0;
	for (int i = 0; i < A->n; i++) {
		for (int j = 0; j < A->m; j++) {
			data[N++] = A->A[j][i];
		}
	}

  dgesv_(&n, &nrhs, data, &n, ipiv, b->v, &n, &info);

  free(ipiv);
  free(data);
  return info;
}
