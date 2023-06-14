#include <iostream>  
using namespace std;

class ABC  
{  
public:   
    const char *a;  
    ABC()  
     { cout<<"Constructor"<<endl; }  
    ABC(const char *ptr)  
     { cout<<"Constructor ChaR"<<endl; }  
    ABC(ABC  &obj)  
     { cout<<"copy constructor"<<endl;}  
    ABC(ABC&& obj)  
    { cout<<"Move constructor"<<endl; }  
    ~ABC()  
    { cout<<"Destructor"<<endl; }  
};

ABC fun123()  
{ ABC obj; return obj; }  

ABC xyz123()  
{  return ABC(); }  

int main()  
{  
//    ABC abc;  
//    ABC obj1(fun123());    //NRVO  
    ABC obj2(xyz123());    //RVO, not NRVO 
//    ABC xyz = "Stack Overflow";//RVO  
    return 0;  
}
//$ g++ -Wall elide.cpp  -o elide -fno-elide-constructors
