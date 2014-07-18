import java.util.*;

class veriblz implements mngr {
	public static Stack<String> name;
	public static Stack<Stack<String>> stack;
	public static Stack<Stack<Integer>> type;
		//0-number
		//1-String
		//2-cmdsequence
	static {
		//initialize containing collection
		name=new Stack<String>();
		stack=new Stack<Stack<String>>();
		type=new Stack<Stack<Integer>>();
	}

	public void mngr(String ln) {
		System.err.println("variables");
	}
	public static void removeRng(int i,int j) {
		name.subList(i,j).clear();
		stack.subList(i,j).clear();
		type.subList(i,j).clear();
	}
}
