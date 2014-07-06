import java.nio.file.*;
import java.nio.charset.Charset;
import java.io.*;

class fileIO {
	public static void main(String[] args) {
		Path rfile=Paths.get(args[0]);
		Charset charset = Charset.forName("US-ASCII");
		BufferedReader freader;
		String s;
		int i=1;

		try {
			freader=Files.newBufferedReader(rfile,charset);
			while(i>=0) {
				s=freader.readLine();
				if(s==null) i=-1;
				else {
					System.out.println(s);
				}
			}
		} catch(IOException e) {}
	}
}
