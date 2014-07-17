import java.io.*;

//single thread for simplicity

class workDammnit {
	//main method for initial file reading

	private boolean nxtLn=true;
	private String ln=null;
	
	public static void main(String args[]) {

		//read 1 line, look for key characters, look for:
			// $(...) - cmdsequences
			// '/w'(...) {...} - functions
			// '/w'=... - variables
			// // - comment
			// parenthesis
	//################################################
	
	//initialization

		//variables
		int i=0;
		long l=0;
		String sbuff=null;
		String[] arrbuff=null;

		//objects
		ioNDfile.freader=new RandomAccessFile(args[0],"r");

		//nestable classes 

	//body
		//read line
		//parse first word
		//hand over line to appropriate class or do nothing if comment
	//###########
		//initial read line, and removal of blank|commented lines
		do {
			ln=ioNDfile.freader.readLine();
		} while(ln.matches("(^\\s*$|^\\s*\\/\\/.*)")); {
		
		//check if eof
		while(ln!=null) {
			//da if thenz
			   //mngrz
				//check for brackets, and comments
					//remove comments
					//do something \w parenthesis
					//error if anything else
				//function
				//cmdsequence
				//variable
					//special case for parenthesis
				//brackets
				//builtin (for loop,etc)
			//######
			
			//reset flag
			nxtLn=true;

			//comment parsing
			if(ln.matches("\\/\\/.*$")) {
				ln=ln.replace("\\/\\/.*$","");
			}
			//function
			if(ln.matches("^\\s*\\b(\\w|\\d)+\\(((\\$(\\w|\\d)+\\[\\d+]|(\\w|\\d)+)*\\s*,\\s*)*((\\$(\\w|\\d)+\\[\\d+]|(\\w|\\d)+)\\s*)\\)\\s*\\{.*$")) /*}*/ { 
				//set function name
				ln=ln.trim();
				sbuff=ln.replace("\\(.*$","");
				function.fctnName=sbuff;
				brackets.lvlup();
				ln=function.mngr(ln);

			}
			//cmdsequence
			else if(ln.matches("^\\s*\\$\\(.+\\)\\s*$")) {
				//parse parenthesis..maybe?
				
			}
			//variables
			else if(ln.matches("\\s*\\b(\\w|\\d)+\\s*=.*")) {
				ln=variables.mngr(ln);
			}
			//leading brackets
			else if(ln.matches("^\\s*\\{\\s*$")) /*}*/ {
				lvlup();
			}
		/*{*/	else if(ln.matches("^\\s*}\\s*$")) {
				lvldown();
			}
			else {
					//user error, does not match:
					//: //,\n,$,\w=,builtins,\w(\w*),{,}
				//abort(user error);
			}
			
			//read next line rm blank/comment
			do {
				ln=ioNDfile.freader.readLine();
			} while(ln.matches("(^\\s*$|^\\s*\\/\\/.*)"));
		}

		//escape plan
		
	}
	// --screw this, unforgiving syntax structure ftw
	//private void upbracket() {
	//	brackets.lvlup();
	//	ln=ioNDfile.eatStr(ln,"^\s*\\{"); /*}*/ 
	//	//nxtLn=false;
	//}
	//private void dnbracket() {
	//	brackets.lvldn();
	///*{*/	ln=ioNDfile.eatStr(ln,"^\\s*\\}");
	//	//nxtLn=false;
	//}
	//*/
}
//all static things
public interface Mngr {
	public void mngr(String ln);
}
class staticVarz {	//system dependent static vars  --depreciated?
}
class parenthesis {
	public static int parlvl;

	static {
		parlvl=1;
	}

	public static void lvlup() {
		parlvl++;
	}
	public static void lvldn() {
		parlvl--;
	
	}
}
class brackets {
	public static boolean flg;
	public static int brktlvl;
	private Stack<int> scope;

	static {
		flg=false;
		brktlvl=0;
		scope=new Stack<int>();
	}

	public static void lvlup() {
		brktlvl++;
		scope.push(varname.size());
	}
	public static void lvldn() {
		brktlvl--;

		//..variables, etc
		//indexes are already 1 larger (cause doesnt account for 0)
		i=scope.pop();
		j=varname.size(); 
		variables.removeRng(i,j);	

		//rm function status if global scope
		if(brktlvl==0) function.fctnName=null;
	}
}
class variables implements Mngr {
	public static Stack<int> varsize;
	public static Stack<int[]> typevar;
		//0=number
		//1=String
		//2=cmdsequence
	public static Stack<String[]> varStack;	//be careful, public access risky; suggest final product be private
	public static Stack<String> varname;

	static {
		varsize=new Stack<int>();
		typevar=new Stack<int[]>();
		varStack=new Stack<String[]>();
		varname=new Stack<String>();
	}

	public void mngr(String ln) {
		//check for []
		//check for {}
		//if then: #,"",$()

		String name=null;
		int varindex=0;
		boolean varRequest=false;

		{		//garbage cleanup of temp variables
			ln.trim();
			String[] lnsplit=ln.split("=");
			//ln now equals right of = sign
			ln=lnsplit[1];
			lnsplit[0]=lnsplit[0].replace("=.*$","");
			//if indexed..
			if(lnsplit[0].matches("\\[\\d+]")) {
				varRequest=true;
				String[] nmpartz=lnsplit[0].split("[");

				varindex=Integer.getInteger(nmpartz[1].replace("]",""));
				name=nmpartz[0];
			}
			else {
				name=lnsplit[0];
			}
		}

		//search variable exists
		boolean exist=false;
		int stackindex=0;

		if(varname.size()!=0) {
			for(int stackindex=varname.size()-1;stackindex!=0;stackindex--) {
				if(varname.elementAt(stackindex)==name) {
					exist=true;
					break;
				}
			}
		}
		//exist=false: push instead of setElement...

		if(exist==false) {
			if(varRequest==true && varindex!=0) {
				//abort
			}
			varname.push(name);
			stackindex=varname.size()-1;
		}
		
		//determin type...
		//le return string
		String var[];
	
		//cmdsequence
		if(ln.matches("^\\$\\(.+\\)\\s*$")) {
		}
		//declaratives...
		else {
			if(varindex==0) {
				//declare stuff
				int i=1;

				//array stuff;
				if(ln.matches("^\\{.*$")) /*}*/ {
					//count ,+1
					char[] arrbuff=ln.toCharArray();
					for(char lolz:arrbuff) {
						if(lolz==',') i++;
					}
					var=new String[i];

					ln.replaceAll("(\\s|\\{|})","");
					String[] lnz=ln.split(",");
				}
				else {
					var=new String[1];
					String[] lnz={ln};

				}
				//var type based off 1st entry

				//num
				if(lnz[0].matches("^\\d+")) {
					if(exist==false) {
						typevar.push(0);
					}
					else typevar.setElementAt(0,stackindex);
					for(int j=0;j<i;j++) {
						var[j]=Integer.getInteger(lnz[j]);
					}
				}
				//string
				else if(lnz[0].matches("\".*\"")) {
					if(exist==false) {
					}
					else typevar.setElementAt(1,stackindex);
					for(int j=0;j<i;j++) {
						var[j]=lnz[j];
					}
				}
			}
			else {
				//confirm var..
				//allocate new array if nessesarry
				String var=varStack.elementAt(stackindex);

				if(var.size()+1==varindex) {
					String[] temp=var;
					var=String[varindex];
					for(int i=0;i<varindex-1;i++) {
						var[i]=temp[i];
					}
				}
				else if(var.size()+1<varindex) {
					//abort
				}

				//num
				if(ln.matches("^\\d+")) {
					var[varindex]=Integer.getInteger(ln);
				}
				//string
				{
					var[varindex]=ln;
				}
			}
		}
	}
	public static void removeRng(int i,int j) {
		varsize.removeRange(i,j);
		typevar.removeRange(i,j);
		varStack.removeRange(i,j);
		varname.removeRange(i,j);
	}
}
class ioNDfile {
	public static RandomAccessFile freader;
	
	public static String eatStr(String ln,String regex) {
		return ln;
	}
}
class function implements Mngr {
	public static boolean parflg;
	public static String fctnName;

	static {
		fctnName=null;
		parflg=false;
	}
	public void mngr(String ln) {
	}
}

//other things (nestable things)
class forloop {
}
class cmdsequences implements Mngr {
	public void mngr(String ln) {
	}
}
class cmdlets {
}
