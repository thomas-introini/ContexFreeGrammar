package grammarAspect;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import grammar.*;

public aspect GrammarAspect {

	public Map<String, String> Grammar.simplifiedRules;

	public void simplify(Grammar t, String rule) {
		String[] split = rule.split("=");
		if (split.length < 2)
			throw new IllegalArgumentException("Rule malformed: " + rule);
		String[] splitPipe = split[1].split("\\|");
		for (String part : splitPipe) {
			t.simplifiedRules.put(part.trim(), split[0].trim());
		}
	}

	public boolean Grammar.check(String toCheck) throws Exception {
		// System.out.println(toCheck);
		if (toCheck.equalsIgnoreCase(getFinalState()))
			return true;
		else {
			Iterator<String> values = simplifiedRules.keySet().iterator();
			while (values.hasNext()) {
				String value = values.next();
				if (toCheck.contains(value)) {
					if (check(toCheck
							.replace(value, simplifiedRules.get(value)))) {
						return true;
					}
				}
			}
			return false;
		}
	}

	after(Grammar t): execution(Grammar.new(..)) && this(t){
		t.simplifiedRules = new HashMap<>();
		Iterator<String> i = t.getRules().iterator();
		while (i.hasNext()) {
			simplify(t, i.next());
		}
	}

	boolean around(String toCheck): call(* Grammar.check(String)) && args(toCheck) && !this(Grammar){
		return proceed(toCheck + "E");
	}
}
