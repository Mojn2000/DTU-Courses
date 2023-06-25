#include <stdlib.h>
#include <stdio.h>
#include "matrix_io.h"

int call_dgesv(matrix_t * A, vector_t * b);

int main(int argc, char *argv[]) {
  if (argc != 4) {
    fprintf(stderr,"Usage: %s A b x\n", argv[0]);
    return EXIT_FAILURE;
  }

  /* Insert your code here */
  matrix_t *A = read_matrix(argv[1]);
  if (A == NULL) {
    fprintf(stderr, "Error reading %s\n",argv[1]);
    return EXIT_FAILURE;
  }

  vector_t *b = read_vector(argv[2]);
  if (b == NULL) {
    fprintf(stderr, "Error reading %s\n",argv[2]);
    return EXIT_FAILURE;
  }

  int info;
  info = call_dgesv(A,b);
  if (info != 0) {
    fprintf(stderr, "Solution to system does not exits! Info = %d.\n", info);
    return EXIT_FAILURE;
  }
  write_vector(argv[3],b);

  free_matrix(A);
  free_vector(b);

  return EXIT_SUCCESS;
}
