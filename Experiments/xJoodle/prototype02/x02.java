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

		//**body

		//initial readln
		ln=ioNdFile.readScptLn();
		while(ln!=null) {
			//function
			if(ln.matches("^\\b(\\w|\\d)+\\{(\\w|\\d)*(,(\\w|\\d)+)*\\)$")) /*}*/ {
			}
			//variable
			else if(ln.matches("\\b(\\w|\\d)+=.*")) {
			}
			//cmdsequence
			else if(ln.matches("\\$\\(.+\\)\\s*$")) {
			}
			//brackets
			else if(ln.matches("\\{\\s*$")) /*}*/ {
			}
		/*{*/	else if(ln.matches("}\\s*$")) {
			}
			else {
				//hand over to builtins
			}

			//subsequent reads
			ln=ioNdFile.readScptLn();
		}
	}
}
