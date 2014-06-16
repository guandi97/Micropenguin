import java.util.*;
import java.lang.*;

public class pthrd {
	public static void main(String args[]) {
		pootispencer poot=new pootispencer();
		poot.baa=0;
		poot.shrek=new Object();
		numnutz num=new numnutz(poot);
		maggots mag=new maggots(poot);
		num.start();
		mag.start();
	}
}
		
