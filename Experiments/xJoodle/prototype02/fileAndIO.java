import java.io.*;

class ioNdFile {
	public static int lnNum;
	public static RandomAccessFile cmdreadrr;

	static {
		lnNum=0;
	}

	public static String readScptLn() {
		String ln=null;
		do {
			try {
				ln=cmdreadrr.readLine().trim();
			} catch(IOException e) {
				System.err.println(e);
			} catch(NullPointerException e) {	//trim() will trigger this
				System.err.println("EOF");
				ln=null;
				return ln;
			}
		} while(ln.matches("(^$|^\\/\\/.*$)"));
		ln=ln.replace("\\/\\/.*$","");
		System.err.format("\t%s\n",ln);
		lnNum++;
		return ln;
	}
}
