<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.*" %>
<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Удаление группы - Менеджер 1.0</title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <%
                    final int groupId = Integer.parseInt(request.getParameter("groupId"));
                    final EntityGroup group = EntityManager.find(EntityGroup.class, groupId);
                    final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
                    final List<EntityFirm> firms = EntityManager.list(
                            "select firm from ua.com.testes.manager.entity.EntityFirm " +
                                    "as firm where firm.user.group.id = :p0", group.id);
                    final List<EntityPipol> pipols = EntityManager.list(
                            "select pipol from ua.com.testes.manager.entity.EntityPipol " +
                                    "as pipol where pipol.user.group.id = :p0", group.id);
                    final List<EntityContact> contacts = EntityManager.list(
                            "select contact from ua.com.testes.manager.entity.EntityContact " +
                                    "as contact where contact.user.group.id = :p0", group.id);
                %>
                <td valign="center" align="center">
                    <a href="/security/rule.jsp">Назад</a>
                    <p>
                        <% if (user.getGroup().id == 2) { %>
                            <% if (firms.isEmpty() && contacts.isEmpty() && pipols.isEmpty()) { %>
                                <form action="groupdelete.jsp">
                                    <p>
                                        Вы действительно хотите удалить группу <%= group.name %>
                                        с <%= group.users.size() %> пользователями?<br>
                                        После этого ее нельзя будет востановить.
                                    </p>
                                    <input type="hidden" name="groupId" value="<%= group.id %>">
                                    <input type="submit" value="Удалить">
                                </form>
                            <% } else { %>
                                К сожалению в группе <%= group.name %> есть пользователи у которых аж<br>
                                <%= firms.size() %> фирм, <%= contacts.size() %> контактов, <%= pipols.size() %> сотрудников,<br>
                                и потому нельзя ее удалить.
                            <% } %>
                        <% } else { %>
                            Вы не можете удалит группу <%= group.name %>
                            так как у Вас нет прав. Вернуться к <a href="/security/main.jsp">главной</a>.
                        <% } %>
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>