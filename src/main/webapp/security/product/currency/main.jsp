<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityCategory" %>
<%@ page import="ua.com.testes.manager.view.product.ViewCategory" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityProduct" %>
<%@ page import="ua.com.testes.manager.view.product.ViewProduct" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.IOException" %>
<%@ page import="ua.com.testes.manager.entity.product.EntityCurrency" %>
<%@ page import="ua.com.testes.manager.view.product.ViewCurrency" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
    final List<EntityCurrency> currencys = ViewCurrency.getAll();
%>
<html>
    <head>
        <title>Начало - Валюты - Продукция - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <p>
            К <a href="/security/main.jsp"/>">главной</a> к
            <a href="/security/product/main.jsp"/>">продуктам</a>
            <a href="/security/product/currency/add.jsp"/>">добавить</a> валюту
        </p>
        <% if (currencys.isEmpty()) { %>
            <p>
                Нет не одной валюты, соответственно нельзя будет указать цену товарам
            </p>
        <% } else { %>
            <ul>
                <% for (final EntityCurrency currency : currencys) { %>
                    <li>
                        <a href="<%= "/security/product/currency/delete.jsp?currencyid=" + currency.id %>"/>"><img
                                style="vertical-align: middle;" src="/image/delete.gif" alt="Удалить"
                                width="15" height="15" border="0"></a>
                        <%= currency.name %> [ <%= currency.label %>. ]
                    </li>
                <% } %>
            </ul>
        <% } %>
    </body>
</html>