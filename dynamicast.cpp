#include <iostream>

static void print_object(const char *name, void *this_, size_t size) {
	int *ugly = reinterpret_cast<int*>(this_);
	size_t i;
	printf("created %s at address %p of size %zu\n", name, this_, size);
	for(i=0 ; i <= size / sizeof(int*) ; i++) {
		printf(" pointer[%zu] == %i\n", i, ugly[i]);
	}
		printf(" pointer[%zu] == %i\n", i, ugly[i]);
		printf(" pointer[%zu] == %i\n", i, ugly[i+1]);
		printf(" pointer[%zu] == %i\n", i, ugly[i+2]);
}

struct A {
	void print();
	int a{87};
	//virtual void print() {
	A() {
		print_object(__FUNCTION__, this, sizeof(*this));
	};

};


void A::print(){
		std::cout << "chips\n";
};

struct B {
	int b{2};
	B(){
		print_object(__FUNCTION__, this, sizeof(*this));
	};
	//virtual void print(){
	//};
};

struct C : public A, public B  {
	int c{99};
	C(){
		print_object(__FUNCTION__, this, sizeof(*this));
	};
	//void print(){
	//};
};


int main(){
	C ccc;
	//A aaa;
	//A* aaa = &ccc;
	//B* aab = &ccc;

	//C* bbp = dynamic_cast<C*>(aab);
	//if (bbp == NULL)
	//	std::cout << "Bad cast";
	//std::cout << bbp->c;
	//ccc.print();
        printf("address of function  is :%p\n", &C::print);
	
}

/*
 * [9:25:14 PM] <zxd> Alipha: tried to fool it with  giving it a pointer type, how does it know to resolve to NULL pointer it tracks the source of the poninter to see if it's from C ?
[9:26:04 PM] ← npaperbot has left (Remote host closed the connection)
[9:26:12 PM] → npaperbot has joined
[9:26:12 PM] ⓘ ChanServ gives voice to npaperbot
[9:27:20 PM] <Alipha> zxd: objects of classes with virtual functions have a vptr, which points to a vtable for that class, which contains information on what the actual class type the object is
[9:28:01 PM] <Alipha> if you remove virtual from your classes, you'll see you'll get an error about it not being a polymorphic type
*/
