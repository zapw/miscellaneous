#include <string>
#include <iostream>

void* operator new(size_t size)
{
    std::cout << "new overload called" << std::endl;    
    return malloc(size);
}


template <typename T>
void foo(std::initializer_list<T> args)
{
    for (auto&& a : args)
    std::cout << a << std::endl;
}

int main()
{
    foo ({2, 3, 2, 6, 7});

    // std::string test_alloc = "some string longer than std::string SSO";
}
