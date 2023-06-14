#include <iostream>


enum class Foo { 
	h,
	y,
};

enum class Aaa {
	x = 1,
	z = 2,
	//bool operator==(int x){
	//	return true;
	//}
};

bool operator==(Aaa z,int x){
		return false;
}

int Xx;
Aaa a{Aaa::x};
//Foo f{y};

enum Fff;
//void ff(enum Fff);
int main(){
	//a == 1 ? std::cout << "humus" : std::cout << "salad";
	 Aaa::x == 1 ? std::cout << "ff" : std::cout << "sdsd";
	 std::cout << &Xx;
}

