<%@ page language='java' %>
<%@ page import="com.sun.mail.util.BASE64DecoderStream" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityMail" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPartFile" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPartText" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServerType" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.rule.EntityServerRule" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.AddressException" %>
<%@ page import="javax.mail.internet.MimeMultipart" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.concurrent.ConcurrentHashMap" %>
<%@ page import="java.util.concurrent.ConcurrentMap" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    // Результаты получения почты по датам
    private static final ConcurrentMap<Date, List<ServerResult>> serverResultsByDates =
            new ConcurrentHashMap<Date, List<ServerResult>>();

    private static class ServerResult {

        public EntityServer server;
        public List<EntityMail> mails = new ArrayList<EntityMail>();
        public List<Exception> mailExceptions = new ArrayList<Exception>();
        public Exception serverException;

    }

    private static final class MailAuthenticator extends Authenticator {

        private final String login;
        private final String password;

        public MailAuthenticator(final String login, final String password) {
            this.login = login;
            this.password = password;
        }

        public final PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(login, password);
        }

    }

    private static void getContentsInternal(
            final Part messagePart, final EntityMail mail) throws MessagingException, IOException {
        final Object content = messagePart.getContent();
        if (content instanceof MimeMultipart) {
            final MimeMultipart mimeMultipart = (MimeMultipart) content;
            for (int i = 0; i < mimeMultipart.getCount(); i++) {
                getContentsInternal(mimeMultipart.getBodyPart(i), mail);
            }
        } else if (content instanceof String) {
            final EntityPartText partText = new EntityPartText();
            partText.text = (String) content;
            mail.parts.add(partText);
            partText.mail = mail;
        } else if (content instanceof BASE64DecoderStream) {
            final EntityPartFile partFile = new EntityPartFile();
            partFile.name = messagePart.getFileName();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int readed = messagePart.getInputStream().read(buffer);
            while (readed > 0) {
                byteArrayOutputStream.write(buffer, 0, readed);
                readed = messagePart.getInputStream().read(buffer);
            }
            partFile.data = byteArrayOutputStream.toByteArray();
            System.out.println(byteArrayOutputStream.size() + " bytes");
            mail.parts.add(partFile);
            partFile.mail = mail;
        }
    }

    private static String toAddressString(final Address[] addresses) {
        if (addresses == null) return "";
        final StringBuffer stringBuffer = new StringBuffer();
        for (final Address address : addresses) {
            stringBuffer.append(address.toString());
        }
        return stringBuffer.toString();
    }

    private static final class MailReceiver extends Thread {

        public void run() {
            // Начинаем сесиию
            EntityManager.start();

            try {
                // Получаем список входящих серверов
                final List<EntityServer> servers = EntityManager.list(
                        "select server from servers as server where server.type = :p0", EntityServerType.INBOX);

                // Список ошибок произошедшых
                final List<ServerResult> serverResults = new ArrayList<ServerResult>();
                // Укладываем результаты в общию карту
                serverResultsByDates.put(new Date(), serverResults);

                // Перебираем серверы и получаем почту
                for (final EntityServer server : servers) {

                    final ServerResult serverResult = new ServerResult();
                    serverResult.server = server;
                    serverResults.add(serverResult);

                    final Properties properties = System.getProperties();
                    properties.put("mail.pop3.host", server.url);
                    final Session mailSession = Session.getInstance(
                            properties, new MailAuthenticator(server.login, server.password));
                    final Store store;
                    try {
                        store = mailSession.getStore("pop3");
                        store.connect();

                        EntityManager.execute(new EntityTransaction() {

                            public Object execute(final javax.persistence.EntityManager manager) {

                                try {
                                    final Folder folder = store.getFolder("INBOX");
                                    folder.open(Folder.READ_ONLY);
                                    for (final Message message : folder.getMessages()) {
                                        try {
                                            for (final EntityServerRule serverRule : server.rules) {
                                                final EntityMail mail = new EntityMail();
                                                mail.user = serverRule.user;
                                                mail.user.getMails().add(mail);
                                                mail.received = message.getReceivedDate();
                                                mail.sended = message.getSentDate();
                                                mail.server = server;
                                                mail.server.mails.add(mail);
                                                mail.theme = message.getSubject();
                                                mail.theme = mail.theme == null ? "" : mail.theme;
                                                mail.from = toAddressString(message.getFrom());
                                                mail.to = toAddressString(message.getAllRecipients());
                                                getContentsInternal(message, mail);
                                                manager.persist(mail);

                                                serverResult.mails.add(mail);

                                            }
                                        } catch (final AddressException exception) {
                                            serverResult.mailExceptions.add(exception);
                                        }
                                    }
                                    folder.close(false);
                                }
                                catch (MessagingException exception) {
                                    serverResult.mailExceptions.add(exception);
                                }
                                catch (IOException exception) {
                                    serverResult.mailExceptions.add(exception);
                                }
                                return null;
                            }

                        });

                        store.close();

                    }
                    catch (NoSuchProviderException exception) {
                        serverResult.serverException = exception;
                    } catch (MessagingException exception) {
                        serverResult.serverException = exception;
                    }
                }
            } finally {
                EntityManager.finish(false);
            }
        }

    }

%>
<%

    // Надим пользователя который работает
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));

    // Если надо проверить почту
    if (request.getParameter("now") != null) {
        new MailReceiver().start();
        response.sendRedirect("/security/mail/refreshresult.jsp");
    }

    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/mail/main.jsp");
    }

%>
<html>
    <head>
        <title>Лог почты - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <p>К <a href="/security/mail/main.jsp">письмам</a></p>
        <ul>
            <% for (final Date date : serverResultsByDates.keySet()) { %>
                <li>
                    <p>От <%= date %></p>
                    <ul>
                        <% for (final ServerResult serverResult : serverResultsByDates.get(date)) { %>
                            <li>
                                Адрес <a href="mailto:<%= serverResult.server.login + "@" +serverResult.server.url %>"><%= serverResult.server.login %>@<%= serverResult.server.url %></a>
                                <% if (serverResult.serverException != null) { %>
                                    Ошибка сервера <%= serverResult.serverException %><br>
                                <% } %>
                                <% if (!serverResult.mailExceptions.isEmpty()) { %>
                                    Ошибка сообщений <%= serverResult.mailExceptions %><br>
                                <% } %>
                                Полученно писем успешно <%= serverResult.mails.size() %>
                            </li>
                        <% } %>
                    </ul>
                </li>
            <% } %>
        </ul>
    </body>
</html>