package ua.com.testes.manager.web.filter.performan;


import java.util.Collections;
import java.util.HashMap;
import java.util.Map;


public final class PerformanManager {
       private static final Map<String, PerformanCounter> counters = new HashMap();


    public static Map<String, PerformanCounter> get() {

        return Collections.unmodifiableMap(counters);

    }


    public static synchronized PerformanState start(String name) {

        PerformanCounter counter = (PerformanCounter) counters.get(name);

        if (counter == null) {

            counter = new PerformanCounter();

            counters.put(name, counter);

        }

        return new PerformanState(counter);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.performan.PerformanManager
 * JD-Core Version:    0.6.0
 */