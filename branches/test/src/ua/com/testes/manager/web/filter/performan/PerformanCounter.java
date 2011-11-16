package ua.com.testes.manager.web.filter.performan;


public final class PerformanCounter {
    /*  5 */   private volatile long time = 0L;
    /*  6 */   private volatile int count = 0;


    public long getTime() {

        return this.time;

    }


    public int getCount() {

        return this.count;

    }


    public double getAverage() {

        return this.time / this.count;

    }


    public synchronized void increment(long delay) {

        this.time += delay;

        this.count += 1;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.performan.PerformanCounter
 * JD-Core Version:    0.6.0
 */