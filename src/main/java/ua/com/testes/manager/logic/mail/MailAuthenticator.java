package ua.com.testes.manager.logic.mail;


import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;


final class MailAuthenticator extends Authenticator {
    private final String login;
    private final String password;


    public MailAuthenticator(String login, String password) {

        this.login = login;

        this.password = password;

    }


    public final PasswordAuthentication getPasswordAuthentication() {

        return new PasswordAuthentication(this.login, this.password);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailAuthenticator
 * JD-Core Version:    0.6.0
 */