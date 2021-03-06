<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page language='java' %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
    if (user.getGroup().id != 2) {
        response.sendRedirect("/security/main.jsp");
        return;
    }
%>
<html>
    <head>
        <title>Начало - Контент - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/security/util/mail/list.jsp" flush="true"/>
        <p>
            К <a href="/security/main.jsp">главной</a>
        </p>
        <p>
            Перейти к редактированию <a href="/security/content/text/main.jsp">текстов</a>
        </p>
    </body>
</html>