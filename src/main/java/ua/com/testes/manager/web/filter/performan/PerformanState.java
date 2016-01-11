package ua.com.testes.manager.web.filter.performan;


public final class PerformanState {
    private final PerformanCounter counter;
    private long startTime;


    PerformanState(PerformanCounter counter) {
/*  9 */
        this.counter = counter;

        this.startTime = System.currentTimeMillis();

    }


    public void finish() {

        this.counter.increment(System.currentTimeMillis() - this.startTime);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.performan.PerformanState
 * JD-Core Version:    0.6.0
 */