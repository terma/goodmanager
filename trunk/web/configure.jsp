<%@ page import="ua.com.testes.manager.entity.user.EntityUser" %>
<%@ page import="ua.com.testes.manager.entity.EntityManager" %>
<%@ page import="java.util.List" %>
<%@ page import="ua.com.testes.manager.web.page.PageRuleError" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="ua.com.testes.manager.entity.EntityGroup" %>
<%@ taglib prefix="version" uri="/WEB-INF/tag/version.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Выбираем всех пользователей которые администраторы
    final List<EntityUser> adminUsers = EntityManager.list(
            "select user from ua.com.testes.manager.entity.user.EntityUser as user where group.id = 2");
    Set<PageRuleError> errors = (Set<PageRuleError>) request.getAttribute("errors");
    if (errors == null) {
        errors = new HashSet<PageRuleError>();
    }
    EntityGroup adminGroup = (EntityGroup) request.getAttribute("admingroup");
    EntityGroup userGroup = (EntityGroup) request.getAttribute("usergroup");
    EntityUser adminUser;
    if (userGroup == null) {
        userGroup = new EntityGroup();
    }
    if (adminGroup == null) {
        adminGroup = new EntityGroup();
    }
    if (adminGroup.users.isEmpty()) {
        adminUser = new ua.com.testes.manager.entity.user.EntityUser();
    } else {
        adminUser = adminGroup.users.get(0);
    }
%>
<html>
    <head>
        <title>Первый раз - Менджер <version:number/></title>
        <link type="text/css" href="/public/testes/style.css" rel="stylesheet">
    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
            <tr>
                <td width="10%">&nbsp;</td>
                <td valign="center">
                    <% if (adminUsers.isEmpty()) { %>
                        Пожалуй это первое использование программы для Вас, сейчас Мы попробуем создать
                        администратора системы, для этого заполните пожайлуста поля ниже
                        <p>
                            <form action="/startresult.jsp" method="post">
                                <p>
                                    <b>Реквизиты администратора системы</b>
                                </p>
                                Логин (например: admin)<br>
                                <% if (errors.contains(PageRuleError.USER_LOGIN_EMPTY)) { %>
                                    <b>Укажите логин администратора!</b><br>
                                <% } %>
                                <input type="text" name="adminlogin" value="<%= adminUser.getLogin() %>" style="width: 100%"><br>
                                Електронный адрес<br>
                                <input type="text" name="adminemail" value="<%= adminUser.getEmail() %>" style="width: 100%"><br>
                                ФИО<br>
                                <input type="text" name="adminfio" value="<%= adminUser.getFio() %>" style="width: 100%"><br>
                                Пароль<br>
                                <% if (errors.contains(PageRuleError.USER_PASSWORD_EMPTY)) { %>
                                    <b>Укажите пароль администратора!</b><br>
                                <% } %>
                                <input type="password" name="adminpassword" value="<%= adminUser.getPassword() %>" style="width: 100%"><br>
                                Подтверждение пароля<br>
                                <% if (errors.contains(PageRuleError.USER_PASSWORD_NOT_EQUAL)) { %>
                                    <b>Укажите правильно подтвердите пароль администратора!</b><br>
                                <% } %>
                                <input type="password" name="adminconfirmpassword" style="width: 100%"><br>
                                Название группы администраторов<br>
                                <% if (errors.contains(PageRuleError.GROUP_NAME_EMPTY)) { %>
                                    <b>Укажите название группы администраторов!</b><br>
                                <% } %>
                                <input type="text" name="admingroupname" value="<%= adminGroup.name %>" style="width: 100%"><br>
                                Название группы пользователей<br>
                                <% if (errors.contains(PageRuleError.GROUP_NAME_NOT_UNIQUE)) { %>
                                    <b>Укажите несовпадающие название!</b><br>
                                <% } %>
                                <input type="text" name="usergroupname" value="<%= userGroup.name %>" style="width: 100%"><br>
                                <p>
                                    <input type="submit" value="Согласен" name="">
                                </p>
                            </form>
                        </p>
                    <% } else { %>
                        К сожалению это робочая программа и Вас нужно или <a href="/login.jsp">авторизироваться</a>
                        для ее ипользования или обратиться к администратору.
                    <% } %>
                </td>
                <td width="10%">&nbsp;</td>
            </tr>
        </table>
    </body>
</html>