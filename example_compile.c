#include <stdio.h>
int squareme(int  x) {
 return x * x;
}
static int  myval;
int main() {
 fprintf(stdout, "Enter a number: \n");
 fscanf(stdin, "%d", &myval);
 fprintf(stdout, "The square of %d is %d", myval, squareme(myval));
}
