<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.entity.EntityPipol" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Удаление сотрудника - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    final int pipolId = Integer.parseInt(request.getParameter("pipolId"));
                    final EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                    final EntityPipol pipol = EntityManager.find(EntityPipol.class, pipolId);
                %>
                <td valign="center" align="center">
                    <% String link = "/security/detail.jsp?firmId=" + pipol.getFirm().getId(); %>
                    <a href="<%= link %>"/>">Назад</a>
                    <p>
                        <% if (user.getId() == pipol.getUser().getId()) { %>
                            <% if (pipol.getFirm().getPipols().size() > 1) { %>
                                <form action="pipoldelete.jsp">
                                    <login:input/>
                                    <p>
                                        Вы действительно хотите удалить сотрудника <%= pipol.getFio() %>
                                        из <%= pipol.getFirm().getName() %>?
                                    </p>
                                    <input type="hidden" name="pipolId" value="<%= pipol.getId() %>">
                                    <input type="submit" value="Удалить">
                                </form>
                            <% } else { %>
                                К сожалению нельзя удалить последнего сотрудника
                                <% String link1 = "/security/pipoladd.jsp?firmId=" + pipol.getFirm().getId(); %>
                                из <%= pipol.getFirm().getName() %>, создайте <a href="<%= link1 %>"/>">нового</a>, или вообще
                                <% String link2 = "/security/firmdeleteconfirm.jsp?firmId=" + pipol.getFirm().getId(); %>
                                удалите всю <a href="<%= link2 %>"/>">фирму</a>
                            <% } %>
                        <% } else { %>
                            К сожалению Вы не можете удалить сотрудника <%= pipol.getFio() %> из <%= pipol.getFirm().getName() %>
                            поскольку он другого менеджера (<a href="mailto:<%= pipol.getUser().getEmail() %>"><%= pipol.getUser().getFio() %></a>)
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>