#include<stdio.h>

long squareme(long);
long multbyten(long);
void printstuff();

int main() {
 long number = 4;
 fprintf(stdout, "The square of %ld is %ld\n", number, squareme(number));
 fprintf(stdout, "Ten times %ld is %ld\n", number, multbyten(number));
 printstuff();
}
