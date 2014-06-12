#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

//gcc options: -m32 -O0
int main()
{
					//ebp: _main-0x1
	int f;
	f=open("dovr",O_RDONLY);

	char lolz[]="Raped";		//ebp-0x12: _main-0x13-0x4 -> -15 -relative to entry point: +1+4=5B  (0x12 is end of lolz so +4B)
	char entry=18;			//ebp-0x13: _main-0x14 -> -20
						/*	
						56-20=36 (0x24)
						36-1=35 -> subtract 1 for first instruction
						you will need 35 bytes of padding b4 your first instruction
						*/
	while(f!=0)
	{				//_main-0x38 -> -56
		read(f,(&entry-22),128);
		printf("%.4s",&lolz);
	}
					//while loop actually jumps to "address" of last bracket, compares, and then jumps to 1st bracket if needed

	return 0;
}
