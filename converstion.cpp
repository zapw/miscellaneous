#include "iostream"


struct aa {
    aa(int, int) {
    }
    
    int x;
    int y;
};


struct bb {
    bb(aa const&) {
    }
};


auto main() -> int {
    {
        aa(aa{0, 1});
        aa({0, 1});
    }
    {
        bb({0, 1});
    }
    return 0;
}
