long long int foo = 9999999999;
int main() {
    loop:;
    if (foo == 0)
        goto end;
    else 
        foo--;
    goto loop;
    end:;
} 
