<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProduct" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicProductPriceError" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProductPrice" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityCurrency" %>
<%@ page import="ua.com.testes.manager.view.product.ViewCurrency" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final EntityProduct product = ViewProduct.getById(Integer.parseInt(request.getParameter("productid")));
%>
<html>
    <head>
        <title>Добавление продукта - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="<login:link value="/security/product/main.jsp"/>">продукции</a>,
        добавление цены на <%= product.name %> в категории
        <a href="<login:link value="<%= "/security/product/main.jsp?categoryId=" + product.category.id %>"/>"><%= product.category.name %></a>
        <%
            Set<LogicProductPriceError> errors = (Set<LogicProductPriceError>) request.getAttribute("errors");
            if (errors == null) {
                errors = new HashSet<LogicProductPriceError>();
            }
            EntityProductPrice productPrice = (EntityProductPrice) request.getAttribute("productprice");
            if (productPrice == null) {
                productPrice = new EntityProductPrice();
            }
        %>
        <p>
        <form action="/security/product/productpriceaddresult.jsp" method="post">
            <login:input/>
            <input type="hidden" name="productid" value="<%= product.id %>">
            <p><b>Реквизиты цены</b></p>
            <p>
                Валюта<br>
                <select name="currencyid" style="width: 80%">
                    <% for (final EntityCurrency currency : ViewCurrency.getAll()) { %>
                        <option <%= productPrice.currency != null && currency.id == productPrice.currency.id ? "checked" : "" %> value="<%= currency.id %>"><%= currency.name %> [<%= currency.label %>]</option>
                    <% } %>
                </select><br>
                Сумма<br>
                <% if (errors.contains(LogicProductPriceError.PRICE_INFINITE)) { %>
                    <b>Цена не может быть отрицательной!</b><br>
                <% } %>
                <input type="text" name="productpricevalue" value="<%= productPrice.value %>" style="width: 80%"><br>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>