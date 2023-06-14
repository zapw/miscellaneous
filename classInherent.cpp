#include<iostream>
using namespace std;
class A {
public:
    int a{333};
    A(int x): a{x}  { cout << "A called" << endl;   }
};
 
class B : public A {
public:
    B(int x):A(x)   {
       cout<<"B called"<< endl;
    }
};
 
class B2 : public A {
public:
    B2(int x):A(x+5) {
        cout<<"B2 called"<< endl;
    }
};
 
class C : public B2, public B  {
public:
    C(int x): B2(x), B(x) {
        cout<<"C called"<< endl;
    }
};

int main()  {
    C c(30);
    std::cout << c.B2::A::a; //ambiguous
    //std::cout << c.B::A::a; ambiguous
    //std::cout << c.a ;
}
