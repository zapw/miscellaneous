#include <iostream>
#include <thread>
#include <fstream>

thread_local int my_variable = 0;


void my_function(const char* n)
{
    std::string str = "./output";
    str += n;
    const char* file = str.c_str();
    std::ofstream outfile(file);
    my_variable++;
    outfile << my_variable << " " << std::this_thread::get_id(); //my_variable; //<< " (thread ID = " << std::this_thread::get_id() << ")\n";
}

int main()
{
    std::thread t1(my_function,"1");
    std::thread t2(my_function,"2");
    t1.join();
    t2.join();
    return 0;
}
