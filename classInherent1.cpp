#include<iostream>
using namespace std;
class Person {
public:
    Person(int x)  { cout << "Person::Person(int ) called" << endl;   }
    Person()     { cout << "Person::Person() called" << endl;   }
};
 
class Faculty : virtual public Person {
public:
    Faculty(int x):Person(x)   {
       cout<<"Faculty::Faculty(int ) called"<< endl;
    }
};

class Student : virtual public Person {
public:
    Student(int x):Person(x) {
        cout<<"Student::Student(int ) called"<< endl;
    }
};

class F: public Faculty {
	public:
	F(int x):Person(x), Faculty(x){
		cout <<"F int called"<< '\n';
	}
};

int main(){
	F f(2);
}
