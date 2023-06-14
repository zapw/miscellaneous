#include <iostream>

template <typename T>
class Engine {
  public:
    void start() {
    static_cast<T*>(this)->startImpl();
    }
};

class Car {
  public:
    void startImpl() {
      std::cout << "Engine started" << std::endl;
    }
};

class MyCar : public Car, public Engine<MyCar> {};

int main(){
	MyCar car;
	car.start();
	Engine<MyCar>* encar = &car;
	encar->start();
}
