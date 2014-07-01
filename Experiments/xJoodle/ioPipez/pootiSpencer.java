import java.util.*;
import java.lang.*;
import java.io.*;

class pootiSpencer {

	public static void main(String args[]) {
		PipedInputStream heavy=new PipedInputStream();		//read
		PipedOutputStream rain=null;
		try {
			rain=new PipedOutputStream(heavy);
		} catch(IOException e) {}

		dispenser.flag=new boolean[2];
		dispenser.dalock=new Object();
		dispenser naow=new dispenser(0,heavy);
		dispenser sandvitch=new dispenser(1,rain);

		//gotta move that gear up
		naow.start();
		sandvitch.start();
	}
}
