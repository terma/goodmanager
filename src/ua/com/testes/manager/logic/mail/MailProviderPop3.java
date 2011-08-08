package ua.com.testes.manager.logic.mail;


import javax.mail.*;
import javax.mail.internet.AddressException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;


class MailProviderPop3
        implements MailProvider {
    private final List<MailItem> items;


    private List<String> toAddressList(Address[] addresses) {

        if (addresses == null) return Collections.emptyList();

        List addressList = new ArrayList(addresses.length);

        for (Address address : addresses) {

            addressList.add(address.toString());

        }

        return addressList;
    }


    public MailProviderPop3(String login, String password, String url) throws MailException {
        Properties props = System.getProperties();

        props.put("mail.pop3.host", url);

        Session session = Session.getInstance(props, new MailAuthenticator(login, password));

        Store store;

        try {
            store = session.getStore("pop3");

            store.connect();

        } catch (NoSuchProviderException e) {

            throw new MailException(e);

        } catch (MessagingException e) {

            throw new MailException(e);

        }

        try {

            Folder folder = store.getFolder("INBOX");

            folder.open(1);

            this.items = new ArrayList();

            int i = 1;

            for (Message message : folder.getMessages()) {

                try {

                    this.items.add(new MailItem(message.getSentDate(), message.getSubject(), toAddressList(message.getFrom()), toAddressList(message.getAllRecipients()), i));


                    i++;

                } catch (AddressException exception) {

                    exception.printStackTrace();

                }

            }

            folder.close(false);

        } catch (MessagingException e) {

            throw new MailException(e);

        }

        try {

            store.close();

        } catch (MessagingException e) {

            throw new MailException(e);

        }
    }


    public List<MailItem> getMessages() {

        return this.items;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailProviderPop3
 * JD-Core Version:    0.6.0
 */