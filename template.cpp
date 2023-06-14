#include <iostream>


template <typename T, typename K>
class foo {
	private:
	T t;
	K k;
	public:
	foo(K kk,T tt) : t{tt}, k{kk} { };
	void print(){
		std::cout << "humus \n" << t;
	};
};


foo chips(3,4);

int main(){
	chips.print();
}
