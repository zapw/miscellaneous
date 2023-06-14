#include <iostream>

class Base
{
public:
  virtual ~Base();
};

Base::~Base(){
    std::cout << "Destroying base" << std::endl;
};

class Derived : public Base
{
public:
  Derived(int number)
  {
    some_resource_ = new int(number);
  }

  ~Derived()
  {
    std::cout << "Destroying derived" << std::endl;
    delete some_resource_;
  }

private:
  int* some_resource_;
};

int main()
{
  Base* p = new Derived(5);
  delete p;
}
