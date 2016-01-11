<%@ page language='java' %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityMail" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%!

    private static String trimTo(final String string, final int size) {
        if (string.length() > size) {
            return string.substring(0, size) + "...";
        }
        return string;
    }

    private static final Comparator<EntityMail> byReceived = new Comparator<EntityMail>() {

        public int compare(EntityMail o1, EntityMail o2) {
            if (o1.received == null) {
                if (o2.received == null) {
                    return 0;
                }
                return -1;
            }
            return o2.received.compareTo(o1.received);
        }

    };

%>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm", request.getLocale());
    final List<EntityMail> mails = new ArrayList<EntityMail>(user.getMails());
    Collections.sort(mails, byReceived);
%>
<html>
    <head>
        <title>Почта - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <script type="text/javascript">

            function selectForDeleteAll() {
                var i = 0;
                while (document.getElementById("mail" + i)) {
                    document.getElementById("mail" + i).checked = true;
                    i++;
                }
            }

        </script>
    </head>
    <body>
        <p>
            К <a href="/security/main.jsp"/>">главной</a>,
            <a href="/security/mail/refreshresult.jsp?now=true"/>">проверить</a>,
            <a href="/security/mail/send.jsp"/>">написать</a>
            <% if (user.getGroup().id == 2) { %>
                <a href="/security/mail/server/list.jsp"/>">серверы</a>,
                <a href="/security/mail/refreshresult.jsp"/>">лог</a>
            <% } %>
        </p>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top">
                    <% if (!user.getMails().isEmpty()) { %>
                        <form action="/security/mail/delete.jsp">
                            <p>
                                <input type="submit" name="submit" value="Удалить">, выбрать <a href="javascript:selectForDeleteAll()">все</a>
                            </p>
                            <table border="0" cellpadding="0" cellspacing="10">
                                <thead>
                                    <tr>
                                        <td></td>
                                        <td>Получено</td>
                                        <td>Тема</td>
                                    </tr>
                                </thead>
                                <% int i = 0; %>
                                <% for (final EntityMail mail : mails) { %>
                                    <tr>
                                        <td>
                                            <input type="checkbox" name="mailId" id="mail<%= i++ %>" value="<%= mail.mailId %>">
                                        </td>
                                        <td>
                                            <%= mail.received == null ? "Неизвестно" : "Получено " + format.format(mail.received) %>
                                        </td>
                                        <td><a href="<%= "/security/mail/detail.jsp?mailId=" + mail.mailId %>"/>"><%= trimTo(mail.theme, 70) %></a></td>
                                    </tr>
                                <% } %>
                            </table>
                        </form>
                    <% } else { %>
                        В этой папке нет сообщений.
                    <% } %>
                </td>
            </tr>
            <%--<% if (mailContents != null) { %>--%>
                 <!--<tr>-->
                     <!--<td colspan="2">-->
                         <%--<%--<p>--%>
                             <%--<%--<br>Кому--%>
                             <%--<%--<% boolean first = true; %>--%>
                             <%--<%--<% for (String to : mailItem.getTo()) { %>--%>
                                <%--<%--<%= first ? "" : "," %>--%>
                                <%--<%--<% first = false; %>--%>
                                <%--<%--<%= to %>--%>
                             <%--<%--<% } %>--%>
                         <%--<%--</p>--%>
                         <%--<% for (final MailContent mailContent : mailContents) { %>--%>
                            <%--<% if (mailContent instanceof MailContentText) { %>--%>
                                <%--<%= ((MailContentText) mailContent).text %>--%>
                            <%--<% } else if (mailContent instanceof MailContentFile) { %>--%>
                                <%--<% final MailContentFile mailContentFile = (MailContentFile) mailContent; %>--%>
                                <%--<!--Файл <a href="<%= "/security/mail/contentget.jsp?folderpath=" + folderPath + "&mesagenumber=" %>"/>"><%= mailContentFile.name %></a>-->--%>
                            <%--<% } %>--%>
                         <%--<% } %><br>--%>
                     <!--</td>-->
                 <!--</tr>-->
            <%--<% } %>--%>
        </table>
    </body>
</html>