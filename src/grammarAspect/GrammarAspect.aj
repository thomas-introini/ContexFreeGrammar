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
			System.out.println(part.trim() + "->" + split[0].trim());
			t.simplifiedRules.put(part.trim(), split[0].trim());
		}
	}

	public boolean Grammar.check(String toCheck) throws InterruptedException {
		if (toCheck.length() == 1)
			return true;
		else {
			boolean atLeastOne = false;
			Iterator<String> values = simplifiedRules.keySet().iterator();
			while (values.hasNext()) {
				String value = values.next();
				
				if (toCheck.contains(value)) {
					toCheck = toCheck.replace(value,
							simplifiedRules.get(value));
					atLeastOne = true;
					System.out.println(toCheck);
				}


			}
			if (atLeastOne)
				return check(toCheck);
			else
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
}
