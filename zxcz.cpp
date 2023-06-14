#include <cassert>
#include <iostream>

template<class...A, class...B> void func(A...arg1,int sz1, int sz2, B...arg2)  
{
   assert( sizeof...(arg1) == sz1);
   assert( sizeof...(arg2) == sz2);
}

class Point
{
private:
    double m_x{};
    double m_y{};
    double m_z{};

public:
    Point(double m_x=5.0, double y=0.0, double z=0.0)
      : m_y{y}, m_z{z}
    {
    }

    double getX() const { return m_x; }
    double getY() const { return m_y; }
    double getZ() const { return m_z; }
};

auto C(int){}

template<typename...Ts> void fun(Ts &&...){ std::cout << "dd"; }

int main(void)
{
   //A:(int, int, int), B:(int, int, int, int, int) 
   func<int,int,int>(1,2,3,3,5,1,2,3,4,5);

   //A: empty, B:(int, int, int, int, int)
   func(0,5,1,2,3,4,5);
   
   C(3);
   int x {5};
   fun(x);

   const int& r3 {3};

   Point point;

   std::cout << "Point(" << point.getX();
   return 0;


}
/*


why when using a variadic template with r-value reference: template<typename...Ts> void fun(Ts &&...){ std::cout << "dd"; }   I can call it with fun(x)  where x is lvalue of type int, but when without template: void fun(int &&){ std::cout << "dd"; }   it gives error
 error: cannot bind rvalue reference of type 'int&&' to lvalue of
type 'int'
    fun(x);
_
_PJBoy 16:47:01
!fs forwarding reference
N
+nolyc 16:47:02
T&& where T is deduced (or auto&&) is a 'forwarding reference' (aka 'universal reference'). Regarding the name, the committee thinks of for(auto && x : c) as forwarding container elements to the loop body.
_
_PJBoy 16:48:03
meh
point is your first declaration had forwarding references, not rvalue references
Z
zxd 16:48:29
ok that's the name they gave it to this 'thing' now I look for what forwading reference means
_PJBoy: when T is deduced it gives it a completly different meaning of parsing ?
_
_PJBoy 16:49:48
depends on your perspective
A
Alipha 16:50:05
zxd: the fact T&& can bind to an lvalue or rvalue is a result of reference collapsing rules: https://en.cppreference.com/w/cpp/language/reference#Reference_collapsing
_
_PJBoy 16:50:44
if T is `const U&`, then `T&&` is `const U&`; if T is `U`, then `T&&` is `U&&`
so in that sense, parsing is completely consistent

_PJBoy 16:51:28
the magic is in the fact that `T` can be deduced to a reference type
A
Alipha 16:51:33
{ foo(3); int x=3; foo(x); } template<typename T> void foo(T&&) { BARK; }
G
+geordi 16:51:41
foo(T&&) [with T = int] foo(T&&) [with T = int&]
 * 
 */
