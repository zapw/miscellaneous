struct B { 
    virtual void foo() { BARK; }
 };

struct D : B { 
    void foo() { BARK; }

}; 

struct D2 : D {
    void foo() { BARK; } 

}; 

D *d = new D2;

d->foo(); 
<geordi> D2::foo()




struct B { 
   void foo() { BARK; } 
}; 
struct D : B { 
   void foo() { BARK; }
}; 

struct D2 : D {
   void foo() { BARK; }
};

D *d = new D2;
d->foo(); 
 D::foo()
