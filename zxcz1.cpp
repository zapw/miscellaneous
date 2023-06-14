#include <iostream>

class Hummus
{
	public:
		enum What
		{
			hummus,
			beans
		};

		int X = 5;
		static int m;
};

int Hummus::m { 5 };

int main(void){
	int O;
	O = {4};
	std::cout << Hummus::m << '\n';
	Hummus::m = {10};
	std::cout << Hummus::m << '\n';
	std::cout << O << '\n';
	std::cout << Hummus::hummus;
}
