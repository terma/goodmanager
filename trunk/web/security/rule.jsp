<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.EntityRule" %>
<%@ page import="ua.com.testes.manager.entity.EntityGroup" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="ua.com.testes.manager.web.filter.SessionListener" %>
<%@ taglib prefix="login" uri="/WEB-INF/tag/login.tld" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Права - Менеджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
        <style type="text/css">

            .userInfo, .ruleInfo {
                font-size: 12px;
                margin-left: 30px
            }

        </style>
    </head>
    <body>
        <%
            final EntityUser user = EntityManager.find(ua.com.testes.manager.entity.user.EntityUser.class, session.getAttribute("userId"));
        %>
        Вернуться к <a href="<login:link value="/security/main.jsp"/>">главной</a>
        <% if (user.getGroup().id == 2) { %>, добавить <a href="<login:link value="/security/useradd.jsp"/>">пользователя</a>
        добавить <a href="<login:link value="/security/groupadd.jsp"/>">группу</a>
        <p>
            <%
                    final List<EntityGroup> groups = EntityManager.list(
                        "select group from ua.com.testes.manager.entity.EntityGroup as group");
                %>
                <% for (EntityGroup group : groups) { %>
                    <p>
                        <%
                            final List<EntityUser> users = EntityManager.list(
                                "select user from ua.com.testes.manager.entity.user.EntityUser " +
                                        "as user where user.group.id = :p0", group.id);
                        %>
                        <a href="/security/groupdeleteconfirm.jsp?groupId=<%= group.id %>"><img
                                src="/image/delete.gif" border="0" alt="Удалить"
                                style="vertical-align: middle;"></a> Группа <%= group.name %> №<%= group.id %>
                        <table border="0" cellpadding="0" cellspacing="10">
                            <tr>
                                <td valign="top">
                                    Права на группу
                                    <ul style="list-style: none;">
                                        <% for (final EntityGroup tempGroup : groups) { %>
                                            <li>
                                                <%= tempGroup.name %> №<%= tempGroup.id %><br>
                                                <% final EntityRule rule = group.findRule(tempGroup); %>
                                                <div class="ruleInfo">
                                                    <% if (rule == null || !rule.statistic) { %>
                                                        <a href="/security/ruleaddresult.jsp?ownerGroupId=<%= group.id %>&dependGroupId=<%= tempGroup.id %>&rule=statistic"><img alt="Добавить право" style="vertical-align: middle;" src="/image/add.gif" height="15" width="15" border="0"></a>
                                                    <% } else { %>
                                                        <a href="/security/ruledeleteconfirm.jsp?ownerGroupId=<%= rule.id.owner.id %>&dependGroupId=<%= rule.id.depend.id %>&rule=statistic"><img alt="Удалить право" style="vertical-align: middle;" src="/image/delete.gif" height="15" width="15" border="0"></a>
                                                    <% } %>
                                                    Смотреть статистику.<br>
                                                    <% if (rule == null || rule.contract == null || !rule.contract.accept) { %>
                                                        <a href="/security/ruleaddresult.jsp?ownerGroupId=<%= group.id %>&dependGroupId=<%= tempGroup.id %>&rule=contractaccept"><img alt="Добавить право" style="vertical-align: middle;" src="/image/add.gif" height="15" width="15" border="0"></a>
                                                    <% } else { %>
                                                        <a href="/security/ruledeleteconfirm.jsp?ownerGroupId=<%= rule.id.owner.id %>&dependGroupId=<%= rule.id.depend.id %>&rule=contractaccept"><img alt="Удалить право" style="vertical-align: middle;" src="/image/delete.gif" height="15" width="15" border="0"></a>
                                                    <% } %>
                                                    Проверять договора.<br>
                                                    <% if (rule == null || rule.contract == null || !rule.contract.create) { %>
                                                        <a href="/security/ruleaddresult.jsp?ownerGroupId=<%= group.id %>&dependGroupId=<%= tempGroup.id %>&rule=contractcreate"><img alt="Добавить право" style="vertical-align: middle;" src="/image/add.gif" height="15" width="15" border="0"></a>
                                                    <% } else { %>
                                                        <a href="/security/ruledeleteconfirm.jsp?ownerGroupId=<%= rule.id.owner.id %>&dependGroupId=<%= rule.id.depend.id %>&rule=contractcreate"><img alt="Удалить право" style="vertical-align: middle;" src="/image/delete.gif" height="15" width="15" border="0"></a>
                                                    <% } %>
                                                    Создавать договора.
                                                </div>
                                            </li>
                                        <% } %>
                                    </ul>
                                </td>
                                <td valign="top">
                                    Члены группы, всего <%= users.size() %> 
                                    <% if (!users.isEmpty()) { %>
                                        <ul style="list-style: none; list-style-type:none;">
                                            <% for (EntityUser tempUser : users) { %>
                                                <li>
                                                    <a href="/security/userdeleteconfirm.jsp?userId=<%= tempUser.getId() %>"><img
                                                        style="vertical-align: middle;"
                                                        src="/image/delete.gif" width="15" height="15"
                                                        alt="Удалить" border="0"></a>
                                                        <a href="mailto:<%= tempUser.getEmail() %>"><%= tempUser.getFio() %></a>
                                                        в группу <a href="/security/usermove.jsp?userId=<%= tempUser.getId() %>">переместить</a>
                                                        <% if (SessionListener.isConnect(tempUser.getId())) { %>
                                                            , в системе, <a href="/security/ruleuserdisconnectresult.jsp?userId=<%= tempUser.getId() %>">отключить</a>
                                                        <% } %>
                                                    <div class="userInfo">
                                                        Логин: <%= tempUser.getLogin() %> Пароль: <%= tempUser.getPassword() %> <a href="/security/ruleuserchangepassword.jsp?userId=<%= tempUser.getId() %>">сменить</a><br>
                                                        <% if (tempUser.isBlock()) { %>
                                                            <a href="/security/userblockremove.jsp?userId=<%= tempUser.getId() %>">Заблокирован</a>, разблокировать<br>
                                                        <% } %>
                                                        <%= tempUser.getDescription() %>
                                                    </div>
                                                </li>
                                            <% } %>
                                        </ul>
                                    <% } %>
                                </td>
                            </tr>
                        </table>
                    </p>
                <% } %>
            </p>
        <% } else { %>
        <p>
            Вы из группы права <%= user.getGroup().name %> №<%= user.getGroup().id %>
            <% if (user.getGroup().id != 1) { %>
                <p>
                    У вас есть следующие права
                    <% for (EntityRule rule : user.getGroup().rules) { %>
                        <p>
                            На группу <%= rule.id.depend.name %> №<%= rule.id.depend.id %>
                            <ul>                                
                                <% if (rule.statistic) { %>
                                    <li>Можно просматривать статистику</li>
                                <% } %>
                            </ul>
                        </p>
                    <% } %>
                </p>
            <% } else { %>                
            <% } %>
        </p>
        <% } %>
    </body>
</html>