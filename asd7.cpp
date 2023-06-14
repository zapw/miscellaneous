#include <iostream>

using namespace std;

struct test {
  void operator[](unsigned int) { std::cout << "humus\n"; }
  operator char *() { static char c; std::cout << "chips\n" ; return &c; }
};

struct testa {
  template<typename T>
  operator T*() { std::cout << "pointer converstion\n" ; return 0; }
};

template <typename Thumus>
void cheese ( Thumus a) {
	std::cout << a;
}
int main() {
  test t; t[0]; // ambiguous
		//
  void *pv = testa();
  bool *pb = testa();
  cheese(222);

} 
/*
[7:11:11 PM] <zxd> I see t[0]; only calls void operator[](unsigned int) { }
[7:11:23 PM] <zxd> one parameter
[7:12:28 PM] <Eelis> nonstatic member functions have an implicit this parameter
[7:16:09 PM] <Alipha> char *p = new char[10]; p[0] = 'a';  // `p[0]` is calling the built-in operator[] with two operands, `p` and `0`. you can imagine as if there's a global function `char& operator[](char *ptr, int i)` which this is calling 
[7:16:57 PM] <Alipha> i.e., you can imagine `p[0] = 'a';` is the same as `operator[](p, 0) = 'a';`
[7:17:12 PM] <Alipha> `x + y` is the same as `operator+(x, y)`
[7:18:32 PM] ← bionade24 has left (Remote host closed the connection)
[7:18:37 PM] <Alipha> you can't actually type `operator[](p, 0) = 'a';` because using that syntax isn't allowed for operators of built-in types
[7:19:01 PM] <Alipha> { std::string x = "hello "; std::string y = "world"; std::cout << operator+(x, y); }
[7:19:02 PM] <geordi> hello world
[7:20:10 PM] <Alipha> and operator[] has the further restriction that it _must_ be a member function and not a global function.
[7:20:29 PM] <Alipha> { std::string str = "hello"; std::cout << str.operator[](1); }
[7:20:30 PM] <geordi> e
[7:21:30 PM] → proller has joined
[7:22:15 PM] <Alipha> but you can think of calling member functions, e.g., `str.operator[](1)`, as having an implicit `this` parameter, as Eelis mentioned, and so `str.operator[](1)` is effectively calling operator[] with two parameters, `str` and `1`, it's just `str` is passed in as `*this`
[7:23:50 PM] ← jsbach has left (Ping timeout: 260 seconds)
[7:26:44 PM] ← fluter has left (Ping timeout: 248 seconds)
[7:27:00 PM] <Alipha> And my apologies for writing T instead of t in my original statement. My phone autocorrected on me.
[7:27:17 PM] <Alipha> <Alipha> Yeah, in t[0], t is the first parameter and 0 is the second
*/
