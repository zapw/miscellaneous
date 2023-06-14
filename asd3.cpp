#include <iostream>
#include <memory>
#include <initializer_list>


struct foo {
	int a;
	int b;
	foo () {
		std::cout << "Wtf\n";
	};
	foo& operator=(const foo& l){
		std::cout << "double \n";
		return *this;
	};
	//foo& operator=(foo&& l){
	//	std::cout << "quadruplo \n";
	//	return *this;
	//}; 
	//foo (const foo& l): a(1) {
	//	std::cout << "aaa\n";
	//};
	//foo (foo&& l){
	//	std::cout << "triple  move \n";
	//};
	//foo (std::initializer_list<foo> l): b(2) {
	//	std::cout << "listed list\n";
	//};
	~foo() = default;
};

struct fooa {
	fooa () {
		std::cout << "eat shit and die\n";
	};
	operator foo(){
		std::cout << "humus is good yea?\n";
		return foo();
	}
};

int Damn() {
	int x = 7;
	return x; 
}
struct S { int x:3; };
struct X {int x {5};};

void fooByVal(std::string str){
	str[3] = 'L';
	std::cout << str << '\n';
}

int main(void){
	std::string Sl {"FUCKVIOLENT"};
	fooByVal(std::move(Sl));
	//std::cout << Sl << '\n';
	//std::cout << Sl << '\n';
	//foo ll = fooa();
	//foo a;
//	Damn() = 5;
	//[5:53:21 PM] <zxd> Alipha: any difference between   foo a{arg}  and  foo a = {arg}
//[6:14:43 PM] <Alipha> zxd: the latter won't participate in implicit conversions, but otherwise, they're the same
	//std::unique_ptr<int> p = {new int};
	//std::unique_ptr<int> p  {new int};
	//foo b = {a};
	//b = a;
	foo c;
	//foo b = {foo(),foo()};
	foo b{std::move(c)};
	//std::cout << b.b << '\n';
	//std::cout << b.a;
	//foo b {};
	//foo b = { 5,5  };
	//foo b = { std::move(a)};
	//foo() = foo();
	//b =  foo();
	//foo(foo(A));
	//X x;
	//X x2 = X{x};
	//std::cout << x2.x << '\n';
	//foo c = foo{foo()};
	//int&& var1 = 5;
	//auto& var2 = var1;
	//std::cout << &"c++";
//	int x[100000000];
//	int* p = new int[100000000];
//	delete[] p;	
//	#include <iostream>
  
    // Declaring a pointer to store address
    // pointing to an array of size 3
    int(*p)[3];
  
    // Define an array of size 3
    int a[3] = { 1, 2, 3 };
    std::cout << sizeof(a) << '\n'; 
    // Store the base address of the
    // array in the pointer variable
    p = &a;
    std::cout << sizeof(*p) << '\n'; 
  
    // Print the results
    for (int i = 0; i < 3; i++) {
	    std::cout << *(*(p) + i) << " ";
    }
    foo OO;
    foo DD{OO};
    //DD = std::move(OO);
    //DD = OO;
  
}

/*

[5:32:12 PM] <zxd> Alipha: and it can also use uniform initialization?  T b {T()}  any difference?
[5:32:20 PM] <zxd> other than no type conversion

[5:35:16 PM] <Alipha> { B x{B(B(B(B())))}; } using tracked::B;
[5:35:17 PM] <geordi> B0* B0~

[5:38:13 PM] <zxd> what is tracked ? f  B0~  destructor ?
[5:39:04 PM] <Alipha> It's a feature of geordi. tracked::B is a class which prints out all its constructions, destructions, and assignments

[5:40:22 PM] <Alipha> { B x, y; x = std::move(y); x = y; } using tracked::B;
[5:40:23 PM] <geordi> B0* B1* B1=>B0 error: tried to assign from pillaged B1. Aborted
[5:40:48 PM] <Alipha> Oh, fancy. It doesn't let you move from objects which have already been moved from
[5:41:04 PM] <Alipha> { B x, y, z; x = std::move(y); x = z; } using tracked::B;
[5:41:05 PM] <geordi> B0* B1* B2* B1=>B0 B0=B2 B2~ B1~ B0~

[5:42:18 PM] <Alipha> Anyway, I believe there's a rule in the standard where anything of the form T(T(args)) is equivalent to T(args)


[5:43:01 PM] <Alipha> The standard really seems to remove moves wherever possible, heh


[3:27:05 PM] <zxd> hi,  in  https://godbolt.org/z/xjb6jhWx7  why  is  foo b{c}; calling the "copy constructor" before "list_initializer constructor"  and also why the initalization from the copy constructor   :a(1)  is not being saved ... ?
[3:28:50 PM] ← ShenMian has left (Ping timeout: 268 seconds)
[3:28:51 PM] ⓘ ShenMian1 is now known as ShenMian
[3:32:56 PM] <Oxyd> First it copies c into an initializer_list<foo>, and then constructs b using the initializer_list it just created.
[3:35:37 PM] → Karyon has joined
[3:36:13 PM] <ville> zxd: https://eel.is/c++draft/dcl.init#list-5
[3:38:13 PM] <ville> Oxyd: the std::initializer_list does not have any elements of type foo. see above
[3:39:17 PM] <Oxyd> Eh? How does that say it doesn't have any elements of type foo?
[3:39:22 PM] <ville> if an std::initializer_list overload is picked first an array-of-N-T is made, an std::initializer_list<T> is then made probably holding T* b, e;, and that's then passed on
[3:40:00 PM] <Oxyd> Well okay. Then this hidden array contains the foo which is copy initialised.
[3:40:54 PM] <ville> yes
[3:43:06 PM] ← CatCow has left (Quit: Textual IRC Client: www.textualapp.com)
[3:43:42 PM] ← Starhowl has left (Quit: Going offline, see ya! (www.adiirc.com))
[3:47:04 PM] → ShenMian1 has joined
[3:49:54 PM] ← ShenMian has left (Ping timeout: 260 seconds)
[3:50:31 PM] → ShenMian has joined
[3:51:33 PM] ← ShenMian1 has left (Ping timeout: 260 seconds)
[3:51:43 PM] ← kts has left (Quit: Leaving)
[3:53:07 PM] <zxd> what happens in the first instance of 'b' in the copy constructor it isn't created yet? even though the contructor is executed
[3:56:41 PM] <ville> can't parse the question
[3:57:15 PM] <ville> presumably https://godbolt.org/z/xjb6jhWx7 but which line?
[3:57:32 PM] → Allio84 has joined
[3:57:51 PM] <zxd> line 13:  foo (const foo& l): a(1) {
[3:57:54 PM] <zxd> it is executed first
[3:57:54 PM] <ville> if a ctor finishes then the object exists
[3:57:57 PM] → ShenMian1 has joined
[3:58:27 PM] <zxd> I mean before list_initalizer
[3:59:39 PM] ← ShenMian has left (Ping timeout: 252 seconds)
[3:59:55 PM] <ville> perhaps this helps https://godbolt.org/z/53n5PcTob
[4:00:17 PM] → ShenMian has joined
[4:00:37 PM] <ville> or this: https://godbolt.org/z/q448EjKeE
[4:01:09 PM] <Eelis> { char * p = new char[sizeof(X)]; new (p) X(p); } struct X { X(char * p){ delete[] p; } }; // i wonder if this is a counterexample to the notion that if a ctor finishes, the object exists
[4:01:16 PM] <ville> line 25 is how the language desugars the call to an std::initializer_list ctor
[4:01:28 PM] <ville> Eelis: if only it wasn't decrypted
[4:01:46 PM] <Eelis> i don't see any encryption going on
[4:01:57 PM] → ShenMian2 has joined
[4:02:07 PM] <ville> you've used the jam-crap-on-one-line encryption. can't be beat
[4:02:34 PM] <Eelis> oh right, this is your "i can't read a line of more than 40 chars of C++" position
[4:02:43 PM] <Eelis> bit weird, but you do you :)
[4:02:43 PM] → proller has joined
[4:02:45 PM] <ville> i can. i won't

 */

