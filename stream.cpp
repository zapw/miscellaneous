#include <iostream>

template <typename T>
class shit;

template<typename T = int>
class shit<int> {
	public:
	void operator<<(int a){
		std::cout << "cheese cake" << a;
	}
};



int main(){
	shit() << 5.4 ;
}
