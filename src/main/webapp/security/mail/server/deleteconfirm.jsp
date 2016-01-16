<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityContact" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Удаление почтового сервера - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    int serverId = Integer.parseInt(request.getParameter("serverId"));
                    EntityServer server = EntityManager.find(EntityServer.class, serverId);
                    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                %>
                <td valign="center" align="center">
                    <a href="/security/mail/server/list.jsp">Назад</a>
                    <p>
                        <% if (user.getGroup().id == 2) {  %>
                            <% if (server.mails.isEmpty()) { %>
                                <form action="/security/mail/server/delete.jsp">
                                    <p>
                                        Вы действительно хотите удалить сервер <%= server.login %>
                                    </p>
                                    <input type="hidden" name="serverId" value="<%= server.serverId %>">
                                    <input type="submit" value="Удалить">
                                </form>
                            <% } else { %>
                                К сожалению нельзя удалить сервер ведь у него есть почтовые сообщения.
                            <% } %>
                        <% } else { %>
                            К сожалению Вы не можете удалять почтовый сервер обратитесь к администратору.
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>