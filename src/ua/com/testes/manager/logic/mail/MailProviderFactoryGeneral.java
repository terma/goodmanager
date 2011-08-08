package ua.com.testes.manager.logic.mail;


public class MailProviderFactoryGeneral
        implements MailProviderFactory {
    private final String url;


    public MailProviderFactoryGeneral(String url) {

        if (url == null) {

            throw new NullPointerException();

        }

        this.url = url;

    }


    public MailProvider getProvider(String login, String password) throws MailException {

        return new MailProviderPop3(login, password, this.url);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailProviderFactoryGeneral
 * JD-Core Version:    0.6.0
 */