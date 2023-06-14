#include <iostream>

class FOO {
	public:
	void sss(){
		std::cout << "humus";
	     }
};

template <typename T>
char foobar(...){
	std::cout << "fallback template\n";
	return 'c';
};

template <typename T,typename = decltype(std::declval<T>().sss())>
char foobar(int){
	std::cout << "compile time error\n";
	return 'c';
};


struct A {}; 

template <typename T> 
void foo(T t) {
       	t.some_function(); 
}


template <typename T>
void foo(...){
	std::cout << "chips";
}



int main(){
	foobar<FOO>(3);
	A a;
	foo<A>(a);
}
