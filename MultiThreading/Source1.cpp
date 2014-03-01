#include <iostream>
#include <fstream>
#include <thread>
#include <string>
#include <mutex>

#include "Header.h"
#include "Malicious.h"
#include "thread_safe.h"

using namespace std;

void shared_print(string, int);
void penguin_grab(threadsafe_stack<int>);

mutex m;

void function_(threadsafe_stack<int>&);
void function_1(LogFile& log)
{
	for (int i = 0; i < 100; i++)
		log.shared_print(string("From t1: "), i);
}


//Launch lots of threads and all share the same data
//Not thread safe :(




int main()
{
	LogFile log;
	//thread t1(function_1, ref(log));

	//for (int i = 0; i < 100; i++)
	//log.shared_print("From main: ", i);

	threadsafe_stack<int> Penguin;
	//threadsafe_stack<int> *Penguin_copy = &Penguin;         //NOPE.AVI!! This is very dangerous.
	int  test;

	Penguin.push(5);
	Penguin.push(10);
	Penguin.push(15);
	Penguin.push(45);
	Penguin.push(1);
	//Penguin_copy->push(15);                               //Because then Penguin_copy can manipulate data members



	//function_(Penguin);

	thread t1(shared_print, "From t1: ", *Penguin.pop());
	shared_print("From main: ", *Penguin.pop());
	thread t2(shared_print, "From t2: ", *Penguin.pop());

	//shared_print("From main: ", *Penguin.pop());
	//cout << "From main: " << *Penguin.pop() << endl;


	//thread t1();

	t1.join();
	t2.join();



	cin.get();
}


void shared_print(string msg, int id)
{
	lock_guard<mutex> locker(m);              //Without mutex locking, all threads will try to access cout at the same time
	//Cout is the common resource
	cout << msg << id << endl;
}

void penguin_grab(threadsafe_stack<int> Penguin)
{
	do{

		shared_print("From t1: ", *Penguin.pop());
		//cout << "From t1: ";
		//cout << *Penguin.pop() << endl;

	} while (!Penguin.empty());

}

void function_(threadsafe_stack<int>& Penguin)
{

	thread t1(shared_print, "From t1: ", *Penguin.pop());
	thread t2(shared_print, "From t2: ", *Penguin.pop());
	t1.join();
	t2.join();
}