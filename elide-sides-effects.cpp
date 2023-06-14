#include <iostream>     
int n = 0;    
class ABC     
{  public:  
 ABC() {}    
 ABC(const ABC& a) { ++n; } // the copy constructor has a visible side effect    
};                     // it modifies an object with static storage duration    

int main()   
{  
  ABC c1{}; // direct-initialization, calls C::C(42)  
  //ABC c2 = ABC(); // copy-initialization, calls C::C( C(42) )  
  ABC c2 = c1; 

  std::cout << n << std::endl; // prints 0 if the copy was elided, 1 otherwise
  return 0;  
}
//-fno-elide-constructors
