// C++ program to understand difference between
// pointer to an integer and pointer to an
// array of integers.
#include <iostream>
#include <memory>
using namespace std;

template <class T, int N>
struct Fifo {
  T t;
  Fifo() { std::cout << "hi"; };
};

int main()
{
    // Pointer to an integer
    int *p;
     
    // Pointer to an array of 5 integers
    int (*ptr)[5];
    int arr[5];
     
    // Points to 0th element of the arr.
    p = arr;
     
    // Points to the whole array arr.
    ptr = &arr;
     
    cout << "p =" << p <<", ptr = "<< ptr<< endl;
    p++;
    //ptr++;
    cout << "p =" << p <<", ptr = "<< *ptr + 1 << endl;
    const int Q_SIZE  = 32;
    Fifo<int[32],Q_SIZE> f;
    std::cout << sizeof f << "\n";
    f.t[3] = 3;
    std::cout << f.t[3];
    auto array = std::make_unique<int[]>(22);
     
    return 0;
}
// p =0x61fdf0, ptr = 0x61fdf0
// p =0x61fdf4, ptr = 0x61fe04
// [4:43:20 PM] <Alipha> zxd: you would use const & when the function only needs read-access to the object to achieve the goal. eg, a function like `int count_spaces(const std::string &str);`
[4:43:35 PM] <Alipha> You'd use && when the function would benefit from stealing the resources from the object. eg, `void add_name_to_list(std::vector<std::string> &list, std::string &&name) { list.push_back(std::move(name)); }` This avoids copying name. If you passed by const &, then you'd be forced to copy name since you can't modify name to steal the resources from it.
[4:43:49 PM] <Alipha> However, having an && for a parameter makes things inconvenient when you don't want to move the object. eg, `add_name_to_list(boys, bob);` is not legal; you have to write `add_name_to_list(boys, std::move(bob));` But what if I want to keep my own copy of bob and don't want it stolen? That's annoying. You'd have to do: `add_name_to_list(boys, std::string(bob));` to make a copy which then that copy gets
[4:43:51 PM] <Alipha> passed.
[4:44:05 PM] <Alipha> Instead, I'd recommend just generally avoiding rvalue references and instead, if a function will benefit from stealing the resources from a parameter, just pass it by value: `void add_name_to_list(std::vector<std::string>> &list, std::string name) { list.push_back(std::move(name)); }` You still get the move/stealing benefits of `add_name_to_list(boys, std::move(bob));` but if you want to pass a copy, it's easy:
[4:44:07 PM] <Alipha> `add_name_to_list(boys, bob);`
