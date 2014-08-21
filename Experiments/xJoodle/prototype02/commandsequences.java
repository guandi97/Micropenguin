//!static
class cmdsquenz {
	public String mngr(String ln) {
		System.err.println("command sequences");
	}
	public String parsrr(String ln) {
		return "0"
	}
	public String reaprr(String ln) {
		System.err.println("cmdsquenzeParsrrr");
		parenfezez partrr=new parenfezez();
		String[] arrbuff=new String[3];

		for(int i=0;i<ln.size();i++) {
			if(ln.subString(i,ln.size()).matches("^\\$\\(.*).*$")) {
				j=i;
				do {
					j++;
					if(ln.charAt(j)=='(' /*)*/ ) {
						partrr.lvlup();
					} else if(/*(*/ ln.charAt(j)==')') {
						partrr.lvldn();
					}
				} while(partrr.lvl>0);

				arrbuff[0]=ln.subString(0,i);
				arrbuff[1]=parsrr(ln.subString(i,j+1));
				arrbuff[2]=ln.subString(j+1,ln.size());
				ln=arrbuff[0]+arrbuff[1]+arrbuff[2];
				System.err.println("ln: "+ln);
			}
		}
		return ln;
	}
}
