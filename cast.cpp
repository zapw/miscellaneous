#include <iostream>

struct A {
	int b {1};
	virtual void print(){
		std::cout << b << '\n';
	}
};

struct C {
	int a {2};
	virtual void print(){
		std::cout << a << '\n';
	}
};

struct B : public A, public C {
	int c {3};
	void print() override {
		std::cout << "B:" << c+a+b << '\n';
	}
};

int main(){
	A aa;
	B bb;
	C cc;
	B *bbbx = static_cast<B*>(&cc);
	//B *bbbx = &cc;
	C *bbx = &bb;
	std::cout << bbx << '\n';
	std::cout << &bb << '\n';
	bb.print();
	bbx->print();

	
}
/*
 * … you’ll need to call the constructor manually:

  struct A a;
  A_A(&a);  // call constructor manually!



  struct C c;
  C_c(&c);  // call constructor manually!


a->print(a);
b->print(b);
c->print(c);

[5:55:06 PM] <zxd> https://godbolt.org/z/8TYdE3E4Y  I am confused of how with virtual functions I am able to access the members of the objects  B and A after upcasting from   from B to  C , in my head  C is a suboject of B so it shrunk after the cast, the address was of "bbx" was changed and it should know not be able to access address of the whole object "b" to reach its members... ?
[5:56:13 PM] <zxd> s/was//
[5:56:14 PM] <rpav> zxd: you're not upcasting _values_, which would be a problem, you're casting _pointers_
[5:56:18 PM] → GreenResponse has joined
[5:56:53 PM] → nohat has joined
[5:57:30 PM] → DEEPAKs has joined
[5:58:33 PM] <rpav> C* still checks the vtable to find the actual virtual member, because that's how virtuals work
[5:59:28 PM] <Alipha> zxd: you're causing Undefined Behavior. you're lying to the compiler. you're telling the compiler that bbbx points to a B. it does not.
[5:59:49 PM] <rpav> if you cast B to a _value_ C, i.e. object slicing, then in _that_ case "it shrunk" would be accurate .. or more accurately, you made a C copy of the C parts of B
[6:00:10 PM] <rpav> oh, i missed that too, but yes
[6:00:26 PM] <rpav> i should know better than to assume correct code (;
[6:00:53 PM] <Alipha> oh. you're not even using bbbx
[6:01:34 PM] ← caramel has left (Ping timeout: 272 seconds)
[6:01:56 PM] <zxd> Alipha: no I am using bbx   C *bbx = &bb , can ignore bbbx
[6:02:08 PM] ← sord937 has left (Ping timeout: 255 seconds)
[6:03:17 PM] → constxd has joined
[6:03:21 PM] <constxd> hey bros
[6:03:52 PM] ← Bonanno_ has left (Quit: My MacBook has gone to sleep. ZZZzzz…)
[6:04:06 PM] <zxd> bbbx was just experiment, I am using C *bbx  implicit cast
[6:04:23 PM] <constxd> if there is a struct definition like this: struct foo __declspec(dllimport) { double x; std::string s; }
[6:04:32 PM] <zxd> rpav: how do you slice object like that
[6:04:34 PM] <Alipha> zxd: bb is a B object. B contains both a A subobject and C subobject. So, how this is arranged in memory for the B object is that the A subobject is stored first, followed by the C subobject, and then the c member is last. And so, `C *bbx = &bb;` has to do a pointer adjustment to make bbx point to the C subobject inside B. bbx is still pointing into the B object, but its offset is adjusted to point to
[6:04:36 PM] <Alipha> the C part of it
[6:04:44 PM] → sord937 has joined
[6:04:59 PM] ← kts has left (Quit: Leaving)
[6:05:04 PM] <zxd> rpav: don't I need to define a converstion member to tell how to convert to C ?
[6:05:17 PM] <constxd> why do i need to call into the shared library to construct such an object? can't i just generate the code for that on my own? its just a double and a string right
[6:05:24 PM] <rpav> zxd: you do; slicing is generally an error
[6:05:39 PM] → bolovanos has joined
[6:05:39 PM] ← bolovanos has left (Remote host closed the connection)
[6:06:54 PM] <rpav> for some `struct A {..}; struct B : A {..};` that are each copyable, if you have `B b; A* a = &b; std::vector<A> va; va.emplace_back(*a);` you probably broke it
[6:07:36 PM] <rpav> note this is different from `vector<A*>` where you are not inserting the _value_, but still a valid pointer to A or a subclass of A, and no slicing occurs
[6:07:49 PM] <rpav> constxd: this is probably more a #c++-general question
[6:08:17 PM] <Alipha> zxd: https://godbolt.org/z/cvver6P9M
[6:08:44 PM] <Alipha> *slicing is generally a logic error (it's not a compiler error, unfortunately)
[6:24:28 PM] <zxd> rpav: so if I use the `vector<A*>` version where no slicing occurs, `B b; A* a = &b; std::vector<A*> va; va.emplace_back(a);`   like this?  then I need to  convert it back to B* before dereferencing  it so there will be no slicing?
[6:26:06 PM] ← Homer_Simpson has left (Quit: Connection closed for inactivity)
[6:26:13 PM] <BucetaPeluda> gaaah
[6:26:29 PM] ← wib_jonas has left (Quit: Client closed)
[6:26:30 PM] ← Inline has left (Quit: Leaving)
[6:26:37 PM] <BucetaPeluda> Alipha, I hope cppfront doesn't allow slicing
[6:26:57 PM] <Alipha> zxd: no. Slicing only occurs when you're trying to put a derived _object_ into a base _object_. You're only working with pointers there.
[6:27:12 PM] <BucetaPeluda> also avoid these dumb raw pointers. they are only extra work and clutter
[6:27:20 PM] <BucetaPeluda> manage your resources properly
[6:27:56 PM] ← merethan_ has left (Remote host closed the connection)
[6:28:05 PM] <Alipha> You certainly should use raw pointers when what you're pointing to is managed by something else
[6:28:13 PM] → merethan_ has joined
[6:28:42 PM] <BucetaPeluda> almost never
[6:28:50 PM] → Homer_Simpson has joined
[6:28:52 PM] <BucetaPeluda> sometimes an observer_ptr, but it should be rare
[6:29:40 PM] → barometz has joined
[6:32:34 PM] <rpav> zxd: what Alipha said
[6:32:40 PM] <constxd> important question for you experts in here: try { throw std::exception("test"); } catch (const std::exception& e) { cout << "foo"; throw; } catch (...) { cout << "bar" << endl; }
[6:32:41 PM] <Alipha> zxd: the definition of slicing is: copying the base portion of an derived object into a base object, in which case that new base object behaves like a base object and loses the derived behavior.
*/
