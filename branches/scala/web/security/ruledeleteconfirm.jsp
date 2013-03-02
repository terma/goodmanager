<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Удаление разрешений - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    final int dependGroupId = Integer.parseInt(request.getParameter("dependGroupId"));
                    final int ownerGroupId = Integer.parseInt(request.getParameter("ownerGroupId"));
                    EntityRuleKey ruleId = new EntityRuleKey();
                    ruleId.depend = EntityManager.find(EntityGroup.class, dependGroupId);
                    ruleId.owner = EntityManager.find(EntityGroup.class, ownerGroupId);
                    final ua.com.testes.manager.entity.user.EntityUser user = EntityManager.find(EntityUser.class, session.getAttribute("userId"));
                %>
                <td valign="center" align="center">
                    <a href="/security/rule.jsp">Назад</a>
                    <p>
                        <% if (user.getGroup().id == 2) { %>
                            <form action="ruledelete.jsp">
                                <p>
                                    Вы действительно хотите удалить набор разрешений для от <%= ruleId.owner.name %>
                                    для <%= ruleId.depend.name %>?
                                </p>
                                <input type="hidden" name="dependGroupId" value="<%= dependGroupId %>">
                                <input type="hidden" name="ownerGroupId" value="<%= ownerGroupId %>">
                                <input type="hidden" name="rule" value="<%= request.getParameter("rule") %>">
                                <input type="submit" value="Удалить">
                            </form>
                        <% } else { %>
                            Вы не можете удалять набор безопасности, поскольку вы не входите
                            в группу безопасности.
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>