<%@ page import="ua.com.testes.manager.entity.EntityStyle" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.logic.style.LogicStyle" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final List<EntityStyle> styles = EntityManager.list("select style from styles as style");
    final SimpleDateFormat format = new SimpleDateFormat("dd MMMM yy", request.getLocale());
%>
<html>
    <head>
        <title>Стили - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <p>
            Стили всего <%= styles.size() %>, вернуться на <a href="/security/main.jsp">главную</a>
            создать <a href="/security/style/add.jsp">новый</a> стиль
        </p>
        <ul>
            <% for (final EntityStyle style : styles) { %>
                <li>
                    <% String link1 = "/security/style/edit.jsp?styleid=" + style.id; %>
                    <%= LogicStyle.getHtml(style, style.name) %>, <a href="<%= link1 %>">редактировать</a>
                    <div class="info">
                        пользователь <a href="mailto:<%= style.owner.getEmail() %>"><%= style.owner.getFio() %></a>
                        от <%= format.format(style.create) %><br>
                        <% if (style.description.length() > 0 ) { %>
                            <%= style.description %>
                        <% } %>
                    </div>
                </li>
            <% } %>
        </ul>
    </body>
</html>