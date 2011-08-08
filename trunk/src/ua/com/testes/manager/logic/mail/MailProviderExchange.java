package ua.com.testes.manager.logic.mail;

import com.google.inject.ImplementedBy;
import ua.com.testes.manager.logic.mail.content.MailContent;

import java.util.List;

@ImplementedBy(MailProviderExchangeImap4.class)
public abstract interface MailProviderExchange extends MailProvider {
    public abstract List<MailFolder> getRootFolders();

    public abstract List<MailFolder> getFolders(String paramString);

    public abstract List<MailItem> getMessages(String paramString);

    public abstract MailItem getMessage(String paramString, int paramInt);

    public abstract List<MailContent> getContents(String paramString, int paramInt);

    public abstract void setMessageReaded(String paramString, int paramInt);

    public abstract void deleteMessage(String paramString, int paramInt);
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailProviderExchange
 * JD-Core Version:    0.6.0
 */