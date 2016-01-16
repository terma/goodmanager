<%@ page language='java' %>
<%@ page import="com.sun.mail.util.BASE64DecoderStream" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityTransaction" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityMail" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPart" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPartFile" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPartText" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServerType" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.rule.EntityServerRule" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.logic.mail.MailException" %>
<%@ page import="javax.mail.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="com.sun.mail.smtp.SMTPMessage" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.activation.DataHandler" %>
<%@ page import="javax.activation.FileDataSource" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="com.sun.mail.smtp.SMTPAddressFailedException" %>
<%@ page import="java.net.ConnectException" %>
<%!

    final static class MailAuthenticator extends Authenticator {

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

    public static final String TEXT_PLAIN = "text/plain; charset=utf-8";
    public static final String TEXT_HTML = "text/html; charset=utf-8";

    private static final String CHARSET = "utf-8";
    private static final String TEXT_DEFAULT = "Sorry, your mail client does not support HTML mail";

    private static Pattern pattern = Pattern.compile("(?i)s(?:urvey)?ID=(\\d+)&(?:amp;)?u(?:ser)?ID=(\\d+).*");

    private static SMTPMessage getSMTPMessage(
            final Session mailSession, final String to, final String from, final String text) throws MailException {
        try {
            final SMTPMessage message = new SMTPMessage(mailSession);
//            setupHeaders(message, mail);
//            setupPriority(message, mail);
//            message.setSubject(encodeText(mail.theme));
            message.addFrom(new Address[] {new InternetAddress(from)});
            setupBody(message, text);
            setAddress(message, to);
            return message;
        }
        catch (MailException e) {
            throw e;
        }
        catch (Exception ex) {
            throw new MailException(ex);
        }
    }

//    private static void setupHeaders(final SMTPMessage message, final EntityMail mail) throws MessagingException {
//        message.setHeader("X-Mailer", "Java Mail 1.4");
//        message.setHeader("X-Cron-Env", "MultiThread email system. MTES-v3.2");
////        if (letter.getId() != null) {
////            message.setHeader("X-Id-Letter", String.valueOf(mail.mailId));
////        }
////        if (!AppUtil.isStringEmpty(letter.getDispositionNotificationTo())) {
////            message.setHeader("Disposition-Notification-To", letter.getDispositionNotificationTo());
////        }
//        message.setSentDate(new Date());
//    }

//    private static void setupPriority(SMTPMessage msg, final EntityMail mail) throws MessagingException {
////        switch (letter.getPriority()) {
////            case HIGH:
////                msg.setHeader("X-Priority", "2");
////                msg.setHeader("X-MSMail-Priority", "High");
////                msg.setHeader("Importance", "high");
////                break;
////            case NORMAL:
////                msg.setHeader("X-Priority", "3");
////                msg.setHeader("X-MSMail-Priority", "Normal");
////                break;
////            case LOW:
////                msg.setHeader("X-Priority", "4");
////                msg.setHeader("X-MSMail-Priority", "Low");
////                msg.setHeader("Importance", "low");
////                break;
////            default: //No PRIORITY
////                break;
////        }
//    }

    private static void setupBody(SMTPMessage message, final String text) throws MessagingException, MailException {
//        if (AppUtil.isStringEmpty(letter.getHtmlText())) {
//            if (containsAttachments(letter)) {
//                Multipart multipart = new MimeMultipart();
//                multipart.addBodyPart(createBodyPart(getSafePlainText(), TEXT_PLAIN));
//                addAttachments(multipart);
//                message.setContent(multipart);
//            } else {
//                message.setContent(getSafePlainText(), TEXT_PLAIN);
//            }
//        } else {
//            Multipart textMultipart = new MimeMultipart("alternative");
//            textMultipart.addBodyPart(createBodyPart(text, TEXT_PLAIN));
//            textMultipart.addBodyPart(createBodyPart(letter.getHtmlText(), TEXT_HTML)); // last has priority
//            message.setContent(createAttachmentsMultipart(createImagesMultipart(textMultipart)));
        message.setContent(text, TEXT_PLAIN);
//        }
    }

//    private String getSafePlainText() {
//        return letter.getPlainText() == null ? "" : letter.getPlainText();
//    }

    private static BodyPart createBodyPart(String content, String type) throws MessagingException {
        MimeBodyPart bodyPart = new MimeBodyPart();
        //bodyPart.addHeader("Content-Transfer-Encoding", "8bit");
        bodyPart.setContent(content, type);
        return bodyPart;
    }

    private BodyPart createBodyPart(Multipart multipart) throws MessagingException {
        MimeBodyPart bodyPart = new MimeBodyPart();
        bodyPart.setContent(multipart);
        return bodyPart;
    }

//    private static String createPlainText() {
//        return !AppUtil.isStringEmpty(letter.getPlainText())
//                ? letter.getPlainText()
//                : !AppUtil.isStringEmpty(letter.getHtmlText())
//                ? HtmlUtils.removeTags(letter.getHtmlText())
//                : TEXT_DEFAULT;
//    }

    private static Multipart createImagesMultipart(Multipart textMultipart) throws MessagingException {
//        initResourcePath(letter);
//        if (!containsImages(letter)) return textMultipart;
        Multipart multipart = new MimeMultipart("related");
//        multipart.addBodyPart(createBodyPart(textMultipart));
//        for (EmailAttachment attachment : letter.getAttachments()) {
//            if (!attachment.isImage()) continue;
//            File file;
//            try {
//                file = getVerifiedFile(attachment);
//            }
//            catch (MailException e) {
//                log.error("MailSender: removing bad image link from email: " + e.getMessage());
//                continue;
//            }
//            MimeBodyPart imageBodyPart = new MimeBodyPart() {
//                public void writeTo(OutputStream os) throws MessagingException, IOException {
//                    removeHeader("Content-Disposition");
//                    super.writeTo(os);
//                }
//            };
//            imageBodyPart.setDataHandler(new DataHandler(new FileDataSource(file)));
//            imageBodyPart.setHeader("Content-ID", normalizeContentID(attachment.getAttachFileName()));
//            imageBodyPart.setDisposition(Part.INLINE);
//            imageBodyPart.setFileName(encodeText(attachment.getRealFileName()));
//            multipart.addBodyPart(imageBodyPart);
//        }
        return multipart;
    }

    private Matcher squares = Pattern.compile("<+([^<>]+)>+").matcher("");

    String normalizeContentID(String cid) {
        squares.reset(cid);
        return "<" + (squares.find() ? squares.group(1) : cid) + ">";
        //return cid.matches("<+[^<>]+>+") ? cid.replaceAll("<+([^<>]+)>+", "<$1>") : "<" + cid + ">";
    }

    private static Multipart createAttachmentsMultipart(Multipart imagesMultipart) throws MessagingException, MailException {
//        if (!containsAttachments(letter)) return imagesMultipart;
        Multipart mixedMultipart = new MimeMultipart("mixed");
//        BodyPart bodyPart = new MimeBodyPart() {
//            public void writeTo(OutputStream os) throws MessagingException, IOException {
//                setRelatedPartType(this);
//                super.writeTo(os);
//            }
//        };
//        bodyPart.setContent(imagesMultipart);
//        mixedMultipart.addBodyPart(bodyPart);
//        addAttachments(mixedMultipart);
        return mixedMultipart;
    }

//    public static boolean containsAttachments(EmailLetter letter) {
//        for (EmailAttachment attachment : letter.getAttachments()) {
//            if (!attachment.isImage()) return true;
//        }
//        return false;
//    }

//    private void addAttachments(Multipart multipart) throws MessagingException, MailException {
//        // НЕ УДАЛЯТЬ!!
//        /*Matcher matcher= pattern.matcher(letter.getGroup().getComment());
//     if(!matcher.find()){
//       return;
//     }
//
//     long surveyId=AppUtil.getLongValue(matcher.group(1));
//     long userId=AppUtil.getLongValue(matcher.group(2));
//
//     rp = new ResourcePathBase(surveyId,userId);*/
//
//        for (EmailAttachment attachment : letter.getAttachments()) {
//            if (attachment.isImage()) continue;
//            MimeBodyPart bodyPart = new MimeBodyPart();
//            bodyPart.setDataHandler(new DataHandler(new FileDataSource(getVerifiedFile(attachment))));
//            bodyPart.setDisposition(Part.ATTACHMENT);
//            bodyPart.setDescription("Attached file: " + attachment.getAttachFileName());
//            bodyPart.setFileName(encodeText(attachment.getAttachFileName()));
//            multipart.addBodyPart(bodyPart);
//        }
//    }

    private static String encodeText(final String s) {
        if (s == null) return "";
        try {
            return MimeUtility.encodeText(s, CHARSET, null);
        }
        catch (Exception ex) {
            return s;
        }
    }

//    public static File getVerifiedFile(EmailAttachment attachment) throws MailException {
//        File file = new File(SiteConfig.getUserDirPath() + attachment.getRealFileName());
//        log.info("Try to verify file " + file.getAbsolutePath() + " " + (file.isFile() && file.canRead() ? "can read" : "can't read or it is a directory"));
//        if (file.isFile() && file.canRead()) {
//            return file;
//        }
//        throw new MailException(attachment.getRealFileName(), MailTransport.ATTACHFILE_NOTFOUND);
//    }

//    private static void setRelatedPartType(Part part) throws MessagingException {
//        String headers[] = part.getHeader("Content-Type");
//        if (headers == null || AppUtil.isStringEmpty(headers[0])) return;
//        String header = headers[0];
//        if (header.indexOf("part/related") < 0 || header.indexOf("part/alternative") > -1) return;
//        int pos = header.indexOf("boundary");
//        if (pos < 0) return;
//        // double quotes around "multipart/alternative" are required for Yahoo
//        String contentType = header.substring(0, pos) +
//                "type=\"multipart/alternative\";" + ((char) 10) + ((char) 9) +
//                header.substring(pos);
//        part.setHeader("Content-Type", contentType);
//    }

    private static void sendMessage(final Session mailSession, String to, String from, String text) throws MailException {
        try {
            Transport.send(getSMTPMessage(mailSession, to, from, text));
        } catch (MessagingException ex) {
            throw new MailException(ex);
        }
        catch (RuntimeException ex) {
            throw new MailException(ex);
        }
    }
//
//    public ByteArrayOutputStream writeMessageToStream() throws MessagingException, MailException {
//        ByteArrayOutputStream stream = new ByteArrayOutputStream(1024);
//        try {
//            getSMTPMessage().writeTo(stream);
//        }
//        catch (IOException e) {
//            throw new MailException(e.getMessage());
//        }
//        return stream;
//    }

    private void addInfo(String type, Address[] addresses, StringBuilder builder) {
        if (addresses == null) return;
        builder.append("\n\n** ").append(type).append(" addresses: ");
        for (Address anInvalid : addresses) {
            builder.append("\n").append(anInvalid);
        }
    }

    private static void setAddress(SMTPMessage message, final String to) throws MessagingException, MailException {
        final StringTokenizer stringTokenizer = new StringTokenizer(to, ";");
        while (stringTokenizer.hasMoreTokens()) {
            final String token = stringTokenizer.nextToken();
            message.setRecipients(MimeMessage.RecipientType.TO, token);
        }

//        StringBuilder invalidAddress = new StringBuilder(1024);
//        Address[] adrTo = ValidateEmailAddress.getCorrectAddress(letter.getTo(), invalidAddress);
//        Address[] adrCc = ValidateEmailAddress.getCorrectAddress(letter.getCc(), invalidAddress);
//        Address[] adrBcc = ValidateEmailAddress.getCorrectAddress(letter.getBcc(), invalidAddress);
//        if (adrTo == null && adrCc == null && adrBcc == null) {
//            invalidAddress.insert(0, "All address fields are empty!");
//            throw new MailException(invalidAddress.toString(), MailTransport.ADDR_RECIPIENT_NONE_VALID);
//        }
//        if (adrTo != null) {
//            message.setRecipients(MimeMessage.RecipientType.TO, adrTo);
//        }
//        if (adrCc != null) {
//            message.addRecipients(MimeMessage.RecipientType.CC, adrCc);
//        }
//        if (adrBcc != null) {
//            message.setRecipients(MimeMessage.RecipientType.BCC, adrBcc);
//        }
//        Address[] adrFrom = ValidateEmailAddress.getCorrectAddress(letter.getFrom(), invalidAddress);
//        if (adrFrom != null) {
//            message.addFrom(adrFrom);
//        } else {
//            message.setFrom(InternetAddress.getLocalAddress(session));
//        }
//        Address[] adrReplyTo = ValidateEmailAddress.getCorrectAddress(letter.getReplyTo(), invalidAddress);
//        if (adrReplyTo != null) {
//            message.setReplyTo(adrReplyTo);
//        }
//        Address[] adrUndeliveredTo = ValidateEmailAddress.getCorrectAddress(letter.getUndeliveredTo(), invalidAddress);
//        if (adrUndeliveredTo != null) {
//            message.setEnvelopeFrom(new InternetAddress(adrUndeliveredTo[0].toString()).getAddress());
//        }
//        if (!AppUtil.isStringEmpty(invalidAddress)) {
//            invalidAddress.insert(0, "Invalid address: ");
//            log.error(invalidAddress.toString());
//            throw new MailException(invalidAddress.toString(), MailTransport.ADDR_WARNING_NOT_VALID);
//        }
//        String dnsIncorrect = ValidateEmailAddress.checkDNS(message.getAllRecipients());
//        if (dnsIncorrect != null) {
//            log.fatal("All addresses are incorrect among [" + StringUtils.arrayToCSV(message.getAllRecipients(), ",", "") + "]");
//            //throw new MailException(dnsIncorrect, MailTransport.DOMAIN_NOT_EXIST);
//        }
    }

%>
<%
    EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final List<EntityServer> servers = EntityManager.list(
            "select server from servers as server where server.type = :p0", EntityServerType.OUTBOX);
    if (!servers.isEmpty()) {
        final EntityServer server = servers.get(0);
        final Properties properties = System.getProperties();
        properties.put("mail.smtp.host", server.url);
        final Session mailSession = Session.getInstance(
                properties, new MailAuthenticator(server.login, server.password));
//        final Transport transport;
//        try {
//            transport = mailSession.getTransport();
//            transport.connect();
//        }
//        catch (NoSuchProviderException exception) {
//            throw new MailException(exception);
//        } catch (MessagingException exception) {
//            throw new MailException(exception);
//        }
        sendMessage(mailSession, request.getParameter("to"), server.login + "@" + server.url, request.getParameter("text"));
    }

//    for (final EntityServer server : servers) {
//        final Properties properties = System.getProperties();
//        properties.put("mail.pop3.host", server.url);
//        final Session mailSession = Session.getInstance(
//                properties, new MailAuthenticator(server.login, server.password));
//        final Store store;
//        try {
//            store = mailSession.getStore("pop3");
//            store.connect();
//        }
//        catch (NoSuchProviderException exception) {
//            throw new MailException(exception);
//        } catch (MessagingException exception) {
//            throw new MailException(exception);
//        }
//        EntityManager.execute(new EntityTransaction() {
//
//            public Object execute(javax.persistence.EntityManager manager) {
//                try {
//                    final Folder folder = store.getFolder("INBOX");
//                    folder.open(Folder.READ_ONLY);
//                    for (final Message message : folder.getMessages()) {
//                        try {
////                    items.add(new MailItem(
////                            message.getSentDate(), message.getSubject(), toAddressList(message.getFrom()),
////                            toAddressList(message.getAllRecipients()), messageNumber));
//                            for (final EntityServerRule serverRule : server.rules) {
//                                final EntityMail mail = new EntityMail();
//                                mail.user = serverRule.user;
//                                mail.user.mails.add(mail);
//                                mail.received = message.getReceivedDate();
//                                mail.sended = message.getSentDate();
//                                mail.server = server;
//                                mail.server.mails.add(mail);
//                                mail.theme = message.getSubject();
//                                mail.theme = mail.theme == null ? "" : mail.theme;
//                                mail.from = toAddressString(message.getFrom());
//                                mail.to = toAddressString(message.getAllRecipients());
//                                mail.created = message.getSentDate();
//                                getContentsInternal(message, mail);
//                                manager.persist(mail);
//                            }
//                        } catch (final AddressException exception) {
//                            exception.printStackTrace();
//                        }
//                    }
//                    folder.close(false);
//                }
//                catch (MessagingException e) {
//                    throw new MailException(e);
//                }
//                catch (IOException e) {
//                    throw new MailException(e);
//                }
//                try {
//                    store.close();
//                } catch (MessagingException e) {
//                    throw new MailException(e);
//                }
//                return null;
//            }
//
//        });
//    }
    response.sendRedirect("/security/mail/main.jsp");
%>