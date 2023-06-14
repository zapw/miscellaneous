#include <iostream>
struct f {
	char ch{};
	char ch1{};
	char ch2{};
	char hi{'5'};
};

class A {
public:
  int id;

  A(): id(42) {
    printf("A: yay, my address is %p, my size is %zu, and my id is %d!\n",
           this, sizeof(*this), this->id);
  }

  virtual void print() {
    printf("I am A(%d)\n", id);
  }
};

class B {
public:
  int age;

  B(): age(7) {
    printf("B: yay, my address is %p, my size is %zu, and my age is %d!\n",
           this, sizeof(*this), this->age);
  }

  virtual void print() {
    printf("I am B(%d)\n", age);
  }
};

class C: public A, public B {
public:
  int mode;

  C(): mode(-1) {
    printf("C: yay, my address is %p, my size is %zu, my id, age and mode are %d, %d, %d!\n",
           this, sizeof(*this), this->id, this->age, this->mode);
  }

  virtual void print() {
    printf("I am C(%d, %d, %d)\n", id, age, mode);
  }
};

int main(){
	C c;
	//c.print();
	C* cp = &c;
	B* foo  = static_cast<B*>(cp);
	//static_cast<A*>(&c)->print();
        //static_cast<B*>(&c)->print();
	std::cout << foo << "\n";
	std::cout << cp;
	foo->print();
	std::cout << &((struct f*)NULL)->ch2 << '\n';

}
