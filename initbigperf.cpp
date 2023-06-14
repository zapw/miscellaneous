//********************************************************
// The following code example is taken from the book
//  C++ Move Semantics - The Complete Guide
//  by Nicolai M. Josuttis (www.josuttis.com)
//  http://www.cppmove.com
//
// The code is licensed under a
//  Creative Commons Attribution 4.0 International License
//  http://creativecommons.org/licenses/by/4.0/
//********************************************************


#include <string>
#include <array>
#include <iostream>
#include <cstdlib>   // for std::atoi()
#include <chrono>
#include <map>

//********************************************************
// the 3 approaches to initialize a Person
// with a big member where move is not possible:
//********************************************************

namespace bigclassic {
  class Person {
   private:
    std::string name;
    std::array<double, 10000> values;
   public:
    Person(const std::string& n, const std::array<double, 10000>& v)
     : name{n}, values{v} {
    }
    //...
  };
} // namespace bigclassic


namespace bigall {
  class Person {
   private:
    std::string name;
    std::array<double, 10000> values;
   public:
    Person(const std::string& n, const std::array<double, 10000>& v)
     : name{n}, values{v} {
    }
    Person(const std::string& n, std::array<double, 10000>&& v)
     : name{n}, values{std::move(v)} {
    }
    Person(std::string&& n, std::array<double, 10000>& v)
     : name{std::move(n)}, values{v} {
    }
    Person(std::string&& n, std::array<double, 10000>&& v)
     : name{std::move(n)}, values{std::move(v)} {
    }
    Person(const char* n, const std::array<double, 10000>& v)
     : name{n}, values{v} {
    }
    Person(const char* n, std::array<double, 10000>&& v)
     : name{n}, values{std::move(v)} {
    }
    //...
  };
} // namespace bigall


namespace bigmove {
  class Person {
   private:
    std::string name;
    std::array<double, 10000> values;
   public:
    Person(std::string n, std::array<double, 10000> v)
     : name{std::move(n)}, values{std::move(v)} {
    }
    //...
  };
} // namespace bigmove


//********************************************************
//********************************************************

// measure num initializations of whatever is currently defined as Person:
template<typename PersonT>
std::chrono::nanoseconds measure(int num)
{
  std::chrono::nanoseconds totalDur{0};
  for (int i = 0; i < num; ++i) {
    std::string name = "a name a bit too long for SSO";
    std::array<double, 10000> arr{0, 8, 15, 42, 33, 77};

    // measure how long it takes to create 3 Persons in different ways:
    auto t0 = std::chrono::steady_clock::now();
      //PersonT p1{"a name way too long for SSO", {0, 8, 15, 42, 33, 77}};
      //PersonT p2{name, arr};
      PersonT p3{std::move(name), std::move(arr)};
    auto t1 = std::chrono::steady_clock::now();
    totalDur += t1 - t0;
  }
  return totalDur;
}

//********************************************************
// main():
//********************************************************

int main(int argc, const char** argv)
{
  int num = 1000;
  if (argc > 1) {
    num = std::atoi(argv[1]);
  }

  // a few iterations to make the CPU hot:
  measure<bigclassic::Person>(num / 10);

  std::map<std::string, std::chrono::duration<double,std::milli>> data;
  int numLoops = 10;
  for (int i = 0; i < numLoops; ++i) {
    // measure:
    data["a: bigclassic:    "] += measure<bigclassic::Person>(num/numLoops);
    //data["b: bigall:        "] += measure<bigall::Person>(num/numLoops);
    //data["c: bigmove:       "] += measure<bigmove::Person>(num/numLoops);
  }
  for (const auto& d : data) {
    std::cout << "  " << d.first << d.second.count() / numLoops << "ms\n";
  }
}
