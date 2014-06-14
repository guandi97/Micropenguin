import java.util.*;
import java.io.*;
import java.nio.*;

class pootispencer {
	int baa; 	//flawed way for spinlock, what if two notices for diferent threads happen before any are caught?
	Object shrek;
}
class numnutz extends Thread {
	pootispencer poot;
	public numnutz(pootispencer saxton) {
		poot=saxton;
	}
/*						start() is "reserved", if exists, and you call thread.start(), it will singlethread from parent class	
	public void start() {
		run();
	}
*/
	public void run() {
		System.out.println("numnutz");
		lolz();
		synchronized(poot.shrek) {
			System.out.println("n1 "+poot.baa);
			if(poot.baa!=2) {
				while(poot.baa!=2) {				//spin lock for obvious reez0nz
					try {
						poot.shrek.wait();
					} catch(InterruptedException e) {
						System.err.println(e);
					}
				}
			} else {
				poot.baa=0;
			}
		}
		lel();
	}
	public synchronized void lolz() {
		synchronized(poot.shrek) {
			poot.baa=1;
			System.out.println("lolz, 1");
			poot.shrek.notifyAll();
		}
		System.out.println("lolz");
	}
	public void lel() {
		System.out.println("lel");
	}
}
class maggots extends Thread {
	pootispencer poot;
	public maggots(pootispencer saxton) {
		poot=saxton;
	}
/*	
	public void start() {
		run();
	}
*/	
	public void run() {
		System.out.println("maggots");
		synchronized(poot.shrek) {
			System.out.println("m1 "+poot.baa);
			if(poot.baa!=1) {
				while(poot.baa!=1) {
					try {
						poot.shrek.wait();
					} catch(InterruptedException e) {
						System.err.println(e);
					}
				}
			} else {
				poot.baa=0;
			}	
			System.out.println("m2 "+poot.baa);
		}
		rofl();
	}
	public synchronized void rofl() {
		System.out.println("rofl, "+poot.baa);
		synchronized(poot.shrek) {
			poot.baa=2;
			System.out.println("rofl, 2");
			poot.shrek.notifyAll();
		}
		System.out.println("rofl");
	}
}
