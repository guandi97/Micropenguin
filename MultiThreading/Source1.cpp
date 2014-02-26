#include <iostream>
#include <fstream>
#include <thread>
#include <string>
#include <mutex>

using namespace std;

void shared_print(string, int);


//F cannot be accessed outside of LogFile class
class LogFile{
	std::mutex m_mutex;
	ofstream f;

public:
	LogFile()             //Constructor
	{
		f.open("log.txt");
	}

	void shared_print(string id, int value)
	{
		std::lock_guard<mutex> locker(m_mutex);
		f << "From " << id << " : " << value << endl;
	}
	//Never return f to the outside world
	//Never pass f as argument fo user provided function
	
};



void function_1(LogFile& log)
{
	for (int i = 0; i < 100; i++)
		log.shared_print(string("From t1: "), i);
}

int main()
{
	LogFile log;
	thread t1(function_1, ref(log));

	for (int i = 0; i < 100; i++)
		log.shared_print("From main: ", i);


	t1.join();
}


void shared_print(string msg, int id)
{
	cout << msg << id << endl;
}