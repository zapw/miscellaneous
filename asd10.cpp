#include <cmath>
#include <iostream>
using namespace std;
  
//template<class T, std::size_t N >
// void foo_c( T const(&t)[N] ){
constexpr int foo_c(const int (&t)[] ){
	 //std::cout << t[0];
	 return t[0];

}

int main(){
	constexpr int i = 5;
	//foo_c<int,5>({3,2,1,2,5});
	//int a[3] = {3,2,3};
	std::cout << foo_c({3,2,3});
}
