#include <iostream>
#include <cassert>


auto somefun(int a,int l){
	if (a > 2){
		return 99;
	}else if ( a == 3){
		return 3;
	}
	assert(false);
}


int main (){
	int a = somefun(333,99);
	std::cout << a;
}
