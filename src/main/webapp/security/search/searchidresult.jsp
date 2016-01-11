<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityFirm" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<% request.setCharacterEncoding("utf-8"); %>
<html>
    <%
        final List<EntityFirm> firms = new ArrayList<EntityFirm>();
        try {
            final int firmId = Integer.parseInt(request.getParameter("text"));
            firms.addAll((List) EntityManager.list("select firm from FIRMS as firm where firm.id = :p0", firmId));
        } catch (final NumberFormatException exception) {
        }
    %>
    <head>
        <title>Результаты поиска - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
    <a href="/security/search/search.jsp"/>">Назад</a> к поиску<p>
            <p>
                <b>Найдено фирм <%= firms.size() %></b> для кода <b><%= request.getParameter("text") %></b>
            </p>
            <% for (final EntityFirm firm : firms) { %>
                <a href="<login:link value="<%= \"/security/detail.jsp?firmId=\" + firm.getId() %>"/>"><%= firm.getName() %></a><br>
            <% } %>
    </body>
</html>