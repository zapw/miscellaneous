#include <iostream>

void foo(std::nullptr_t a){
	std::cout << "asdasd";
}


double  *pi = nullptr;
int main(){
	//std::cout << pi;
	foo(0);
}
