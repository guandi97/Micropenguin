//static
import org.nfunk.jep.*;

class jepRprrr {
	private static JEP jep;
	static {
		jep=new JEP();
	}
	public static double exprParse(String ln) {
		jep.parseExpression(ln);
		return jep.getValue();
	}
}
