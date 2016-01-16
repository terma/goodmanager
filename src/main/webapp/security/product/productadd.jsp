<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicProductError" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityCategory" %>
<%@ page import="ua.com.testes.manager.view.product.ViewCategory" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityCategory category = ViewCategory.getById(Integer.parseInt(request.getParameter("categoryId")));
%>
<html>
    <head>
        <title>Добавление продукта - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="/security/product/main.jsp"/>">продукции</a>,
        добавление продукта в категорию
        <a href="<%= "/security/product/main.jsp?categoryId=" + category.id %>"><%= category.name %></a>
        <%
            Set<LogicProductError> errors = (Set<LogicProductError>) request.getAttribute("errors");
            if (errors == null) {
                errors = new HashSet<LogicProductError>();
            }
            EntityProduct product = (EntityProduct) request.getAttribute("product");
            if (product == null) {
                product = new EntityProduct();
            }
        %>
        <p>
        <form action="/security/product/productaddresult.jsp" method="post">
            <input type="hidden" name="categoryid" value="<%= category.id %>">
            <p><b>Реквизиты продукции</b></p>
            <p>
                Название<br>
                <% if (errors.contains(LogicProductError.NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название продукта.</b><br>
                <% } %>
                <% if (errors.contains(LogicProductError.NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название продукта.</b><br>
                <% } %>
                <input type="text" name="productname" value="<%= product.name %>" style="width: 80%"><br>
                Описание<br>
                <textarea rows="5" cols="1" name="productdescription" style="width: 80%"><%= product.description %></textarea>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>