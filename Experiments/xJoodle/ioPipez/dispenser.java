import java.util.*;
import java.lang.*;
import java.io.*;

class dispenser extends Thread{
	int offset;
	static boolean[] flag;
	static Object dalock;
	PipedInputStream heavy=null;
	PipedOutputStream rain=null;
	public dispenser(int i,PipedInputStream eyzaSPY) {
		offset=i;
		heavy=eyzaSPY;
	}
	public dispenser(int i,PipedOutputStream eyzaSPY) {
		offset=i;
		rain=eyzaSPY;
	}
	public void run() {
		byte[] b=new byte[4];
		String s=null;
		if(heavy!=null) {
			synchronized(dalock) {
				try {
					dalock.wait();
				} catch(InterruptedException e) {}
			}
			try {
				heavy.read(b);
			} catch(IOException e) {}
			s=new String(b);
			System.out.println(s);
		} else {
			s="lolz";
			b=s.getBytes();
			try {
				rain.write(b,0,s.length());
			} catch(IOException e) {}
			synchronized(dalock) {
				dalock.notifyAll();
			}
		}
	}
}
