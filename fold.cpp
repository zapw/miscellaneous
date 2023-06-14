#include <string>
#include <utility>
#include <memory>
#include <iostream>
 
auto adder(auto ... args){
    ((std::cout << args), ...) ;
    return (args + ...);
 }

class AA {
	public:
	AA(){
		std::cout << "humus";
	}
};

int main(){

	long sum = adder<unsigned int>(-9,-9,-9,-9);
        AA{};
	std::string s1 = "x", s2 = "aa", s3 = "bb", s4 = "yy";
//	std::string ssum = adder(s1, s2, s3, s4);
//	std::cout << ssum;
	//std::cout << sum;
}
