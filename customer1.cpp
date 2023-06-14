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
#include <utility>  // for std::move()

int main()
{
  // create a customer with some initial values:
  Customer c{"Wolfgang Amadeus Mozart" };
  for (int val : {0, 8, 15}) {
    c.addValue(val);
  }
  std::cout << "c: " << c << '\n';    // print value of initialized c

  // insert the customer twice into a collection of customers:
  std::vector<Customer> customers;
  customers.push_back(c);             // copy into the vector
  customers.push_back(std::move(c));  // move into the vector
  std::cout << "c: " << c << '\n';    // print value of moved-from c

  // print all customers in the collection:
  std::cout << "customers:\n";
  for (const Customer& cust : customers) {
    std::cout << "  " << cust << '\n';
  }
}

