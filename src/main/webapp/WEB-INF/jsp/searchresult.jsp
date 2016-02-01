<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="ua.com.testes.manager.entity.EntityContact" %>
<%@ page import="ua.com.testes.manager.entity.EntityFirm" %>
<%@ page import="ua.com.testes.manager.entity.EntityPipol" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<% request.setCharacterEncoding("utf-8"); %>
<%! private static final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy"); %>
<% final List<Object> result = (List) request.getAttribute("result"); %>
<%
  final List<String> emails = new ArrayList<String>();
    boolean first = true;
    for (final Object item : result) {
        if (item instanceof EntityFirm) {
            final EntityFirm firm = (EntityFirm) item;
            if (StringUtils.isNoneEmpty(firm.getEmail())) emails.add(firm.getEmail());
        }
    }
    final String emailsString =StringUtils.join(emails, ";");
%>
<html>
    <head>
        <title>Результаты поиска - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
    <a href="/security/search/search.jsp">Назад</a> к поиску<p>
    <p>
        <b>Найдено <%= result.size() %>
        </b> для строки <b><%= request.getParameter("text") %>
    </b>
        <% if (emailsString.length() > 0) { %>
        <a href="mailto:&bcc=<%= emailsString.toString() %>">написать</a> этим компаниям
        <% } %>
    </p>

    <% for (Object item : result) { %>
        <% if (item instanceof EntityFirm) { %>
            <% final EntityFirm firm = (EntityFirm) item; %>
            <a href="<%= "/security/detail.jsp?firmId=" + firm.getId() %>"><%= firm.getName() %></a><br>
        <% } else if (item instanceof EntityPipol) { %>
            <% final EntityPipol pipol = (EntityPipol) item; %>
            <%= pipol.getFio() %> из фирмы <a href="<%= "/security/detail.jsp?firmId=" + pipol.getFirm().getId() %>"><%= pipol.getFirm().getName() %></a><br>
        <% } else { %>
            <% final EntityContact contact = (EntityContact) item; %>
            От <%= format.format(contact.create) %> с <%= contact.pipol.getFio() %> из
            <a href="<%= "/security/detail.jsp?firmId=" + contact.pipol.getFirm().getId() %>"><%= contact.pipol.getFirm().getName() %></a><br>
        <% } %>
    <% } %>
    </body>
</html>