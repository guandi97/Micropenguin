#include "Header.h"

#define DEBUG


class some_data
{
	int a;
	std::string b;
public:
	some_data() : a(2)
	{}
	void do_something()
	{
		cout << "Inside!";
	}
	void setA(int input)
	{
		a = input;
	}
	void displayA()
	{
		cout << a << endl;
	}
};

class data_wrapper
{
private:
	some_data data;
	std::mutex m;
public:
	template<typename Function>
	void process_data(Function func)
	{
		std::lock_guard<std::mutex> locker(m);
		func(data);
	}
};


some_data * unprotected = new some_data;  //create pointer to some_data object

void malicious_function(some_data& protected_data)
{
	protected_data.setA(1);
	unprotected = &protected_data;
}

data_wrapper x;

void foo()
{
	x.process_data(malicious_function);
	unprotected->do_something();
	//unprotected->displayA();
#ifdef DEBUG 
	unprotected->displayA();
#endif

}