package ua.com.testes.manager.web.filter.performance;


final class PerformanceState {

    private final PerformanceCounter counter;
    private final long startTime;

    PerformanceState(PerformanceCounter counter) {
        this.counter = counter;
        this.startTime = System.currentTimeMillis();
    }

    public void finish() {
        this.counter.increment(System.currentTimeMillis() - this.startTime);
    }

}