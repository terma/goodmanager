package ua.com.testes.manager.logic.mail;

public abstract interface MailProviderFactory {
    public abstract MailProvider getProvider(String paramString1, String paramString2)
            throws MailException;
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailProviderFactory
 * JD-Core Version:    0.6.0
 */