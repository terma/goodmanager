<%@ page import="java.util.Set" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicCategoryError" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityCategory" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.view.product.ViewCategory" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    EntityCategory parentCategory = null;
    try {
        parentCategory = ViewCategory.getById(
                Integer.parseInt(request.getParameter("parentcategoryid")));
    } catch (NumberFormatException exception) {

    }
%>
<html>
    <head>
        <title>Добавление категории - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="<login:link value="/security/product/main.jsp"/>">продукции</a>
        <% if (parentCategory != null) { %>
            , добавление подкатегории в категорию
            <a href="<login:link value="<%= "/security/product/main.jsp?categoryid=" + parentCategory.id %>"/>"><%= parentCategory.name %></a>
        <% } %>
        <%
            Set<LogicCategoryError> errors = (Set<LogicCategoryError>) request.getAttribute("errors");
            if (errors == null) {
                errors = new HashSet<LogicCategoryError>();
            }
            EntityCategory category = (EntityCategory) request.getAttribute("category");
            if (category == null) {
                category = new EntityCategory();
            }
        %>
        <p>
        <form action="/security/product/categoryaddresult.jsp" method="post">
            <login:input/>
            <% if (parentCategory != null) { %>
                <input type="hidden" name="parentcategoryid" value="<%= parentCategory.id %>">
            <% } %>
            <p><b>Реквизиты категории</b></p>
            <p>
                Название<br>
                <% if (errors.contains(LogicCategoryError.NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название категории.</b><br>
                <% } %>
                <% if (errors.contains(LogicCategoryError.NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название категории.</b><br>
                <% } %>
                <input type="text" name="categoryname" value="<%= category.name %>" style="width: 80%"><br>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>