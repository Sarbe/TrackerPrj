package util;

import java.util.List;

public class Util {

	public static String listToCommaSeparatedValue(List lst) {
		String str = "";
		for (int i = 0; i < lst.size(); i++) {
			if (i == 0)
				str += "'"+lst.get(i)+"'";
			else
				str += ",'"+lst.get(i)+"'";
		}
		return str;
	}
}
