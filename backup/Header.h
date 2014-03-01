#ifndef Header
#define Header
#include <mutex>
#include <fstream>
using namespace std;


class stack {

public:
	void pop();      //pop off item on top of stack
	int& top();      //returns item on the top of stack

private:
	int* _data;
	mutex _mu;
};

//F cannot be accessed outside LogFile. It is protected!!
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


#endif