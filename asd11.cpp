#include <iostream>
#include <memory>


template<class E, size_t size>
size_t array_size(const E(&)[size])
{
    return size;
}

void hey(const &t){
	std::cout << t;
}

template <typename T>
void some (int b) {
	T a = {3,4,3,1};
	std::cout << '\n' << a[3] << b << '\n';
}

int main()
{
    constexpr int fibonacci[]{ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89 };
    for (auto& number : fibonacci) // iterate over array fibonacci
    {
       std::cout << number << ' '; // we access the array element for this iteration through variable number
    }

    std::cout << '\n';
    //int test[] = {2, 3, 5, 7, 11, 13, 17, 19};
    int test[] = {2, 3, 5, 7, 11, 13, 17, 19};
    //std::cout << array_size(test) << std::endl; // prints 8
    std::cout << array_size({2,3,4,1,2,3,3,2}) << std::endl; // prints 8
    hey(5);

    some<int[2]>(5);
    auto array = std::make_unique<int[]>(5);
    return 0;
}
