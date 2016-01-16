package ua.com.testes.manager.web.filter.performance;


import java.util.Collections;
import java.util.HashMap;
import java.util.Map;


public final class PerformanceManager {

    private static final Map<String, PerformanceCounter> counters = new HashMap<String, PerformanceCounter>();

    public static Map<String, PerformanceCounter> get() {
        return Collections.unmodifiableMap(counters);
    }

    public static synchronized PerformanceState start(String name) {
        PerformanceCounter counter = counters.get(name);
        if (counter == null) {
            counter = new PerformanceCounter();
            counters.put(name, counter);
        }
        return new PerformanceState(counter);
    }
}