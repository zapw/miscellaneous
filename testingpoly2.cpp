#include <iostream>

class base
{
  public:
    virtual void foo(float x){ std::cout << "pita"; }; 
    virtual void foo(int x){ std::cout << "pita"; }; 
    virtual void sss() { };
};


class derived: public base
{
   public:
     void foo(float x) override { std::cout << "humus"; } // OK
};

class derived2: public base
{
   public:
     //void foo(int x) override { std::cout << "salad"; } // ERROR
     void sss() { std::cout << "hi"; };
     void foo(int x) { std::cout << "chips"; } // ERROR
};


int main(){
	base&& b {derived2()};
	b.foo(float(2.5));
}
