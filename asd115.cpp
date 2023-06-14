#include <cmath>
#include <iostream>
#include <string>
using namespace std;
  
struct b{
    int a;
    int b;
    int c;
};

struct a {
    b arr[3];
};

struct c {
    int bbb[3][2];
};

struct d{
    int bbbD[3];
};

int main(){
  int bbX[3][2] = { {10,11},{12,13},{14,15} };
  a foobar = {  {1,2,3},{4,5,6},{7,8,9}  };
  c bar = { { {10,11},{12,13},{14,15} } };
  d barD = {{ 1 , 2, 3 }};
  cout << bar.bbb[2][1] << '\n';
  cout << foobar.arr[2].c << '\n';
  cout << bbX[2][1] << '\n';
  cout << barD.bbbD[2];
}
