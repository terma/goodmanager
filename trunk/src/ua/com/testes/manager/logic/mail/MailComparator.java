package ua.com.testes.manager.logic.mail;


import java.util.Comparator;


public final class MailComparator
        implements Comparator<MailItem> {

    public int compare(MailItem o1, MailItem o2) {

        return o2.getSend().compareTo(o1.getSend());

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailComparator
 * JD-Core Version:    0.6.0
 */