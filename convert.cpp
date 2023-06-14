#include <iostream>


class Foo {
public:
  explicit Foo(int x);
};

class Bar {
public:
  explicit Bar(double x,double y){};
};


int main(){
	Bar x = (Bar)(3.14,3.1);
}
