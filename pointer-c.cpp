#include <iostream>
class A {
public:
  int id;

  A(): id(42) {
    printf("A: yay, my address is %p, my size is %zu, and my id is %d!\n",
           this, sizeof(*this), this->id);
  }
};

class B {
public:
  int age;

  B(): age(7) {
    printf("B: yay, my address is %p, my size is %zu, and my age is %d!\n",
           this, sizeof(*this), this->age);
  }
};

class C: public A, public B {
public:
  int mode;

  C(): mode(-1) {
    printf("C: yay, my address is %p, my size is %zu, my id, age and mode are %d, %d, %d!\n",
           this, sizeof(*this), this->id, this->age, this->mode);
  }
};

int main(){
	C c;
	B* b = static_cast<B*>(&c);
	std::cout << b->mode;
}
