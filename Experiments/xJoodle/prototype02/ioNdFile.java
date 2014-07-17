import java.io.*;

class ioNdFile {
	public static RandomAccessFile cmdreadrr;

	public static String readScptLn() {
		String ln;
		do {
			try {
				ln=cmdreadrr.readLine().trim();
			} catch(IOException e) {
				System.err.println(e);
			}
		} while(ln.matches("(^$|^\\/\\/.*$)"));
		ln=ln.replace(""\\/\\/.*$","");
		return ln;
	}
}
