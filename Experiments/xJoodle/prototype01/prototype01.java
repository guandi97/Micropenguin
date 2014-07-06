import java.io.*;

//single thread for simplicity

class workDammnit {
	//main method for initial file reading

	private boolean nxtLn==true;
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
		} while(ln.matches("(^\s*$|^\s*\\\\)");
		
		//check if eof
		while(ln!=null) {
			do {
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
				if(ln.matches("////") {
					arrbuff=ln.split("////");
					ln=arrbuff[0];
				}
				//function
				if(ln.matches("^\s*\w.*\(.*\)") {
					if(ln.matches("\s*\w.*\(.*\)\s+\{\s*$") /*}*/ { //lol, gotta escape that bracket for vim
						brackets.flg=true;
						ln=function.mngr(ln);
					}
					else {
						//use mark to reset stream instead of holding next line in buffer to free resources
						try {
							l=ioNDfile.freader.getFilePointer();
						} catch(IOException e) {
							System.err.println(e);
						}
						//get rid of blank lines, and commeneted lines
						do{
							sbuff=ioNDfile.freader.readLine();
						}while(sbuff.matches("(^\s*$|^\s*\\\\)");
						
						if(sbuff.matches("^\s*\{")) /*}*/ {
							try {
								ioNDfile.freader.seek(l);
							} catch(IOException e) {
								System.err.println(e);
							}
	
							ln=function.mngr(ln);
						}
						else {
							//abort(user error)
						}
					}
				}
				//cmdsequence
				else if(ln.matches("^\s*\$\(\w*\)") {
					//parse parenthesis
				}
				//variables
				else if(ln.matches("^\s*\w=.*") {
					ln=variables.mngr(ln);
				}
				//leading brackets
				else if(ln.matches("^\s*\{") /*}*/ {
					ln=upbracket(ln);
				}
			/*{*/	else if(ln.matches("^\s*\}") {
					ln=dnbracket(ln);
				}
				else {
					//user error, does not match:
						//: //,\n,$,\w=,builtins,\w(\w*),{,}
					abort(user error);
				}
				
				//check for trailing brackets
				if(nxtLn==false) {
					if(ln.matches("^\s\{") /*}*/ {
						ln=upbracket(ln);
					}
				/*{*/	else if(ln.matches("^\s*\}") {					
						ln=dnbracket(ln);
					}
				}
	
			} while(nxtLn==false && !ln.matches("^\s*$"); 	//make sure line isn't blank before parsing rest of said line
				//read next line
				do {
					ln=ioNDfile.freader.readLine();
				} while(ln.matches("(^\s*$|^\s*\\\\)");
		}

		//escape plan
		
	}
	private String upbracket(ln) {
		brackets.lvlup();
		ln=ioNDfile.eatStr(ln,"^\s*\{"); /*}*/ 
		nxtLn=false;
		return ln;
	}
	private String dnbracket(ln) {
		brackets.lvldn();
	/*{*/	ln=ioNDfile.eatStr(ln,"^\s*\}");
		nxtLn=false;
		return ln;
	}
	private String dnbrackets(ln) {
	}
}
//all static things
public interface Mngr {
	public void mngr(String ln);
}
class staticVarz {	//system dependent static vars
}
class parenthesis {
	public static int parlvl;

	static {
		parlvl=0;
	}

	public static lvlup() {
		parlvl++;
	}
	public static lvldn() {
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

	public static lvlup() {
		brktlvl++;
		scope.push(varname.size());
	}
	public static lvldn() {
		brktlvl--;

		//indexes are already 1 larger (cause doesnt account for 0)
		i=scope.pop();
		j=varname.size(); 
		variables.removeRng(i,j);
	}
}
class variables implements Mngr{
	public Stack<int> varsize;
	public Stack<int[]> typevar;
		//0=number
		//1=String
		//2=cmdsequence
	public Stack<String[]> varStack;	//be careful, public access risky; suggest final product be private
	public Stack<String> varname;

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
	}
	public static void removeRng(int i,int j) {
		varsize.removeRange(i,j);
		typevar.removeRange(i,j);
		varStack.removeRange(i,j);
		varname.removeRange(i,j);
	}
}
class ioNDfile {
	static RandomAccessFile freader;
	
	public static String eatStr(String ln,String regex) {
		return ln;
	}
}
class function implements Mngr {
	static {
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
