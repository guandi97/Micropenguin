import java.util.*;
import java.nio.*;
import java.io.*;

class BufferRape
{


	public static void main(String args[]) {
		InputStreamReader opIn=new InputStreamReader(System.in);
		DataOutputStream opOut=new DataOutputStream(System.out);
		boolean cbuffi=true;
		CharBuffer cbuff=CharBuffer.allocate(100);
		char[] opChar=new char[512];		//1.0kb
		String opStr=null;
		int i=0,d=0;
		CharArrayReader carRed=null;
		BufferedReader bradar=new BufferedReader(new InputStreamReader(System.in));
		String[] opArr=null;

		try {
			opOut.writeChars("Speak up Negus\n");
		} catch(IOException e) {
			System.err.println(e);
		}
		while(true) {
			try {
				i=opIn.read(opChar);
			} catch(IOException e) {
				System.err.println(e);
			}
			//opChar[i-1]='\0';					//truncate the '\n', depreciated, "lol wtf? strings arn't null-terminated in java"
			opStr=new String(opChar,0,i-1);
			
			if(opStr.equals("put")) {
				bput(opOut,opIn,cbuff,cbuffi,opChar);
			}
			else if(opStr.equals("write")) {
				bwrite(opOut,cbuff,cbuffi,bradar);
			}
			else if(opStr.equals("get")) {
				bget(cbuffi,cbuff,opChar,opStr,bradar,opOut,opArr);

			}
			else if(opStr.equals("read")) {
				bread(opChar,cbuff,carRed,opOut);
			}
			else if(opStr.equals("clear")) {
				bclear(cbuff);
			}
			else if(opStr.equals("compact")) {
				bcompact(cbuff);
			}
			else {
				try {
					opOut.writeChars("ya done goofed\n");
				} catch(IOException e) {
					System.err.println(e);
				}
			}
		}
	}
	static void bput(DataOutputStream opOut,InputStreamReader opIn,CharBuffer cbuff,boolean cbuffi,char[] opChar) {
	 	int i=0;
		try {
			opOut.write(Character.getNumericValue('\n'));
			i=opIn.read(opChar);
		} catch(IOException e) {
			System.err.println(e);
		}
		if(cbuffi==false) {
			cbuffi=true;
			cbuff.flip();
		}
		cbuff.put(opChar,0,i-1);
		cbuff.position(cbuff.position()-1);
	}
	static void bwrite(DataOutputStream opOut,CharBuffer cbuff,boolean cbuffi,BufferedReader bradar) {
		if(cbuffi==false) {
			cbuffi=true;
			cbuff.flip();
		}
		try {
			opOut.write(Character.getNumericValue('\n'));
			bradar.read(cbuff);					//appends unto unknown?
		} catch(IOException e) {}
	}
	static void bget(boolean cbuffi,CharBuffer cbuff,char[] opChar,String opStr,BufferedReader bradar,DataOutputStream opOut,String[] opArr) {
		int i=0,d=0;
		do {
			try {
				opStr=bradar.readLine();
			} catch(IOException e) {}
			opArr=opStr.split(" ");
			if(opArr.length==2) break;
			else if(opArr[0].equals("^/d") && opArr[0].equals("^/d")) {
				i=Integer.getInteger(opArr[0]);	
				d=Integer.getInteger(opArr[1]);
				break;
			}
			else {
				try {
					opOut.writeChars("aww Negus!\nusage: index<num> length<num>");
				} catch(IOException e) {}
			}
		}while(true);
		if(cbuffi==true) {
			cbuffi=false;
			cbuff.flip();
		}
		cbuff.get(opChar,i,d);
		try {
			System.out.println(opChar);
			opOut.write(charToByte(opChar),0,(d-i)*2);
		} catch(IOException e) {}
	}
	static void bread(char[] opChar,CharBuffer cbuff,CharArrayReader carRed,DataOutputStream opOut) {
		if(cbuff.hasArray()==true) {
			int i=0;
			try {
				char[] temp=cbuff.array();
				carRed=new CharArrayReader(temp);
				try {
					i=carRed.read(opChar,0,temp.length);
				} catch(IOException e) {}
			} catch(ReadOnlyBufferException e) {
			} catch(UnsupportedOperationException e) {}
			try {
				opOut.write(charToByte(opChar),0,i*2);
			} catch(IOException e) {}
		}
		else {
			System.err.println("MIA arraya");
		}
	}
	static void bclear(CharBuffer cbuff) {
		cbuff.clear();
	}
	static void bcompact(CharBuffer cbuff) {
		cbuff.compact();
	}
	static byte[] charToByte(char[] cbuff) {
		int d=cbuff.length;
		byte[] bbuff=new byte[d*2];
		for(int i=1;i<d;i++) {
			bbuff[i*2-1]=(byte)cbuff[i-1];
			bbuff[i*2]=(byte)(cbuff[i-1]<<8);
		}
		return bbuff;
	}
}