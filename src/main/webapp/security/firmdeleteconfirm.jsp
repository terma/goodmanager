<%@ page import="ua.com.testes.manager.entity.EntityFirm" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Удаление фирмы - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    final int firmId = Integer.parseInt(request.getParameter("firmId"));
                    EntityFirm firm = EntityManager.find(EntityFirm.class, firmId);
                    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                %>
                <td valign="center" align="center">
                    <% String link = "/security/list.jsp?sectionId=" + firm.getSection().getId() + "#firmId" + firm.getId(); %>
                    <a href="<%= link %>">Назад</a>
                    <p>
                        <% if (user.getId() == firm.getUser().getId()) { %>
                            <form action="firmdelete.jsp">
                                <login:input/>
                                <p>
                                    Вы действительно хотите удалить фирму <%= firm.getName() %>
                                    из <%= firm.getSection().getName() %>?
                                </p>
                                <input type="hidden" name="firmId" value="<%= firm.getId() %>">
                                <input type="submit" value="Удалить">
                            </form>
                        <% } else { %>
                            Вы не можете удалит фирму <%= firm.getName() %>
                            другого сотрудника (<a href="mailto:<%= firm.getUser().getEmail() %>"><%= firm.getUser().getFio() %></a>)
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>