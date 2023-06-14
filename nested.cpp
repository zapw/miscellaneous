#include <iostream>
template<typename T>
class MyClass {
public:
    class MyNestedClass {
    public:
        // T is a dependent type here
        using Ptr = T*;
    };
    
    // ...
};

template<typename T>
class MyContainer {
public:
    template<typename U>
    class MyNestedClass {
    public:
        // T and U are dependent types here
        using Pair = std::pair<T, U>;
    };
    
    // ...
};

template<typename T>
void myFunction(T ptr) {
    // T is a dependent type here
    typename std::remove_const<T>::type nonConstPtr = ptr;
    
    // ...
}


template <typename> struct Magic; // defined somewhere else

template <typename T> struct A
{
  static const int value = Magic<T>::gnarl; // assumed "value"

  typedef typename Magic<T>::brugh my_type; // decreed "type"
  //      ^^^^^^^^

  void foo() {
    Magic<T>::template kwpq<T>(1, 'a', .5); // decreed "template"
    //        ^^^^^^^^
  }
};

template <typename T> struct Magic
{
  static const T                    gnarl;
  typedef T &                       brugh;
  template <typename S> static void kwpq(int, char, double) { T x; }
};
template <> struct Magic<signed char>
{
  // note that `gnarl` is absent
  static constexpr long double brugh = 0.25;  // `brugh` is now a value
  template <typename S> static auto kwpq(long double a, long double b) { return a + b; }
};

template<typename T>
struct SomeBase {
	using type = int;
	struct AHA {
	};
};
//struct derive_from_Has_type : SomeBase::AHA
// { };

template <typename T>
 struct derive_from_Has_type : SomeBase<T> {
    //using SomeBase<T>::template type; // error
    //using typename SomeBase<T>::type; // typename *is* allowed
};

struct BASE {
	using type = int;
};

struct Derived: BASE {
	//using BASE::type;

};

struct B {
  typedef int result_type;
};

template<typename T>
struct C { }; // could be specialized!


template<>
struct C<int> {
  typedef bool result_type;
  typedef int questionable_type;
};

template<typename T>
struct D : C<T>, B {
  int f() {
    // OK, member of current instantiation!
    // A::result_type is not dependent: int
    //D::result_type r1;
    D::result_type r1{4};
    return r1;

    // error, not a member of the current instantiation
    //D::questionable_type r2;

    // OK for now - relying on C<T> to provide it
    // But not a member of the current instantiation
    //typename D::questionable_type r3;        
  }
};

struct BB { void f(); };
struct AA : virtual BB { void f(); };

template<typename T>
struct CC : virtual BB, T {
  void g() { this->f(); }
};


int main(){
	CC<AA> c; c.g();
	//D<int>::result_type H{4};
	D<int> FF;
	//std::cout << H;
	std::cout << FF.f();
	//Derived ddd;
	//Derived::type ZZ{4};
	//derive_from_Has_type<int> ttt;
	//derive_from_Has_type<float>::type a{5};
	//std::cout << a;
	//A<int> xx;
	//xx.foo();
	//int X{4};
	//MyClass<int> a;
	//MyClass<int>::MyNestedClass b;
	//MyClass<int>::MyNestedClass::Ptr c{&X};
	//MyClass<int>::MyNestedClass::Ptr ptr = &X;
	//MyContainer<int>::MyNestedClass<double>::Pair pair;

	//const int* constPtr = new int;
	//myFunction(constPtr);

        //Magic<signed char> Mag;
	//std::cout << Magic<signed char>::kwpq<float>(2, 3);
	//std::cout << Mag.kwpq<long double>(1.5,56);
}
