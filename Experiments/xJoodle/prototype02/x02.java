//handles initial parsing
import java.io.*;
import java.util.*;

class nooope {

	private static String ln=null;

	public static void main(String[] args) {
		//**method objects
		int i;
		long j;
		String sbuff=null;
		String[] arrbuff=null;

		//**public objects
		try {
			ioNdFile.cmdreadrr=new RandomAccessFile(args[0],"r");
		} catch(IOException e) {
			System.err.println(e);
		}

		//legit running
		//errStrm.strmset("/dev/null");

		//**initialization of the "static" members
		fnctshunz fnctshunz=new fnctshunz();
		veriblz veriblz=new veriblz();
		cmdsquenz cmdsquenz=new cmdsquenz();
		braketz braketz=new braketz();
		parenfezez parenfezez=new parenfezez();

		//**body

		//initial readln
		ln=ioNdFile.readScptLn();
		while(ln!=null) {
			//function
			if(ln.matches("^\\b(\\w|\\d)+\\{(\\w|\\d)*(,(\\w|\\d)+)*\\)$")) /*}*/ {
				fnctshunz.mngr(ln);
				braketz.lvlup();
			}
			//variable
			else if(ln.matches("^\\b(\\w|\\d)+(\\[.+])*(=.+)?$")) {
				veriblz.mngr(ln);
			}
			//cmdsequence
			else if(ln.matches("^\\$\\(.+\\)\\s*$")) {
				cmdsquenz.mngr(ln);
			}
			//brackets
			else if(ln.matches("^\\{\\s*$")) /*}*/ {
				braketz.lvlup();
			}
		/*{*/	else if(ln.matches("}\\s*$")) {
				braketz.lvldn();
			}
			else {
				//hand over to builtins
			}

			//subsequent reads
			ln=ioNdFile.readScptLn();
		}
	}
}
