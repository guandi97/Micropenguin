#Guandi97

#include <unistd.h>
#include "stdfun.h"
#include <stdio.h>

void a(char*,int);
void b(char*,int);

int main(int argc, char **argv)
{
	if(argc<2) write(1,"invalid args\n",sizeof("invalid args\n"));
	else
	{
		int i=strsize(*(argv+2),0x0);
		
		if(memcmpr("-a",*(argv+1),2)==2) a(*(argv+2),i);
		else if(memcmpr("-b",*(argv+1),2)==2) b(*(argv+2),i);
		else write(1,"invalid args\n",sizeof("invalid args\n"));
	}

	return 1;
}
void a(char *s,int len)
{
	char *m=malloc(64);
	char v=0,i=0;

	while(i<len)
	{
		if(*(s+i)=='{') 
		{
			v++;
			*(m+v)=i;
		}
		if(*(s+i)=='}')
		{
			printf("%d %d\n",v,*(m+v));
			write(1,s+*(m+v),i-*(m+v)+1);
			write(1,"\n",1);
			v--;
		}
		i++;
	}
	_exit(0);
}
void b(char *s,int len)
{
	char v=0,i=0;
	
	while(i<len)
	{
		if(*(s+i)=='"')
		{
			if(v==0) 
			{
				v=i;
				printf("lo\n");
			}
			else 
			{
				printf("lolz\n");
				write(1,s+v,i-v+1);
				write(1,"\n",1);
				v=0;
			}
		}
		i++;
	}
	_exit(0);
}
