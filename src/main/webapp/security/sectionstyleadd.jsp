<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Редактирование стиля раздела - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <%
            final EntitySection section = EntityManager.find(EntitySection.class, Integer.parseInt(request.getParameter("sectionid")));
            final List<EntityStyle> styles = EntityManager.list("select style from styles as style");
        %>
        К <a href="/security/main.jsp"/>">главной</a>, примененние стиля к
        <a href="<login:link value='<%= "/security/list.jsp?sectionid=" + section.getId() %>'/>"><%= section.getName() %></a>
        <p>
        <form action="/security/sectionstyleaddresult.jsp" method="post">
            <login:input/>
            <input type="hidden" name="sectionid" value="<%= section.getId() %>">
            <p>
                Выберите стиль<br>
                <select name="styleid" style="width: 80%">
                    <option value="-1">Нет стиля</option>
                    <% for (final EntityStyle tempStyle : styles) { %>
                        <option <%= section.getStyle() != null && tempStyle.id == section.getStyle().id ? "selected" : "" %> value="<%= tempStyle.id %>"><%= LogicStyle.getHtml(tempStyle, tempStyle.name) %></option>
                    <% } %>
                </select>
            </p>
            <input type="submit" name="" value="Применить">
        </form>
    </body>
</html>