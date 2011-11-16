<%@ page language='java' %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServerType" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.rule.EntityServerRule" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
    final List<EntityServer> servers = EntityManager.list("select server from servers as server");
%>
<html>
    <head>
        <title>Серверы - Почта - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <p>
            К <a href="<login:link value="/security/main.jsp"/>">главной</a>,
            <a href="<login:link value="/security/mail/main.jsp"/>">почта</a>,
            <a href="<login:link value="/security/mail/server/add.jsp"/>">добавить</a> сервер,
        </p>
        <ul style="list-style: none">
            <% for (final EntityServer server : servers) { %>
                <li>
                    <% if (server.type == EntityServerType.INBOX) { %>
                        <b><%= server.login %></b>@<a href="<%= server.url %>"><%= server.url %></a>
                        c паролем (<%= server.password %>)
                        <% if (server.type == EntityServerType.INBOX) { %>
                            <a href="<login:link value="<%= "/security/mail/server/rule/add.jsp?serverId=" + server.serverId %>"/>">добавить</a> получателя
                            , <a href="<login:link value="<%= "/security/mail/server/deleteconfirm.jsp?serverId=" + server.serverId %>"/>">удалить</a>
                        <% } %>
                        <% if (!server.rules.isEmpty()) { %>
                            <p>
                                Условия:
                                <ul>
                                    <% for (final EntityServerRule serverRule : server.rules) { %>
                                        <li>Получать для пользователя <a href="mailto:<%= serverRule.user.getEmail() %>"><%= serverRule.user.getFio() %></a></li>
                                    <% } %>
                                </ul>
                            </p>
                        <% } %>
                    <% } else { %>
                        Сервер отправки по адресу <a href="<%= server.url %>"><%= server.url %></a>,
                        логин <b><%= server.login %></b> и пароль <%= server.password %>,
                        <a href="<login:link value="<%= "/security/mail/server/deleteconfirm.jsp?serverId=" + server.serverId %>"/>">удалить</a>
                    <% } %>
                </li>
                <li>&nbsp;</li>
            <% } %>
        </ul>
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
                                <%--<!--Файл <a href="<login:link value="<%= "/security/mail/contentget.jsp?folderpath=" + folderPath + "&mesagenumber=" %>"/>"><%= mailContentFile.name %></a>-->--%>
                            <%--<% } %>--%>
                         <%--<% } %><br>--%>
                     <!--</td>-->
                 <!--</tr>-->
            <%--<% } %>--%>
    </body>
</html>