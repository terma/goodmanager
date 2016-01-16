package ua.com.testes.manager.logic.mail;

import ua.com.testes.manager.logic.mail.content.MailContent;

import java.util.List;

public interface MailProviderExchange extends MailProvider {

    List<MailFolder> getRootFolders();

    List<MailFolder> getFolders(String paramString);

    List<MailItem> getMessages(String paramString);

    MailItem getMessage(String paramString, int paramInt);

    List<MailContent> getContents(String paramString, int paramInt);

    void setMessageReaded(String paramString, int paramInt);

    void deleteMessage(String paramString, int paramInt);

}
