#include <iostream>
#include <string>
#include <thread>
#include <vector>

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
void function_1(string);

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

	thread_guard(thread_guard const&) = delete;      //Makes sure the compiler does not provide a copy constructor by default. THIS IS IMPORTANZZZZ!!! :D
	thread_guard& operator=(thread_guard const&) = delete;
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
	std::vector<std::thread> threads;
	for (int i = 0; i < 20; i++)
	{
		threads.push_back(thread(function_1, "Engie FTW!"));
	}

	for (int i = 0; i < 20; i++)
	{
		threads[i].join();
	}

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

	f();

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

