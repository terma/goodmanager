<%@ page language='java' %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityMail" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPart" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPartText" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityPartFile" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
//    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
//    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy hh:mm", request.getLocale());
    final EntityMail mail = EntityManager.find(EntityMail.class, Integer.parseInt(request.getParameter("mailId")));
%>
<html>
    <head>
        <title>Почта - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <p>
            К <a href="/security/main.jsp"/>">главной</a>,
            <a href="/security/mail/main.jsp"/>">список</a>
        </p>
        <% for (final EntityPart part : mail.parts) { %>
            <p>
                <% if (part instanceof EntityPartText) { %>
                    <% final EntityPartText partText = (EntityPartText) part; %>
                    <%= partText.text %>
                <% } else { %>
                    <% final EntityPartFile partFile = (EntityPartFile) part; %>
                    <%= partFile.name %>
                <% } %>
            </p>
        <% } %>
    </body>
</html>