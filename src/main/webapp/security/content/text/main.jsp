<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.content.EntityText" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    // Выбираем тексты для просмотра
    final List<EntityText> texts = EntityManager.list("select text from texts as text");
%>
<html>
    <head>
        <title>Начало - Тексты - Контент - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <p>
            К <a href="/security/content/main.jsp">главной</a>,
            <a href="/security/content/text/add.jsp">добавить</a> текст
        </p>
        <% if (texts.isEmpty()) { %>
            <p>Нет не одного текста.</p>
        <% } else { %>
            <% for (final EntityText text : texts) { %>
                <p>
                    <a href="<%= "/security/content/text/edit.jsp?textId=" + text.id %>"/>"><%= text.name %></a><br>
                    <%= text.description %>
                </p>
            <% } %>
        <% } %>
    </body>
</html>