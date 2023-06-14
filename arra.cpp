#include <iostream>
template<typename T> 
void myfunc(T& t1, T& t2) {
	std::cout << t1;
};


void myfuncD(int (*t1)[5],int (*t2)[5]){
	//std::cout << *(t1+1);
}

int A1[5] = {99,98,2,0,44}, A2[5] = {22};

int main(){
   myfuncD(&A1, &A2);
   const int n{33};
   constexpr int a[n] = {1};
   std::cout << a[0];
}
