import java.io.*;

class errStrm {
	public static void strmset(String loc) {
		try {
			System.setErr(new PrintStream(new FileOutputStream(loc)));
		} catch(FileNotFoundException e) {
			System.setErr(System.out);
		}
	}
}
