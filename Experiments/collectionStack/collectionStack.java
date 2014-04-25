//collection stack

import java.lang.NullPointerException;
import java.lang.String;
import java.util.*;
import java.util.regex.*;
import java.io.*;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.OutputStreamWriter;


class x16 {
	public static void main(String args[]) {
		InputStreamReader isr_in=new InputStreamReader(System.in);
		BufferedReader br_in=new BufferedReader(isr_in);		//string methods apply
		OutputStreamWriter osw_out=new OutputStreamWriter(System.out);
		String buff_in=new String();
		String[] arr_in=null;
		Stack<String> stack=new Stack<String>();

		try {
			String tmsg="^C to exit\n";
			osw_out.write(tmsg,0,tmsg.length());
			osw_out.flush();
		} catch(IOException e) {
			System.err.println(e);
			System.exit(1);
		}
		while(true) {
			try {
				buff_in=br_in.readLine();
			} catch(IOException e) {
				System.err.println(e);
				System.exit(1); 
			}

			try {
				arr_in=buff_in.split(" ");
			} catch(PatternSyntaxException e) {
				System.err.println(e);
				System.exit(1);
			} catch(NullPointerException e) {} 		//exited via interrupt, chillax bro
			
			if(arr_in.length==2) {
				if(arr_in[0].equals("push")) {
					pu(arr_in[1],stack);
				}
				else if(arr_in[0].equals("view")) {
					if(arr_in[1].matches("\\d+")) {
						int ptroff=Integer.parseInt(arr_in[1]);	
						if(ptroff>stack.size() || ptroff<0) {
							System.out.println("bad pointer offset");
							continue;
						}

						String buffer=vis(ptroff,stack)+"\n";
						try {
							osw_out.write(buffer,0,buffer.length());
							osw_out.flush();
						} catch(IOException e) {
							System.err.println(e);
							System.exit(1);
						}
					}
					else {
						System.out.println("offset not whole #");
					}
				}
			}
			else if(arr_in.length==1) {
				if(arr_in[0].equals("pop")) {
					try {
						String buffer=po(stack);
						if(buffer==null) continue;
						osw_out.write(buffer+"\n",0,buffer.length()+1);
						osw_out.flush();
					} catch(IOException e) {
						System.err.println(e);
						System.exit(1);
					}
				}
				else if(arr_in[0].equals("peek")) { 		
					try {
						String buffer=pe(stack);
						if(buffer==null) continue;
						osw_out.write(buffer+"\n",0,buffer.length()+1);
						osw_out.flush();
					} catch(IOException e) {
						System.err.println(e);
						System.exit(1);
					}
				}
				else if(arr_in[0].equals("list")) {
					Object arr_temp[]=stack.toArray();
					String buffer=new String();
					if(arr_temp.length==0) continue;
					for(int i=arr_temp.length-1;i!=-1;i--) {
						buffer=buffer.concat(i+" "+(String)arr_temp[i]+"\n");
					}
					try {
						osw_out.write(buffer,0,buffer.length());
						osw_out.flush();
					} catch(IOException e) {
						System.err.println(e);
						System.exit(1);
					}
				}
				else {
					System.out.println("You suck!\nCommands: push [string],pop,peek,list,view [offset]");
				}
			}
			else {
				System.out.println("You suck!\nCommands: push [string],pop,peek,visual");
			}
		}
	}
	static void pu(String comp,Stack<String> stack) {
		stack.add(comp);
	}
	static String vis(int ptroff,Stack<String> stack) {
		if(stack.isEmpty()==true) {
			return null;
		}
		String temp=stack.get(stack.size()-ptroff-1);
		return temp;
	}
	static String po(Stack<String> stack) {
		if(stack.isEmpty()==true) {
			return null;
		}
		return stack.remove(stack.size()-1);
	}
	static String pe(Stack<String> stack) {
		if(stack.isEmpty()==true) {
			return null;
		}
		return stack.get(stack.size()-1);
	}
}
