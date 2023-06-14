#include <vector>
#include <string>


void preferred_add_name_to_list(std::vector<std::string> &list, std::string name) {
    list.push_back(std::move(name));
}


void fast_add_name_to_list(std::vector<std::string> &list, std::string &&name) {
    list.push_back(std::move(name));
}

void fast_add_name_to_list(std::vector<std::string> &list, const std::string &name) {
    list.push_back(name);
}


int main() {
    std::vector<std::string> boys;
    std::string bob;

    preferred_add_name_to_list(boys, std::move(bob));  // moves bob into name, then moves name into list                     (0 copies, 2 moves)
    preferred_add_name_to_list(boys, bob);             // copies bob into name, then moves name into list.                   (1 copy,   1 move )

    fast_add_name_to_list(boys, std::move(bob));       // calls `std::string &&` overload, which moves name into list        (0 copies, 1 move )
    fast_add_name_to_list(boys, bob);                  // calls `const std::string &` overload, which copies name into list  (1 copy,   0 moves)

    // Comparing the corresponding preferred_add_name_to_list to the fast_add_name_to_list calls,
    // using preferred_add_name_to_list has one additional move. however, that's almost always fine, as moves are supposed to
    // be cheap.
    //
    // And so, unless getting rid of that extra move is actually "performance critical", then just write 1 function which
    // passes by value, instead of having to duplicate your code in order to write both `const std::string &` and `std::string &&` overloads.

    // I suppose you could only write a single `fast_add_name_to_list(std::vector<std::string> &list, std::string &&name)` function and
    // not provide a `const std::string &` overload, but then if callers don't want their object moved-from, they'd have to call it like:

    fast_add_name_to_list(boys, std::string(bob));      // copy from bob to temporary, then moves name into list.             (1 copy,   1 move )

    // While that's not the worst thing in the world, that's just not convention and people would think that code is weird.
}
