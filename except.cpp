#include <iostream>

void printMessage()
{
	std::cout << "Hello World!" << '\n';
  	exit(0);
}
 
void banner(){
}
void execute(int a) noexcept
{
  	//if (noexcept(banner())) throw "Ha!";
}

class F {
	public:
	int x{3};
	F() {
		std::cout << "humus";
	}
	~F(){
		throw;
	}
};
 
int main()
{
  std::set_terminate(&printMessage);
  try{
  	F f;
  }
  catch (...){
	  std::cout << "asdad";
  }
}
