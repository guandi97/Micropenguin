import java.util.*;
import java.lang.*;

class daBoss {
	public static void main(String args[]) {
		Stack<nomnom> thrdz=new Stack<nomnom>();
		int sp=0;
	}
	public static int spawndem(int quan,Stack<nomnom> thrdz) {
		int i;
		for(i=0;i<quan;i++) {
			thrdz.push(new nomnom());
			thrdz.get(thrdz.size()-1).start();
		}
		return i;
	}
	public static void killdem(int quan,Stack<nomnom> thrdz) {
		for(quan;quan!=0;quan--) {
			thrdz.get(quan).stop();
			thrdz.get(quan).join();
			thrdz.remove(quan);
		}
	}
	public static void addem(int a,int b,int c,Stack<nomnom>thrdz) {
		thrdz.get(a).note=2;
		thrdz.get(b).note=2;
		thrdz.get(c).note=3;
		notifyAll();
	}
	public static void assdem(int thrd,int num,Stack<nomnom> thrdz) {
		thrdz.get(thrd).note=1;
		notifyAll();
	}
	public static int givme(int id) {
		thrdz.get(id).note=0;
		notifyAll();
	}
}
