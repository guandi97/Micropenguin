import java.io.*;

class ioNdFile {
	public static RandomAccessFile cmdreadrr;

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
		System.err.println(ln);
		return ln;
	}
}
