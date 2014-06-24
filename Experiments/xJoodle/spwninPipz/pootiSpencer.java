import java.util.*;
import java.lang.*;
import java.io.*;

class pootiSpencer {

	public static void main(String args[]) {
		PipedInputStream heavy=new PipedInputStream();		//read
		try {
			PipedOutputStream rain=new PipedOutputStream(heavy);
		} catch(IOException e) {}

		dispencer naow=new dispencer(heavy);
		dispencer sandvitch=newDispencer(rain);
		naow.start();
		sandvitch.start();
	}

	public static void pstore() {
	}
	public static void psend() {
	}
}
