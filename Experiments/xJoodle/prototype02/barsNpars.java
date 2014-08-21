import java.util.*;

interface nestle {
	public void lvlup();
	public void lvldn();
}
//static
class braketz implements nestle {
	public static int lvl;
	public static Stack<Integer> mark;

	static {
		lvl=0;
		mark=new Stack<Integer>();
	}
	public static void lvlup() {
		lvl++;
		mark.push(veriblz.varStack.size());
		System.err.println("brkt lvlup: "+lvl);
	}
	public static void lvldn() {
		lvl--;
		veriblz.removeRng(mark.pop(),veriblz.varStack.size());
		System.err.println("brkt lvldn: "+lvl);
	}
}
//!static
class parenfezez implements nestle {
	public int lvl;
	void parenfezez {
		lvl=0;
	}
	public void lvlup() {
		lvl++;
		System.err.println("par lvlup: "+lvl);
	}
	public void lvldn() {
		lvl--;
		System.err.println("par lvlup: "+lvl);
	}
}
