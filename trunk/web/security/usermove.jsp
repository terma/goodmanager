<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final EntityUser moveUser = EntityManager.find(
            EntityUser.class, Integer.parseInt(request.getParameter("userId")));
    final List<EntityGroup> groups = EntityManager.list(
            "select group from ua.com.testes.manager.entity.EntityGroup as group where group.id != :p0", moveUser.getGroup().id);
%>
<html>
    <head>
        <title>Перемещение пользователя - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="<login:link value="/security/rule.jsp"/>">правам</a> перемещаемый пользователь
        <a href="mailto:<%= moveUser.getEmail() %>"><%= moveUser.getFio() %></a>
        <% if (groups.isEmpty()) { %>
            К сожалению в системе только одна группа пользователей и переместить
            этого пользователя некуда. Можно <a href="<login:link value="/security/groupadd.jsp"/>">создать</a>
            группу.
        <% } else { %>
            <form action="/security/usermoveresult.jsp" method="post">
                <p><b>Данные пользователя</b>
                <p>
                    Новая группа<br>
                    <select name="usergroupid" style="width: 80%">
                        <% for (final EntityGroup group : groups) { %>
                            <option value="<%= group.id %>">№<%= group.id %> <%= group.name %></option>
                        <% } %>
                    </select>
                </p>
                <input type="hidden" name="userid" value="<%= moveUser.getId() %>">
                <login:input/>
                <input type="submit" name="" value="Переместить">
            </form>
        <% } %>
    </body>
</html>