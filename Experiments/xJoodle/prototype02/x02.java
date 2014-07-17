//handles initial parsing
import java.io.*;

class nooope {

	private static String ln=null;

	public static void main(String[] args) {
		//method objects
		int i;
		long j;
		String sbuff=null;
		String[] arrbuff=null;

		//public objects
		try {
			ioNdFile.cmdreadrr=new RandomAccessFile(args[0],"r");
		} catch(IOException e) {
			System.err.println(e);
		}

		//initialization of the "static" members
		variFun variFun=new variFun();
		functions functions=new functions();


		//initial readln
		ln=ioNdFile.readScptLn();
		while(ln!=null) {
			//function
			if(ln.matches("^\\s*\\b(\\w|\\d)+\\{((\\$(\\w|\\d)+\\[\\d+]|(\\w|\\d)+)*\\s*,\\s*)*((\\$(\\w|\\d)+\\[\\d+]|(\\w|\\d)+)\\s*)\\)$")) /*}*/ {
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
				System.out.println("you fail");
				System.exit(0);
			}

			//subsequent reads
			ln=ioNdFile.readScptLn();
		}
	}
}
