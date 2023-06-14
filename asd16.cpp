#include <cmath>
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

struct foo {
    int a;
    int b;
    foo (){
        std::cout << "default constructor\n";
    };
    foo (const foo& l): a(1) {
        std::cout << "copy constructor\n";
    };
    foo (std::initializer_list<foo> l): b(2), a(l.begin()->a) {
    //foo (std::initializer_list<foo> l) {
        std::cout << "list initializer\n";
    };
    ~foo() = default;

};
int main(){
    foo c;
    foo b{c};
    std::cout << b.b << '\n';
    std::cout << b.a << '\n';

  //  const foo a[1] = {foo{c} };
 //   foo b(std::initializer_list<foo>(a, a+1));
 /*
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
[4:03:07 PM] ← ShenMian1 has left (Ping timeout: 272 seconds)
[4:04:41 PM] → ShenMian1 has joined
[4:04:43 PM] ← ShenMian has left (Ping timeout: 246 seconds)
[4:04:43 PM] ⓘ ShenMian1 is now known as ShenMian
[4:06:07 PM] ← ShenMian2 has left (Ping timeout: 246 seconds)
[4:06:33 PM] <PJBoy> { new (new char[sizeof(X)]) X; } struct X { X() { this->~X(); } }; // this is the same demo right?
[4:06:53 PM] <PJBoy> except that it leaks a char buffer
[4:07:48 PM] <PJBoy> I would assume calling the dtor in the ctor isn't well defined
[4:08:11 PM] <PJBoy> on the grounds that a dtor expects an object that has completed initialisation
[4:08:20 PM] <Eelis> then it's not the same demo, because mine doesn't call a dtor
[4:08:59 PM] <PJBoy> oh duh
[4:09:09 PM] <PJBoy> for some reason I thought the delete statement would do that
[4:09:41 PM] <PJBoy> hm, storage being acquired is part of the necessary condition for an object to start its lifetime
[4:10:03 PM] <PJBoy> if a ctor doesn't start an object's lifetime, that sounds like UB potential
[4:11:59 PM] ← lxsameer has left (Ping timeout: 272 seconds)
[4:12:20 PM] ← faLUKE has left (Ping timeout: 252 seconds)
[4:13:06 PM] <PJBoy> funnily enough, there's a point explicitly allowing your delete statement
[4:14:31 PM] ← troydm has left (Ping timeout: 272 seconds)
[4:14:38 PM] <zxd> ville: in line 13: foo (const foo&l) :a(1) {   shouldn't 'b' object type of foo  be already created and assigned value of  1 to it's member 'int a;'   that value is gone after it's down with the list_initializer constructor
[4:15:09 PM] ← smilzo has left (Ping timeout: 272 seconds)
[4:15:16 PM] ← m_tadeu has left (Ping timeout: 252 seconds)
[4:15:28 PM] <zxd> s/down/done
[4:16:52 PM] ← wib_jonas has left (Ping timeout: 260 seconds)
[4:17:00 PM] ← stefanos82 has left (Quit: Leaving)
[4:17:08 PM] <PJBoy> well I don't see any wording that says you can't deallocate the storage of an object before the ctor finishes
[4:17:21 PM] → faLUKE has joined
[4:17:34 PM] <PJBoy> so I think it might well be an example of a ctor that doesn't start an object's lifetime
[4:18:15 PM] → kts has joined
[4:21:01 PM] → Unicorn_Princess has joined
[4:22:39 PM] → jfsimon1981_b has joined
[4:23:22 PM] <Eelis> then i guess it might be another illustration of the principle that it's virtually impossible to make reasonable statements about C++ that don't have some gross exceptions :)
[4:24:04 PM] ← jfsimon1981 has left (Ping timeout: 252 seconds)
[4:24:13 PM] <PJBoy> and I love that
[4:24:17 PM] → jfsimon1981 has joined
[4:24:25 PM] <PJBoy> it's a real hacker's language
[4:25:26 PM] → wib_jonas has joined
[4:27:36 PM] <Eelis> not hard to deal with i guess, just always qualify reasonable statements with "generally" or "typically"
[4:28:24 PM] <ville> zxd: your std::initializer_list constructor doesn't initialize a
[4:33:11 PM] <ville> zxd: going back to: https://godbolt.org/z/xjb6jhWx7 do you understand that line 24 causes the language to synthesize a: foo array[1] = {c};?
[4:34:17 PM] <ville> zxd: the foo object in the synthesized array was copy constructed. its .a was initialized to 1
[4:36:14 PM] <ville> zxd: continuing to process line 24 an std::initializer_list object is then created with possibly foo* begin = array; foo* end = array + 1; and that std::initializer_list object is then passed on to the ctor on lin e16
[4:36:18 PM] ← gas51627 has left (Quit: Connection closed for inactivity)
[4:36:40 PM] <zxd> ville: yes the link you sent me says 'const foo array[1] = {foo{c} }; then foo b(std::initializer_list<foo>(array, array+1));  ?
[4:37:00 PM] <zxd> ville:https://eel.is/c++draft/dcl.init#list-5
[4:37:07 PM] <ville> zxd: your ctor on line 16 does nothing with the std::initializer_list it was given, and leaves the .a member uninitialized. it does initialize b to 2
[4:37:37 PM] <ville> zxd: so line 26 you print out a value read from uninitialized memory
[4:37:49 PM] <ville> zxd: right
[4:39:17 PM] <ville> zxd: anyway so there is no way that the a(1) value from the object in the synthesized array gets into your object c on line 24
[4:41:10 PM] ← interop_madness has left (Quit: Leaving)
[4:41:16 PM] ← invalidopcode has left (Remote host closed the connection)
[4:41:33 PM] → invalidopcode has joined
[4:44:35 PM] → Autowired has joined
[4:46:26 PM] → tradar has joined
[4:46:38 PM] ← sedzcat has left (Ping timeout: 260 seconds)
[4:47:56 PM] <zxd> ville: "zxd: continuing to process line 24 an std::initializer_list object is then created with possibly foo* begin = array; foo* end = array + 1; and that std::initializer_list object is then passed on to the ctor on lin e16"  when that std::initalizer_list object is passed to ctor on line 16  does it not have .a saved with 1 ?
[4:49:59 PM] <zxd> ah  I see never mind
[4:50:00 PM] <zxd> ok
[4:50:30 PM] <zxd> i am responsible for copying the .a myself inside the contructor of initalizer_list
[4:50:53 PM] <zxd> initializer_list*
[4:51:03 PM] ← T`aZ has left (Ping timeout: 260 seconds)
[4:52:45 PM] → T`aZ has joined
[4:53:46 PM] → lxsameer has joined
[4:56:20 PM] ← lh_mouse_ has left (Read error: Connection reset by peer)
[4:56:32 PM] ← immibis_ has left (Remote host closed the connection)
[4:56:33 PM] ← notrnix has left (Read error: Connection reset by peer)
[4:57:43 PM] → lh_mouse has joined
[4:58:01 PM] <zxd> if I do  "foo (std::initializer_list<foo> l): b(2), a(l.begin()->a) {"   on line 16 it works */
}
