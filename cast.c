struct A {
	int a;
};


struct B {
	double b;
};


int main(){
        struct B foo;
	struct B* test = &foo;
        struct A* fooX = (struct A*)test;
	return 0;
}
