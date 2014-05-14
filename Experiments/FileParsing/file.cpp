//Placing blocks inside classes
//Messing with C++ Pointers and low level abstractions

#include <iostream>
#include <fstream>
#include <string>
using namespace std;



class Proofs
{
public:
    string id;

    void setName(string s)
    {
        name = s;
    }
    string getName()
    {
        return name;
    }

private:
    string name;

};


Proofs process(string);


int main()
{

    string line;
    string * buffer;
    int blocks = 0;
    ifstream myFile;
    bool newProof = false;
    Proofs * lawl = new Proofs[4];
    Proofs * Pass;
    myFile.open("test.txt");

    if(myFile.is_open())
    {

        while(getline(myFile, line))
        {

            if(line.find("id:") != string::npos)
             {
                buffer = new string;
                buffer->append(line);
                buffer->append("/");
             }
        else if(line == "-")
            {
                lawl[blocks] = process(*buffer);
                delete buffer;
                blocks++;
            }
            else
                buffer->append(line);









            /*
            if(line.find("id:") != string::npos)
              {  Pass = new Proofs;
                 Pass->id = line;
               }
            else if(line.find("name:") != string::npos)
               {

                Pass->setName(line);
                }

            else if(line == "-")
            {
                lawl[blocks] = *Pass;
                delete Pass;
                blocks++;
            }

            */

        }



    }


    for(int i=0; i < blocks; i++)
    {
        cout << lawl[i].id << endl;
        cout << lawl[i].getName() << endl;
    }

}



Proofs process(string buffer)
{
    Proofs * Pass = new Proofs;
    int found;
    string id, name;
    found = buffer.find("/");
    if(found != string::npos)
    {
        id = buffer.substr(0,found);
        name = buffer.substr(found+1,buffer.length()-2);

    }

   // cout << id << endl;
   // cout << name << endl;

    Pass->id = id;
    Pass->setName(name);

    return *Pass;
}

