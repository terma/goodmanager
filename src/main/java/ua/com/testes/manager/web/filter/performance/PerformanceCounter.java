package ua.com.testes.manager.web.filter.performance;


public final class PerformanceCounter {

    private volatile long time = 0L;
    private volatile int count = 0;

    public long getTime() {
        return time;
    }

    public int getCount() {
        return count;
    }

    public double getAverage() {
        return count == 0 ? 0 : time / count;
    }

    synchronized void increment(long delay) {
        time += delay;
        count += 1;
    }

}