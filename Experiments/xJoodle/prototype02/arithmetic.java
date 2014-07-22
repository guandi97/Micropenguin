class math {
	public static String[] varSyms={
				"#",	//size of
				"$" 	//end of
					};
	public static Double[] varVals=new Double[varSyms.length];
	public final static String[] constSyms={
				"pi",	//
				"e",	//
					};
	public final static Double[] constVals={
				3.14,
				2.71,
					};	

	public static Double parser(String ln) {
		char[] lnArr=ln.toCharArray();
		double temp=0;
		double finn=0;
		int parflg=0;
		int sinflg=1;
		boolean numflg=false;
		boolean negflg=false;
		int i=0,j=0;

		if(!ln.matches("^\\d.*$|^(-|\\+)\\d.*$")) {
			System.err.println("syntax +- error");
			System.exit(0);
		}
		for(j=j;j<lnArr.length;j++) {
			if(numflg==true && ln.substring(j,j+1).matches("(\\D|\\[^\\.])")) { //!num
				numflg=false;
				System.err.format("i: %d j: %d finn: %d\n",i,j,(int)finn);
				temp=Double.parseDouble(ln.substring(i,j));

				if(sinflg==1) {
					System.err.println("+");
					finn+=temp;
				} else if(sinflg==2) {
					System.err.println("-");
					finn-=temp;
				} else if(sinflg==3) {
					System.err.println("*");
					finn*=temp;
				} else if(sinflg==4) {
					System.err.println("/");
					finn/=temp;
				}
				System.err.format("temp: %d finn: %d\n",(int)temp,(int)finn);
			}

			if(lnArr[j]=='+') {
				sinflg=1;
			} else if(lnArr[j]=='-') {
				sinflg=2;
			} else if(lnArr[j]=='*') {
				sinflg=3;
			} else if(lnArr[j]=='/') {
				sinflg=4;
			} else if(numflg==false && ln.substring(j,j+1).matches("(\\d|\\.)")) {
				i=j;
				numflg=true;
			}
		}
		temp=Double.parseDouble(ln.substring(i,j));
		if(sinflg==1) {
			System.err.println("+");
			finn+=temp;
		} else if(sinflg==2) {
			System.err.println("-");
			finn-=temp;
		} else if(sinflg==3) {
			System.err.println("*");
			finn*=temp;
		} else if(sinflg==4) {
			System.err.println("/");
			finn/=temp;	
		}
		System.err.format("temp: %d finn: %d\n",(int)temp,(int)finn);
		
		return finn;
	}
}
