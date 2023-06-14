#include <iostream>
template <typename T>
void somefun(T t){
	std::cout << "cheese";
}


template void somefun<int>(int);
