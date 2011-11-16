<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
%>
<html>
    <head>
        <title>Добавление пользователя - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <%
            final Set<PageRuleError> errors = (Set<PageRuleError>) request.getAttribute("errors");
            EntityUser newUser = (EntityUser) request.getAttribute("user");
            if (newUser == null) newUser = new EntityUser();
        %>
        К <a href="/security/rule.jsp">правам</a>
        <p>
        <form action="/security/useraddresult.jsp" method="post">
            <p><b>Данные пользователя</b>
            <p>
                Группа<br>
                <%
                    final List<EntityGroup> groups = EntityManager.list(
                        "select group from ua.com.testes.manager.entity.EntityGroup as group");
                %>
                <select name="usergroup" style="width: 80%">
                    <% for (final EntityGroup group : groups) { %>
                        <option value="<%= group.id %>" <%= newUser.getGroup() != null && newUser.getGroup().id == group.id ? "checked" : "" %>>№<%= group.id %> <%= group.name %></option>
                    <% } %>
                </select><br>
                ФИО (например: Пушкин Сергей Александрович)<br>
                <% if (errors != null && errors.contains(PageRuleError.USER_NAME_EMPTY)) { %>
                    <b>Введите пожайлусто ФИО пользователя!</b>
                <% } %>
                <input type="text" name="userfio" value="<%= newUser.getFio() %>" style="width: 80%"><br>
                Логин<br>
                <% if (errors != null && errors.contains(PageRuleError.USER_LOGIN_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальный логин!</b>
                <% } %>
                <% if (errors != null && errors.contains(PageRuleError.USER_LOGIN_EMPTY)) { %>
                    <b>Введите пожайлусто не пустой логин!</b>
                <% } %>
                <input type="text" name="userlogin" value="<%= newUser.getLogin() %>" style="width: 80%"><br>
                Пароль<br>
                <% if (errors != null && errors.contains(PageRuleError.USER_PASSWORD_NOT_EQUAL)) { %>
                    <b>Пароль не соответствует подтверждению!</b>
                <% } %>
                <input type="password" name="userpassword" value="<%= newUser.getPassword() %>" style="width: 80%"><br>
                Подтверждение пароля<br>
                <input type="password" name="userpasswordconfirm" value="<%= newUser.getPassword() %>" style="width: 80%"><br>
                Електропочта (например: admin@testes.com.ua)<br>
                <input type="text" name="useremail" value="<%= newUser.getEmail() %>" style="width: 80%"><br>
                Описание<br>
                <textarea rows="5" cols="" name="userdescription" style="width: 80%"></textarea>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>