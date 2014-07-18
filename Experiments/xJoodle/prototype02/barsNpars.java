import java.util.*;

interface nestle {
	public void lvlup();
	public void lvldn();
}

class braketz implements nestle {
	public static int lvl;
	public static Stack<Integer> mark;

	static {
		lvl=0;
		mark=new Stack<Integer>();
	}
	public void lvlup() {
		lvl++;
		mark.push(veriblz.stack.size());
		System.err.println("brkt lvlup: "+lvl);
	}
	public void lvldn() {
		lvl--;
		veriblz.removeRng(mark.pop(),veriblz.stack.size());
		System.err.println("brkt lvldn: "+lvl);
	}
}
class parenfezez implements nestle {
	public static int lvl;
	static {
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
