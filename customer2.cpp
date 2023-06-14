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


#include "customer.cpp"
#include <iostream>
#include <random>

Customer createCustomer()
{
  // initialize random-number generator for values from 0 to 999:
  static std::default_random_engine rndEngine;
  static std::uniform_int_distribution<int> distr{0, 999};

  // create customers with unique name and 10 random values:
  static int no{0};
  Customer c{"my test customer " + std::to_string(++no)};
  for (int i=0; i<10; ++i) {
    c.addValue(distr(rndEngine));
  }
  return c;  // uses move semantics if not optimized away
}

int main()
{
  std::vector<Customer> customers;
  for (int num=0; num < 8; ++num) {
    customers.push_back(createCustomer());
  }

  std::cout << "customers:\n";
  for (const Customer& cust : customers) {
    std::cout << "  " << cust << '\n';
  }
}

