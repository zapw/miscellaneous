#include <iostream>

class MyClass {
public:
    int my_member;
    int cheese {99};
    int* foo {&cheese};
};

int main() {
    MyClass obj;
    obj.my_member = 42;
    //MyClass* ptr = &obj;
    int MyClass::* mem = &MyClass::my_member;
    std::cout << "Value of my_member: " << obj .* mem << std::endl;
    std::cout << "Value of my_member: " << * MyClass{} . foo << std::endl;
    //std::cout << "Value of my_member using pointer: " << ptr->*member_ptr << std::endl;

    std::cout << &MyClass{}.my_member;
    return 0;
}
