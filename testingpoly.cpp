#include <iostream>

class B
{
public:
  virtual void bar() = 0;
  virtual void qux();
};

//void B::bar()
//{
//  std::cout << "This is B's implementation of bar" << std::endl;
//}

void B::qux()
{
  std::cout << "This is B's implementation of qux" << std::endl;
}

class C : public B
{
public:
  void bar() override;
  void foo();
};

void C::bar()
{
  std::cout << "This is C's implementation of bar" << std::endl;
}
void C::foo()
{
  std::cout << "This is C's foo" << std::endl;
}

int main(){
 B* b = new C();
 //B&& b {C()};
 //b.bar();
 b->bar();
 //B c;
 //c.bar;
 //b->foo();
 //int* hi {new int{5}};
}
