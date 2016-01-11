<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final List<EntityUser> users = EntityManager.list("select user from users as user");
%>
<html>
    <head>
        <title>Добавление правила - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <form action="/security/mail/server/rule/addresult.jsp" method="post">
            <login:input/>
            <p>
                <b>Правило</b>
            </p>
            <p>
                Пользователь получатель:<br>
                <select name="userId" style="vertical-align: middle; width: 80%">
                    <% for (final EntityUser user : users) { %>
                        <option value="<%= user.getId() %>"><%= user.getFio() %></option>
                    <% } %>
                </select>
            </p>
            <p>
                <input type="hidden" name="serverId" value="<%= request.getParameter("serverId") %>">
                <input type="submit" name="" value="Создать">
            </p>
        </form>
    </body>
</html>