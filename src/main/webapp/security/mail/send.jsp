<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServerType" %>
<%@ page import="ua.com.testes.manager.entity.mail.server.EntityServer" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final List<EntityServer> servers = EntityManager.list(
            "select server from servers as server where server.type = :p0", EntityServerType.OUTBOX);
%>
<html>
    <head>
        <title>Отправка письма - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <% if (servers.isEmpty()) { %>
            <table width="100%" height="100%">
                <tr>
                    <td valign="center" align="center">
                        К сожалению написать письмо не представляеться возможным нет ни одного настроенного
                        сервера исходящей почты. Обратитесь к администратору или
                        <a href="/security/mail/main.jsp">вернитесь</a>.
                    </td>
                </tr>
            </table>
        <% } else { %>
            <p>
                Вернуться к <a href="/security/mail/main.jsp">письмам</a>
            </p>
            <form action="/security/mail/sendresult.jsp" method="post">
                <p><b>Письмо</b></p>
                <p>
                    Получатели (разделяя через , или ;):<br>
                    <input type="text" name="to" style="width: 80%">
                </p>
                <p>
                    Текст:<br>
                    <textarea rows="20" cols="" name="text" style="width: 80%"></textarea>
                </p>
                <p><input type="submit" name="" value="Отправить"></p>
            </form>
        <% } %>
    </body>
</html>