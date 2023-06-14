#include <iostream>

class CX {};

template <typename T>
struct a {

    static void foo (CX x){
	    std::cout << typeid(x).name() << '\n';
    }

};

template <typename T>
struct b {

    static void foo (T = T())
    {
    }

};

class SomeObj {};
class SomeOtherObj {};
CX Opa;


template <template <typename P> class T>
void function ()
{
    T<SomeObj>::foo (CX());
    T<SomeOtherObj>::foo (CX()) ;
}

int main ()
{
    int Z = {};
    function<a>();
//    function<b>();
}
