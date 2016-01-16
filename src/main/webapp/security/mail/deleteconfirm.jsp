<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityContact" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page import="ua.com.testes.manager.entity.mail.EntityMail" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Удаление сообщения - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    final int mailId = Integer.parseInt(request.getParameter("mailId"));
                    EntityMail mail = EntityManager.find(EntityMail.class, mailId);
                    EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                %>
                <td valign="center" align="center">
                    <a href="/security/mail/main.jsp">Назад</a>
                    <p>
                        <form action="/security/mail/delete.jsp">
                            <p>
                                Вы действительно хотите удалить сообщение
                            </p>
                            <input type="hidden" name="mailId" value="<%= mail.mailId %>">
                            <input type="submit" value="Удалить">
                        </form>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>