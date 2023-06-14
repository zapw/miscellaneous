#include <iostream>



class humus {
	int a{2};
	int b{3};
	public:
	int operator [](int i){
		return *(&a+i);
	};
};


int main(){
    humus h;
    humus* hp{&h} ;
    std::cout << (*hp)[1];

}

