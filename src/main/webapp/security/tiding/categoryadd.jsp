<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.logic.tiding.LogicTidingCategoryError" %>
<%@ page import="ua.com.testes.manager.entity.tiding.EntityTidingCategory" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление категории - Новости - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/tiding/main.jsp"/>">новостям</a>
        <%
            Set<LogicTidingCategoryError> errors = (Set<LogicTidingCategoryError>) request.getAttribute("errors");
            if (errors == null) {
                errors = new HashSet<LogicTidingCategoryError>();
            }
            EntityTidingCategory tidingCategory = (EntityTidingCategory) request.getAttribute("tidingcategory");
            if (tidingCategory == null) {
                tidingCategory = new EntityTidingCategory();
            }
        %>
        <p>
        <form action="/security/tiding/categoryaddresult.jsp" method="post">
            <login:input/>
            <p><b>Реквизиты категории новостей</b></p>
            <p>
                Название<br>
                <% if (errors.contains(LogicTidingCategoryError.NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название категории.</b><br>
                <% } %>
                <% if (errors.contains(LogicTidingCategoryError.NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название категории.</b><br>
                <% } %>
                <input type="text" name="tidingcategoryname"
                       value="<%= tidingCategory.name %>" style="width: 80%"><br>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>