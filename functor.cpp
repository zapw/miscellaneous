
#include <iostream>
class Fun
{
public:
	void operator() (int a = 5){
		std::cout << a;
	}
};

int main(){
	Fun{}();
}
