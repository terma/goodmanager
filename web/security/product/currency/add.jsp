<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityCurrency" %>
<%@ page import="ua.com.testes.manager.logic.product.LogicCurrencyError" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Добавление валюты - Валюта - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        К <a href="<login:link value="/security/product/currency/main.jsp"/>">валюте</a>
        <%
            Set<LogicCurrencyError> errors = (Set<LogicCurrencyError>) request.getAttribute("errors");
            if (errors == null) {
                errors = new HashSet<LogicCurrencyError>();
            }
            EntityCurrency currency = (EntityCurrency) request.getAttribute("currency");
            if (currency == null) {
                currency = new EntityCurrency();
            }
        %>
        <p>
        <form action="/security/product/currency/addresult.jsp" method="post">
            <login:input/>
            <p><b>Реквизиты валюты</b></p>
            <p>
                Название<br>
                <% if (errors.contains(LogicCurrencyError.NAME_EMPTY)) { %>
                    <b>Введите пожайлусто название валюты.</b><br>
                <% } %>
                <% if (errors.contains(LogicCurrencyError.NAME_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное название валюты.</b><br>
                <% } %>
                <input type="text" name="currencyname" value="<%= currency.name %>" style="width: 80%"><br>
                Сокращение (не больше 3 символов, например: uah)<br>
                <% if (errors.contains(LogicCurrencyError.LABEL_EMPTY)) { %>
                    <b>Введите пожайлусто сокращение валюты.</b><br>
                <% } %>
                <% if (errors.contains(LogicCurrencyError.LABEL_NOT_UNIQUE)) { %>
                    <b>Введите пожайлусто уникальное сокращение валюты.</b><br>
                <% } %>
                <input type="text" name="currencylabel" maxlength="3" value="<%= currency.label %>" style="width: 80%"><br>
            </p>
            <input type="submit" name="" value="Создать">
        </form>
    </body>
</html>