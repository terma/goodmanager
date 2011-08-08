package ua.com.testes.manager.logic.mail;


import java.io.Serializable;
import java.util.Date;
import java.util.List;


public class MailItem
        implements Serializable {
    private final int number;
    private final Date send;
    private final String subject;
    private final List<String> from;
    private final List<String> to;


    public MailItem(Date send, String subject, List<String> from, List<String> to, int number) {

        this.send = send;

        this.subject = subject;

        this.from = from;

        this.to = to;

        this.number = number;

    }


    public int getNumber() {

        return this.number;

    }


    public String getSubject() {

        return this.subject;

    }


    public List<String> getTo() {

        return this.to;

    }


    public List<String> getFrom() {

        return this.from;

    }


    public Date getSend() {

        return this.send;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailItem
 * JD-Core Version:    0.6.0
 */