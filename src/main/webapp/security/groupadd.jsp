<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление группы безопасности - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <%
            Set<PageRuleError> errors = (Set<PageRuleError>) request.getAttribute("errors");
            EntityGroup group = (EntityGroup) request.getAttribute("group");
            if (group == null) group = new EntityGroup();
        %>
        К <a href="/security/rule.jsp">правам</a>
        <p>
        <form action="/security/groupaddresult.jsp" method="post">
            <p><b>Данные группы</b>
            <p>
                Название<br>
                <% if (errors != null && errors.contains(PageRuleError.GROUP_NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название группы!</b>
                <% } %>
                <% if (errors != null && errors.contains(PageRuleError.GROUP_NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название группы!</b>
                <% } %>
                <input type="text" name="groupname" value="<%= group.name %>" style="width: 80%">
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>