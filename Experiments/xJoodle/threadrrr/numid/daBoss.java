import java.util.*;
import java.lang.*;

class daBoss {
	
	public static void main(String args[]) {
		Stack<nomnom> thrdz=new Stack<nomnom>();
		int si=0,di=0;
		Scanner sc=new Scanner(System.in);
		String uin;
		String ain[];
		neo nemo=new neo();
		nemo.dalock=new Object();

		System.out.println("^c quit");
		while(true) {
			uin=sc.nextLine();
			ain=uin.split(" ");
			if(uin.matches("^spawn\\s\\d+$")) {
				di+=spawndem(nemo,Integer.parseInt(ain[1]),thrdz,di);
			}
			else if(uin.matches("^kill\\s\\d+$")) {
				si+=Integer.parseInt(ain[1]);
				killdem(Integer.parseInt(ain[1]),thrdz);
			}
			else if(uin.matches("^killall$")) {
				genocide(thrdz,nemo,si,di);
				si=di;
			}
			else if(uin.matches("^add(\\s\\d+){3}$")) {
				addem(Integer.parseInt(ain[1]),Integer.parseInt(ain[2]),Integer.parseInt(ain[3]),thrdz,nemo.dalock);
			}
			else if(uin.matches("^assign(\\s\\d+){2}$")) {
				assdem(Integer.parseInt(ain[1]),Integer.parseInt(ain[2]),si,thrdz,nemo);
			}
			else if(uin.matches("^view\\s\\d+$")) {
				System.out.println(givme(thrdz,Integer.parseInt(ain[1]),nemo));
			}
			else if(uin.matches("^list$")) {
				listem(thrdz,si,di);
			}
			else if(uin.matches("help")) {
				System.out.println("spawn # #\nkill #\nadd # # #\nassign # #\nview #\nlist");
			}
			else { System.out.println("command not found"); }
		}

	}
	public static int spawndem(neo nemo,int quan,Stack<nomnom> thrdz,int si) {
		int i;
		for(i=0;i<quan;i++) {
			thrdz.push(new nomnom(nemo));
			thrdz.get(thrdz.size()-1).start();
			System.out.format("Thread %d\n",si+i);
		}
		return i;
	}
	public static int killdem(int quan,Stack<nomnom> thrdz) {
		for(quan=quan;quan!=0;quan--) {
			thrdz.get(quan).stop();
			try {
				thrdz.get(quan).join();
			} catch(InterruptedException e) {}
			thrdz.remove(quan);
		}
		return quan;
	}
	public static void addem(int a,int b,int c,Stack<nomnom>thrdz,Object dalock) {
		neo nemo=new neo();
		nemo.datar=0;
		thrdz.get(a).note=3;
		thrdz.get(b).note=3;
		thrdz.get(c).note=4;
		synchronized(dalock) {
			dalock.notifyAll();
		}
	}
	public static void assdem(int thrd,int num,int si,Stack<nomnom> thrdz,neo nemo) {
		nemo.datar=num;
		thrdz.get(thrd-si).note=2;
		synchronized(nemo.dalock) {
			nemo.dalock.notifyAll();
		}
	}
	public static int givme(Stack<nomnom> thrdz,int id,neo nemo) {
		thrdz.get(id).note=1;
		synchronized(nemo.dalock) {
			nemo.dalock.notifyAll();
			try {
				nemo.dalock.wait();
			} catch(InterruptedException e) {}
		}
		return nemo.datar;
	}
	public static void listem(Stack<nomnom> thrdz,int si,int di) {
		for(int i=si;i<di;i++) {
			System.out.format("Thread %d: %d\n",i,thrdz.get(i-si).ratad);
		}
	}
	public static void genocide(Stack<nomnom> thrdz,neo nemo,int si,int di) {
		for(int i=si;i<di;i++) {
			thrdz.get(i-si).terminateflg=true;
		}
		synchronized(nemo.dalock) {
			nemo.dalock.notifyAll();
		}
		thrdz.remove(di-si-1);
	}
}
