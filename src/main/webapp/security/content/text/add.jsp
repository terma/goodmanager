<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.content.EntityText" %>
<%@ page import="ua.com.testes.manager.logic.content.TextError" %>
<%@ page import="java.util.Set" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
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
        <title>Добавление текста - Контент - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/content/text/main.jsp">текстам</a>
        <%
            final Set<TextError> errors = (Set<TextError>) request.getAttribute("errors");
            EntityText text = (EntityText) request.getAttribute("text");
            if (text == null) {
                text = new EntityText();
            }
        %>
        <p>
        <form action="/security/content/text/addresult.jsp" method="post">
            <login:input/>
            <p><b>Реквизиты текста</b></p>
            <p>
                Название<br>
                <% if (errors != null && errors.contains(TextError.NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название текста.</b><br>
                <% } %>
                <% if (errors != null && errors.contains(TextError.NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название текста.</b><br>
                <% } %>
                <input type="text" name="textname" value="<%= text.name %>" style="width: 80%"><br>
                Текст<br>
                <textarea rows="8" name="textdescription" cols="" style="width: 80%"><%= text.description %></textarea>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>