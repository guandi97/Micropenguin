import java.lang.*;

class nomnom extends Thread {
	int ratad=0;
	volatile boolean terminateflg=false;
	public volatile int note=0;
	neo nemo;

	public nomnom(neo nao) {
		nemo=nao;
	}
	public void run() {	
		while(terminateflg==false) {
			synchronized(nemo.dalock) {
				while(note==0 && terminateflg==false) {
					try {
						nemo.dalock.wait();
					} catch(InterruptedException e) {}
				}
			}
			switch(note) {
				case 1: giver(); break;
				case 2: storr(); break;
				case 3:	addr(); break;
				case 4: getr(); break;
			}
			note=0;
		}
		stop();
	}
	public void giver() {
		neo.datar=ratad;
		synchronized(nemo.dalock) {
			nemo.dalock.notifyAll();
		}
	}
	public synchronized void addr() {
		neo.datar+=ratad;
		neo.i++;
	}
	public void storr() {
		ratad=neo.datar;
	}
	public void getr() {
		synchronized(nemo.dalock) {
			while(neo.i<2) {
				try {
					nemo.dalock.wait();
				} catch(InterruptedException e) {}
			}
		}
		ratad=neo.datar;
		neo.i=0;
	}
}
class neo {
	Object dalock;
	public volatile static int datar=0;
	public volatile static int i=0;
}
