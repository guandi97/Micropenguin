import java.util.*;

class veriblz implements mngr {
	public static Stack<String> nameStack;
	public static Stack<Stack<String>> varStack;
	public static Stack<Stack<Integer>> typeStack;
		//0-number
		//1-String
		//2-cmdsequence
	static {
		//initialize containing collection
		nameStack=new Stack<String>();
		varStack=new Stack<Stack<String>>();
		typeStack=new Stack<Stack<Integer>>();
	}

	public void mngr(String ln) {
		System.err.println("variables");

		String name=null;
		String[] arrbuff=null;
		int index=0;
		int arrIndex=0;

		arrbuff=ln.split("=",2);
		if(arrbuff.length==1) {
			System.err.println("varOp");
			arrbuff=ln.split("(\\[|])");
			name=arrbuff[0];
			ln=arrbuff[1];

			index=exists(name);
			if(index==-1) {
				System.out.println("syntax error");
				System.exit(0);
			}
			varStack.setElementAt(varOps(ln,varStack.elementAt(index)),index);
		} else {
			System.err.println("not varOp");
			name=arrbuff[0];
			ln=arrbuff[1];		
			
			if(name.matches("^.*\\[.+].*$")) {
				arrbuff=name.split("(\\[|])",3); /*)*/
				for(String s : arrbuff) {
					System.err.println("arrbuff: "+s);
				}
				name=arrbuff[0];
				arrIndex=parseIndex(arrbuff[1]);

				index=exists(name);
				if(index==-1) {
					System.err.println("new var");
					if(arrIndex!=0) {
						System.out.println("syntax");
						System.exit(0);
					}
					nameStack.push(name);
					varStack.push(new Stack<String>());
					varStack.elementAt(varStack.size()-1).push(arrSet(ln));
					typeStack.push(new Stack<Integer>());
				} else {
					System.err.println("old var");
					varStack.elementAt(index).setElementAt(arrSet(ln),arrIndex);
				}
			} else {
				index=exists(name);
				if(index==-1) {
					System.err.println("new var");
					nameStack.push(name);
					varStack.push(varSet(ln));
					typeStack.push(new Stack<Integer>());
				} else {
					System.err.println("old var");
					varStack.setElementAt(varSet(ln),index);
				}
			}
		}
		System.err.format("stackSize: %d\n",varStack.size());
	}
	public int exists(String name) {
		if(nameStack.size()==0) return -1;
		System.err.println("exists");
		for(int i=nameStack.size()-1;i!=0;i--) {
			System.err.println(nameStack.elementAt(i));
			if(name.equals(nameStack.elementAt(i))) {
				System.err.println("index: "+i);
				return --i;
			}
		}
		return -1;
	}
	public Stack<String> varSet(String ln) {
		System.err.println("varset");
		Stack<String> leStack=new Stack<String>();

		return leStack;
	}
	public String arrSet(String ln) {
		System.err.println("arrset");
		String leStr=null;

		return leStr;
	}
	public Stack<String> varOps(String ln,Stack<String> leStack) {
		System.err.println("varOps");

		return leStack;
	}
	public int parseIndex(String str) {
		if(str.matches("^.*#.*$")) {
			if(str.matches("^--#$")) {
			} else if(str.matches("^\\+\\+#$")) {
			} else //if(...math parser)
			}
		} else if(str.matches("^\\d+$")) {
		} else if(str.matches("^.*\\$\\(.*\\)$")) {
		}
		int i=0;
		return i;
	}
	public static void removeRng(int i,int j) {
		i--;
		j--;
		System.err.format("i: %d j: %d\n",i,j);
		nameStack.subList(i,j).clear();
		varStack.subList(i,j).clear();
		typeStack.subList(i,j).clear();
	}
}
