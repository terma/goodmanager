package ua.com.testes.manager.logic.mail;

import com.google.inject.ImplementedBy;

import java.util.List;

@ImplementedBy(MailProviderPop3.class)
public abstract interface MailProvider {
    public abstract List<MailItem> getMessages();
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailProvider
 * JD-Core Version:    0.6.0
 */