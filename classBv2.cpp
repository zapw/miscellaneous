class B {
	int b{2};
	int c{3};
	public:
	B(int a);
};


B::B(int a): c(a) {
      b = 1+c;
};
