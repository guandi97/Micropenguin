/*
 *Guandi97
 *stdlib.h recreation
 */

#include <unistd.h>
//debug
#include <stdio.h>

#define stdfun

typedef struct struct_file file;
int sterlen(char*);						//loops until 0x0 is found
int ati(char*);
int memcp(char*,char*,size_t);
int readup(int,char*,char);
int buffwrite(char*,file*,size_t);
int fsflush(file*);


struct struct_file
{
	int fd;
	size_t index;
	char buff[1024];
};

int sterlen(char *str)
{
	int i=0;
	while(*(str+i)!=0x0) i++;

	return i;
}
int ati(char *str)
{
	int i;
	return i;
}
int memcp(char *source,char *destin,size_t size)
{
	int i;
	for(i=0;i<(size);i++)
	{
		*(destin+i)=*(source+i);
	}
	return i;
}
int readup(int fd,char *destin,char delim)
{
	#define READUPBUFF 64
	int i,j,c=0;
	char buff[READUPBUFF];

	while(1)
	{
		i=read(fd,buff,READUPBUFF);
		if(i!=READUPBUFF) goto READLINEEND;

		i=0;
		while(buff[i]!=delim && i!=READUPBUFF) i++;
		if(i>=32)
		{
			memcp(buff,&(*(destin+c)),READUPBUFF);
			c+=READUPBUFF;
		}
	}

	READLINEEND:;
	j=0;
	while(buff[j]!=delim && j<i) 
	{
		j++;
	}
	memcp(buff,&(*(destin+c)),j);
	c+=j;

	return c;
}
int buffwrite(char *source,file *strmout,size_t size)
{
	int i;

	if((1024-strmout->index)<size) 
	{
		fsflush(strmout);
	}

	i=memcp(source,&strmout->buff[strmout->index],size);
	size+=i;
	return i;
}
int fsflush(file *strmout)
{
	int i=write(strmout->fd,&strmout->buff,strmout->index);
	strmout->index=0;
	return i;
}

