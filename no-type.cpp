#include <iostream>
const int o{2};
template <typename T>
constexpr int X(T& n) {
	const int *ZZ = &o;
	//if ( n < 0 )
	//	throw "sss";
	 
	//n++; 
	
       	return 1 + 1 + o + *ZZ;
}
int n = 0;
constexpr int i = X(n);


template <typename T>
void f(T t) {
  //static_assert(i == 1, "");
}
const int one = 1;
int main(){
	//std::cout << typeid(a);
	f(one);
	std::cout << i;
}
