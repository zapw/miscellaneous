#include <stdio.h>

long long square(long long);

long long value = 6;
const char* output = "The square of %lld is %lld\n";

int main(){
    fprintf(stdout,output,value,square(value));
    return 0;
}
