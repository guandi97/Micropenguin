#include <iostream>
#include <string>
#include <thread>

using namespace std;

struct func
{
	int& i;
	
	func(int& i_) : i(i_) {}

	void operator()()
	{
		for (int i = 0; i < 5; i++)
			cout << "Engie BACON!" << endl;
	}
};

class thread_guard
{
	thread& t;

public:
	explicit thread_guard(thread& t_) : t(t_){}   //Constructor

	~thread_guard()            //Destructor 
	{
		if (t.joinable())
		{
			t.join();
		}
	}
};

class task
{
public:
	
	void operator()(string& msg){
		cout << "T1 says: " << msg << endl;
		 msg = "Pyros FTW";
		//cout << &msg << endl;
	}

};

class scoped_thread
{
	std::thread t;
public:
	explicit scoped_thread(std::thread t_) :
		t(std::move(t_))
	{
		if (!t.joinable())
			throw std::logic_error("No thread");
	}
	~scoped_thread()
	{
		t.join();
	}
	scoped_thread(scoped_thread const&) = delete;
	scoped_thread& operator=(scoped_thread const&) = delete;
};

void f()
{
	int some_local_state;
	scoped_thread t(std::thread(func(some_local_state)));
}
void function_1(string);



int main()
{
	
	int local = 0;
	func my_func(local);
	thread my_thread(my_func);
	                            //Try Catch block is no longer needed if using RAII (Destructor to call .join())
	/**try
	{
	}
	catch (...)
	{
		my_thread.join();
		throw;
	}
	**/


	my_thread.join();

	
	//Oversubscription -- BAD!
	/**
	cout << std::thread::hardware_concurrency(); //Indication of how many threads can be run concurrently

	
	scoped_thread lawl(thread(function_1, "Lawl"));

	**/
	cin.get();
	return 0;
}


void function_1(string msg)
{
	cout << msg << endl;

}

