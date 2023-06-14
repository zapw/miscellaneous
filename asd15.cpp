#include <iostream>

template<typename... Bases>
class X : public Bases... {
public:
	X(const Bases&... b) : Bases(b)... { }
};


int main(){
}

