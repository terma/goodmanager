package ua.com.testes.manager.logic.mail;

import java.io.Serializable;

public final class MailFolder
        implements Serializable {
    public String name;
    public int messages;
    public int notReadMessages;
    public int deleteMessages;
    public String path;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailFolder
 * JD-Core Version:    0.6.0
 */