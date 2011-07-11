<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.logic.mail.MailFacade" %>
<%@ page import="ua.com.testes.manager.logic.mail.MailException" %>
<%@ page import="ua.com.testes.manager.logic.mail.MailItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm", request.getLocale());
    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
    if (user == null) return;
    if (!MailFacade.isUse(user)) return;
    List<MailItem> items = null;
    int mailItemCount = 0;
    // Проверяет требуеться ли обновить принудительно почтовый список
    final boolean refresh = "refresh".equalsIgnoreCase(request.getParameter("mail"));
    try {
        items = MailFacade.getItems(user, refresh);
        // Реальное количество
        mailItemCount = MailFacade.getCount(user, false);
    } catch (MailException exception) {
    }
    // Создаем сылку на обновление
    String refreshUrl = request.getRequestURI();
    if (request.getQueryString() != null) {
        refreshUrl += "?" + request.getQueryString() + "&";
    } else {
        refreshUrl += "?";
    }
    refreshUrl += "mail=refresh";
%>
<style type="text/css">

    .mailInfo {font-size: 12px}

</style>
<div style="background-color: #FFFCD0; padding: 5px">
    <% if (items != null) { %>
        <% if (mailItemCount == 0) { %>
            В вашем почтовом ящике (<a href="mailto:<%= user.getEmail() %>"><%= user.getEmail() %></a>) нет сообщений,
            <a href="<login:link value="<%= refreshUrl %>"/>">проверить</a> еще раз
        <% } else { %>
            В вашем почтовом ящике (<a href="mailto:<%= user.getEmail() %>"><%= user.getEmail() %></a>)
            <b><%= mailItemCount %></b>
            <% if (mailItemCount == 1) { %>
                входящие сообщение,
            <% } else { %>
                входящих сообщения,
            <% } %>
            <a href="<login:link value="<%= refreshUrl %>"/>">проверить</a> еще раз
            <ul style="list-style: none; padding: 0 px; margin-top: 5px; margin-bottom: 5px;">
                <% for (final ua.com.testes.manager.logic.mail.MailItem item : items) { %>
                    <li class="mailInfo">
                        К вам
                        <% if (item.getSend() == null) { %>
                            дата не определенна    
                        <% } else { %>
                            <%= format.format(item.getSend()) %>
                        <% } %>
                        <%= item.getSubject() %>
                        От
                        <% boolean first = true; %>
                        <% for (final String from : item.getFrom()) { %>
                            <% if (first) { %>
                                <% first = false; %>
                            <% } else { %>
                                ,
                            <% } %>
                            <a href="mailto:<%= from %>"><%= from %></a>
                        <% } %>
                    </li>
                <% } %>
            </ul>
        <% } %>
    <% } else { %>
        Извините за неудобство временно не удалось проверить вашу почту
        (<a href="mailto:<%= user.getEmail() %>"><%= user.getEmail() %></a>),
        <a href="<login:link value="<%= refreshUrl %>"/>">проверить</a> еще раз
    <% } %>
</div>

