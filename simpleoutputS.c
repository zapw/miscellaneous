#include <stdio.h>
long long simploutput(char[],long long,char[],long long,long long);

char string1[] = "Hello there!\nHumus Chips Salad\n";
char string2[] = "Hello there !\nHello there Have you had humuus today!\n";
long long mynum = 20;


int main(){
   printf("%lld\n",simploutput(string1,sizeof(string1),string2,sizeof(string2),mynum));
}
