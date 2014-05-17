#include <iostream>
using namespace std;

int main() {

	int array[] = {5,2,3,6,4};
	/*
	
	 int i, j, flag = 1;    // set flag to 1 to start first pass
      int temp;             // holding variable
      int numLength = sizeof(num)/sizeof(num[0]); 
      for(i = 1; (i <= numLength) && flag; i++)
     {
          flag = 0;
          for (j=0; j < (numLength -1); j++)
         {
               if (num[j+1] > num[j])      // ascending order simply changes to <
              { 
                    temp = num[j];             // swap elements
                    num[j] = num[j+1];
                    num[j+1] = temp;
                    flag = 1;               // indicates that a swap occurred.
               }
          }
     }
*/
	
	int max = 0;
	int temp;
	int flag = 1;
	int arrayLength = sizeof(array)/sizeof(array[0]);
	
	

	for(int i=0; (i<arrayLength); i++)
	{
						  flag = 0;

		
			for(int j=0; j<arrayLength-1; j++)
			{
			
				if(array[j+1] < array[j])
				{temp = array[j];
				array[j] = array[j+1];
				array[j+1] = temp;
				

				 }
				
			}
		
			
	}
	
	

for(int i=0; i<sizeof(array)/sizeof(array[0]); i++)
cout << array[i] << endl;
/*

for(int i=0; i<numLength; i++)
cout << num[i] << endl;
*/
	return 0;
}
