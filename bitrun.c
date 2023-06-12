#include <stdio.h>

long long bit5fun(long long, long long, long long);

long long bit1 = 0b110000010100101110111110;
long long bit2 = 0b010101010101000011110111;
long long bit3 = 0b010100101001110101111000;

int main(){
    return bit5fun(bit1,bit2,bit3);
}
