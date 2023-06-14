[5:56:12 PM] <Alipha> zxd: when compiled, non-virtual member functions are basically just global functions with a special naming convention and a secret `this` parameter. virtual functions are also basically just global funcitons with a special naming convention too, except that each C object stores a hidden vptr to a vtable, which that vtable then has pointers to all the virtual functions (so each C object has the
[5:56:14 PM] <Alipha> overhead of only one additional pointer, no matter how many virtual functions C has)
[5:56:25 PM] <Alipha> (in a typical c++ implementation)
[6:24:58 PM] <BurumaSerafuku> Alipha: never saw anything different than that
[6:28:20 PM] <Alipha> Indeed. That was just my disclaimer of: the standard doesn't say anything about how this shall be implemented
[6:29:17 PM] <BurumaSerafuku> how else we gonna tell on what instance the methods are operating on? how else we gonna tell what is the actual virtual method that is being called?
[6:29:23 PM] ← micttyl has left (Quit: leaving)
[6:29:34 PM] <BurumaSerafuku> fap fap fap
[6:32:15 PM] <Alipha> Have each virtual function be a separate pointer in the object
[6:33:21 PM] ← rgrinberg has left (Quit: My MacBook has gone to sleep. ZZZzzz…)
[6:37:52 PM] <Eelis> one could also imagine an implementation where vtables are assigned a 32 bit id and objects of polymorphic types store one of those ids instead of a vtable pointer
[6:39:05 PM] <Eelis> after all, how many programs have more than 4 billion vtables
[6:41:29 PM] <chris64> using the same id you could also add non-RTTI type checking and casting, like LLVM does
[6:42:47 PM] <chris64> Eelis: would you require a unique memory location for the vtables to be stored in order to allow looking them up?
[6:43:33 PM] <chris64> I always wondered how one could extend a variant by some runtime constructs and now this sounds like a reasonable approach
[6:43:40 PM] ← manx has left (Ping timeout: 252 seconds)
[6:43:43 PM] → rgrinberg has joined
[6:43:48 PM] <chris64> *extend a variant at runtime
[6:44:15 PM] → manx has joined
[6:44:15 PM] <chris64> at least, if the additional types fit in the size..
[7:01:56 PM] <Alipha> chris64: i wrote this: https://github.com/alipha/cpp/tree/master/poly_obj where you can have a `liph::poly_obj<shape, 16> s; s = circle();` and s can hold any object derived from shape as long as it's <= 16 bytes in size
[7:33:37 PM] <chris64> Alipha: wow, I'll have a look!
[7:39:10 PM] <Alipha> chris64: yeah, so it's a "polymorphic object", which has copy/move semantics (e.g., `t = s;` would make a copy of the circle object) and doesn't perform any dynamic allocation. an extra pointer is stored in each poly_obj so that it knows how to copy/move the object it holds (ie, so it knows what the derived type is)
[7:40:09 PM] <chris64> Alipha: ah, is this pointer the `behavior_def<Base> *vptr;`?
[7:40:18 PM] <Alipha> yes
[7:40:30 PM] <chris64> cool
[7:41:31 PM] <Alipha> chris64: i have an intrusive_poly_obj class too, which doesn't have that pointer overhead, but it requires you to modify your class to provide virtual copy_to and move_to functions: https://github.com/alipha/cpp/blob/master/intrusive_poly_obj/example.cpp#L9-L10
[7:43:10 PM] <chris64> Alipha: and copy_to and move_to get implemented by `implement_poly_obj`?
[7:43:17 PM] <Alipha> yep
[7:43:42 PM] <Alipha> also, poly_obj allows for "null objects", while intrusive_poly_obj doesn't
[7:43:52 PM] <chris64> null as in empty?
[7:44:04 PM] <chris64> lots of food for thought :-)
[7:44:31 PM] <Alipha> yeah. as in, it's UB to try to access members of a null/empty object
[7:50:05 PM] <chris64> your code is really pleasant to read
[7:51:06 PM] ← teemperor has left (Remote host closed the connection)
[7:52:14 PM] <Alipha> thanks
