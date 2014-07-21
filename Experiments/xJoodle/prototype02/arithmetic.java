class math implements mngr {
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

	public void mngr(String ln) {
		char[] lnArr=ln.toCharArray();
		double temp=0;
		double finn=0;
		int parflg=0;
		boolean numflg=false;
		boolean negflg=false;
		int i=0,j=0;

		if(lnArr[0]=='-') {
			negflg=true;
			j=1;
		}
		for(j=j;i<lnArr.length;i++) {
			if (
				numflg=true && (
				lnArr[j]!='0' ||
				lnArr[j]!='1' ||
				lnArr[j]!='2' ||
				lnArr[j]!='3' ||
				lnArr[j]!='4' ||
				lnArr[j]!='5' ||
				lnArr[j]!='6' ||
				lnArr[j]!='7' ||
				lnArr[j]!='8' ||
				lnArr[j]!='9' ||
				lnArr[j]!='.' )
				)
			{
				temp=Double.parseDouble(new String(lnArr,i,j-i));
				numflg=false;
				if(negflg==true) {
					temp*=-1;
					negflg=false;
				}
			}
			if(lnArr[j]=='(') /*)*/ {
				if(lnArr[j+1]=='-') {
					negflg=true;
					j++;
				}
				parflg++;
			} else if( /*(*/ lnArr[j]==')') {
				if(parflg<0) {
					System.err.println("math par error");
					System.exit(0);
				}
				else {
					parflg--;
				}
			} else if (
				numflg==false && (
				lnArr[j]=='0' ||
				lnArr[j]=='1' ||
				lnArr[j]=='2' ||
				lnArr[j]=='3' ||
				lnArr[j]=='4' ||
				lnArr[j]=='5' ||
				lnArr[j]=='6' ||
				lnArr[j]=='7' ||
				lnArr[j]=='8' ||
				lnArr[j]=='9' ||
				lnArr[j]=='.' )
				)

			{
				i=j;
				numflg=true;
			} else if(lnArr[j]=='+') {
				finn+=temp;
			} else if(lnArr[j]=='-') {
				finn-=temp;
			} else if(lnArr[j]=='*') {
				finn*=temp;
			} else if(lnArr[j]=='/') {
				finn/=temp;
			}
		}
	}
}
