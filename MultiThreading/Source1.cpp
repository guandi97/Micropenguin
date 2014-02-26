#include <iostream>
#include <fstream>
#include <thread>
#include <string>
#include <mutex>
#include "Header.h"

using namespace std;

void shared_print(string, int);


void function_1(LogFile& log)
{
	for (int i = 0; i < 100; i++)
		log.shared_print(string("From t1: "), i);
}


//Launch lots of threads and all share the same data
//Not thread safe :(
void function_2(stack& st)
{
	int v = st.top();
	st.pop();
	process(v);
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