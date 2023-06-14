//C++ code to demonstrate tuple_size
#include<iostream>
#include<tuple> // for tuple_size and tuple
using namespace std;
int main()
{
  
    // Initializing tuple
    tuple <char,int,float> geek(20,'g',17.5);
    tuple <char,int,float> cheese(1,'a',12.1);
  
    // Use of size to find tuple_size of tuple
    cout << "The size of tuple is : ";
    cout << tuple_size<decltype(geek)>::value << endl;
    cout << tuple_size<decltype(cheese)>::value << endl;
    int a{1};  
    int b = (++a,++a,100);
    std::cout << b;
    


    return 0;
  
}
