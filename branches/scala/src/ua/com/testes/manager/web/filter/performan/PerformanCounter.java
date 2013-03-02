package ua.com.testes.manager.web.filter.performan;


public final class PerformanCounter {

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

    public synchronized void increment(long delay) {
        time += delay;
        count += 1;
    }

}