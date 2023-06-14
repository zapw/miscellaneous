#include <array>
#include <iostream>

class Test {
	private:
	 std::array<double, 10000> values;
	public:
	 //Test(std::array<double, 10000> v) : values{std::move(v)} {
	 Test(const std::array<double, 10000>& v) : values{v} {
 	 }

};


int main(){
     Test d{{3.4,5.2,1.4}};
}
