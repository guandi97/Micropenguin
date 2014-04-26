#include <iostream>
#include <thread>
using namespace std;

void count()
{
	for(int i=0; i < 100; i++)
	cout << i << endl;
}


class Penguin
{
	public:
	int& i;
	Penguin(int& i_):i(i_){};
	void operator()(int lol)
	{
		for(unsigned j=0; j<100; j++)
		//i++;
	cout << j << endl;
	}

};

int main()
{
	int local = 0;
	Penguin lol(local);
	lol(1);
	//lol(local);
	//std::thread t(lol);
	//std::thread f(count2);
	cout << lol.i << endl;
	//t.join();
	//f.join();
}

