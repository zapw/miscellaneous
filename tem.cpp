#include <iostream>

template<int T> class SomeType{
	public:
	void f(){
		std::cout << T;
	}
};

int main(){
	SomeType<33>st;
	st.f();
}

