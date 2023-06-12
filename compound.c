#include <stdio.h>

void compound(double start, double interest, int months)
{

    int year = 1;
    int counter = 1;
    double interest_clean = (1 + interest / 100);
    do
    {
        start *= interest_clean;
        printf("minus is: %f\n", start);
        months--;
        counter++;
        if ((counter % 13) == 0)
        {
            printf("\nYear %d\n", year);
            year++;
        }
    } while (months > 0);
}

int main()
{
    compound(45000, 2.2222222, 24);
    return 0;
}
