package ua.com.testes.manager.logic.mail;

import com.sun.mail.util.BASE64DecoderStream;
import ua.com.testes.manager.logic.mail.content.MailContent;
import ua.com.testes.manager.logic.mail.content.MailContentFile;
import ua.com.testes.manager.logic.mail.content.MailContentText;

import javax.mail.*;
import javax.mail.internet.AddressException;
import javax.mail.internet.MimeMultipart;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;

public class MailProviderExchangeImap4
        implements MailProviderExchange {
    private final Store store;

    public MailProviderExchangeImap4(String login, String password, String url)
            throws MailException {

        this.store = getStore(login, password, url);
    }

    public List<MailItem> getMessages() {

        List items = new ArrayList();
        try {

            Folder folder = this.store.getFolder("INBOX");

            folder.open(1);

            int messageNumber = 1;

            for (Message message : folder.getMessages()) {
                try {

                    items.add(new MailItem(message.getSentDate(), message.getSubject(), toAddressList(message.getFrom()), toAddressList(message.getAllRecipients()), messageNumber));


                    messageNumber++;
                } catch (AddressException exception) {

                    exception.printStackTrace();
                }
            }

            folder.close(false);
        } catch (MessagingException e) {

            throw new MailException(e);
        }
        try {

            this.store.close();
        } catch (MessagingException e) {

            throw new MailException(e);
        }

        return items;
    }

    public List<MailFolder> getRootFolders() {
        try {

            List mailFolders = new ArrayList();

            for (Folder folder : this.store.getFolder("").list()) {

                MailFolder mailFolder = new MailFolder();

                mailFolder.name = folder.getName();

                mailFolder.path = folder.getFullName();

                if (folder.getType() == 3) {

                    mailFolder.messages = folder.getMessageCount();

                    mailFolder.notReadMessages = folder.getNewMessageCount();

                    mailFolder.deleteMessages = folder.getDeletedMessageCount();
                }

                mailFolders.add(mailFolder);
            }

            return mailFolders;
        } catch (MessagingException e) {
            throw new MailException(e);
        }
    }

    public List<MailFolder> getFolders(String parentFolderName) {
        try {

            List mailFolders = new ArrayList();

            for (Folder folder : this.store.getFolder(parentFolderName).list()) {

                MailFolder mailFolder = new MailFolder();

                mailFolder.name = folder.getName();

                mailFolder.path = folder.getFullName();

                if (folder.getType() == 3) {

                    mailFolder.messages = folder.getMessageCount();

                    mailFolder.notReadMessages = folder.getNewMessageCount();

                    mailFolder.deleteMessages = folder.getDeletedMessageCount();
                }

                mailFolders.add(mailFolder);
            }

            return mailFolders;
        } catch (MessagingException e) {
            throw new MailException(e);
        }
    }

    public List<MailItem> getMessages(String folderName) {
        try {

            List mailItems = new ArrayList();

            Folder folder = this.store.getFolder(folderName);

            folder.open(1);

            int messageNumber = 1;

            for (Message message : folder.getMessages()) {

                MailItem mailItem = new MailItem(message.getSentDate(), message.getSubject(), toAddressList(message.getFrom()), toAddressList(message.getAllRecipients()), messageNumber);


                messageNumber++;

                mailItems.add(mailItem);
            }

            folder.close(false);

            return mailItems;
        } catch (MessagingException exception) {
            throw new MailException(exception);
        }

    }

    public MailItem getMessage(String folderName, int messageNumber) {
        try {

            Folder folder = this.store.getFolder(folderName);

            folder.open(1);

            Message message = folder.getMessage(messageNumber);
            try {

                MailItem localMailItem = new MailItem(message.getSentDate(), message.getSubject(), toAddressList(message.getFrom()), toAddressList(message.getAllRecipients()), messageNumber);
                return localMailItem;
            } finally {
                folder.close(false);
            }
        } catch (MessagingException exception) {
            throw new MailException(exception);
        }
    }

    public List<MailContent> getContents(String folderName, int messageNumber) {
        try {

            List mailContents = new ArrayList();

            Folder folder = this.store.getFolder(folderName);

            folder.open(1);

            getContentsInternal(folder.getMessage(messageNumber), mailContents);

            folder.close(false);

            return mailContents;
        } catch (MessagingException exception) {
            throw new MailException(exception);
        }
    }

    public void setMessageReaded(String folderName, int messageNumber) {
    }

    public void deleteMessage(String folderName, int messageNumber) {
    }

    private void getContentsInternal(Part messagePart, List<MailContent> mailContents) {
        try {

            Object content = messagePart.getContent();

            if ((content instanceof MimeMultipart)) {

                MimeMultipart mimeMultipart = (MimeMultipart) content;

                for (int i = 0; i < mimeMultipart.getCount(); i++)

                    getContentsInternal(mimeMultipart.getBodyPart(i), mailContents);
            } else if ((content instanceof String)) {

                MailContentText mailContentText = new MailContentText();

                mailContentText.text = ((String) content);

                mailContents.add(mailContentText);

            } else if ((content instanceof BASE64DecoderStream)) {

                MailContentFile mailContentFile = new MailContentFile();

                mailContentFile.name = messagePart.getFileName();

                mailContents.add(mailContentFile);
            }
        } catch (MessagingException exception) {

            throw new MailException(exception);
        } catch (IOException exception) {

            throw new MailException(exception);
        }
    }

    private List<String> toAddressList(Address[] addresses) {

        if (addresses == null) return Collections.emptyList();

        List addressList = new ArrayList(addresses.length);

        for (Address address : addresses) {

            addressList.add(address.toString());
        }

        return addressList;
    }


    private Store getStore(String login, String password, String url) {
        Properties properties = System.getProperties();

        properties.put("mail.imap.host", url);

        Session session = Session.getInstance(properties, new MailAuthenticator(login, password));
        Store store;
        try {
            store = session.getStore("imap");

            store.connect();
        } catch (NoSuchProviderException exception) {

            throw new MailException(exception);
        } catch (MessagingException exception) {

            throw new MailException(exception);
        }

        return store;
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.mail.MailProviderExchangeImap4
 * JD-Core Version:    0.6.0
 */