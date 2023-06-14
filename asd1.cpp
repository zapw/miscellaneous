// C++ program without declaring the
// move constructor
#include <iostream>
#include <vector>
using namespace std;
 
// Move Class
class Move {
private:
    // Declaring the raw pointer as
    // the data member of the class
    int* data;
 
public:
    // Constructor
    Move(int d)
    {
        // Declare object in the heap
        data = new int;
        *data = d;
 
        cout << "Constructor is called for "
             << d << endl;
    };
 
    // Copy Constructor to delegated
    // Copy constructor
    Move(const Move& source)
        : Move{ *source.data }
    {
 
        // Copying constructor copying
        // the data by making deep copy
        cout << "Copy Constructor is called - "
             << "Deep copy for "
             << *source.data
             << endl;
    }
 
    // Destructor
    ~Move()
    {
        if (data != nullptr)
 
            // If the pointer is not
            // pointing to nullptr
            cout << "Destructor is called for "
                 << *data << endl;
        else
 
            // If the pointer is
            // pointing to nullptr
            cout << "Destructor is called"
                 << " for nullptr"
                 << endl;
 
        // Free the memory assigned to
        // data member of the object
        delete data;
    }
};
 
template<class T>
struct A
{
    A(T,T){ };
};
template <typename ReturnType, typename ArgumentType>
 ReturnType Foo(ArgumentType arg){ return 'H';}


//template <typename ArgumentType>
//std::string Foo(ArgumentType arg) { return "Return1"; }

// Driver Code
int main()
{
	const int& rca2 = 5; 
	std::cout << Foo<char>('c');
    // Create vector of Move Class
    // int&& rra = 5; 
     // rca2 = 3;
    vector<Move> vec;
 
    // Inserting object of Move class
    vec.push_back(Move{ 10 });
    //vec.push_back(Move{ 20 });
    //
    A<int>{1, 2};
    return 0;
}
