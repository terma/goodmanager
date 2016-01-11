package ua.com.testes.manager.page;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class PageStatistic
        implements Serializable {
    public List<Integer> sectionIds = new ArrayList();
    public List<Integer> statusIds = new ArrayList();
    public List<Integer> userIds = new ArrayList();
    public boolean period = false;
    public Date start = new Date();
    public Date finish = new Date(this.start.getTime() + 86400000L);


    public static enum Error {
        INCORRECT_DATE, START_AFTER_FINISH_DATE;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.page.PageStatistic
 * JD-Core Version:    0.6.0
 */